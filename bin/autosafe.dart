#!/usr/bin/env dart

import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    print('''
AutoSafe JSON CLI
=================

Usage:
  autosafe <path_to_model.dart>

First time setup:
  dart pub global activate autosafe_json

Examples:
  autosafe lib/models/user_response.dart
  autosafe lib/data/models/product_response.dart

What it does:
  ✓ Inserts `json = json.autoSafe.raw;` in the base factory
  ✓ Preserves your declared primitive types while adding SafeJson helpers
  ✓ Wraps nested objects/lists with `SafeJson.asMap` / `SafeJson.asList`
  ✓ Expands arrow factories into block factories when needed
  ✓ Cleans up null checks and redundant `?.toDouble()` style conversions

Remember to import:
  import 'package:autosafe_json/autosafe_json.dart';
''');
    exit(1);
  }

  final filePath = args[0];
  final file = File(filePath);

  if (!file.existsSync()) {
    print('Error: File not found: $filePath');
    exit(1);
  }

  print('Processing: $filePath');

  try {
    String content = file.readAsStringSync();

    content = addAutoSafeImport(content);
    content = transformFieldTypes(content);
    content = removeNestedAutoSafeCalls(content);
    content = addAutoSafeCall(content);
    content = wrapObjectsAndLists(content);
    content = wrapPrimitiveFields(content);
    content = updateNullChecks(content);

    file.writeAsStringSync(content);

    print('Success! File transformed');
    print('\nMake sure to add this import if not already present:');
    print('  import \'package:autosafe_json/autosafe_json.dart\';');
  } catch (e) {
    print('Error: $e');
    exit(1);
  }
}

String addAutoSafeImport(String content) {
  const importLine = "import 'package:autosafe_json/autosafe_json.dart';";

  if (content.contains(importLine)) {
    return content;
  }

  final lines = content.split('\n');
  for (var i = 0; i < lines.length; i++) {
    if (lines[i].startsWith('import ')) {
      lines.insert(i + 1, importLine);
      return lines.join('\n');
    }
  }

  return '$importLine\n\n$content';
}

String transformFieldTypes(String content) {
  // Don't transform int, double, bool - keep them as-is
  // Only transform dynamic to String?
  content = content.replaceAllMapped(
    RegExp(r'(final\s+)?dynamic(\s+\w+;)'),
    (m) => '${m.group(1) ?? ''}String?${m.group(2)}',
  );

  return content;
}

String removeNestedAutoSafeCalls(String content) {
  final lines = content.split('\n');
  final result = <String>[];
  bool skipNext = false;

  for (var i = 0; i < lines.length; i++) {
    if (skipNext) {
      skipNext = false;
      continue;
    }

    // Skip lines that are just "json = json.autoSafe.raw;" (we'll add back to base class only)
    if (lines[i].trim() == 'json = json.autoSafe.raw;') {
      // Don't skip the line, just mark to skip if it's in a nested class
      // We'll handle this in addAutoSafeCall
      continue;
    }

    result.add(lines[i]);
  }

  return result.join('\n');
}

String addAutoSafeCall(String content) {
  final lines = content.split('\n');
  final result = <String>[];

  // Strategy 1: Find class that ends with "Response" (highest priority)
  // Strategy 2: Find first class that extends an entity
  // Strategy 3: Find the first class in the file (base response)
  String? baseClassName;

  // First priority: Find class ending with "Response"
  for (var i = 0; i < lines.length; i++) {
    if (lines[i].contains('class ') && !lines[i].contains('//')) {
      final match = RegExp(r'class\s+(\w+Response)\b').firstMatch(lines[i]);
      if (match != null) {
        baseClassName = match.group(1);
        break;
      }
    }
  }

  // Second priority: If no Response class, find class that extends an entity
  if (baseClassName == null) {
    for (var i = 0; i < lines.length; i++) {
      if (lines[i].contains('class ') && lines[i].contains(' extends ')) {
        final match = RegExp(r'class\s+(\w+)\s+extends').firstMatch(lines[i]);
        if (match != null) {
          baseClassName = match.group(1);
          break;
        }
      }
    }
  }

  // Third priority: If no Response or extends, find the first class declaration
  if (baseClassName == null) {
    for (var i = 0; i < lines.length; i++) {
      if (lines[i].contains('class ') && !lines[i].contains('//')) {
        final match = RegExp(r'class\s+(\w+)').firstMatch(lines[i]);
        if (match != null) {
          baseClassName = match.group(1);
          break;
        }
      }
    }
  }

  bool addedToBase = false;

  bool inArrowFunction = false;
  int arrowFunctionDepth = 0;
  bool inBaseFromJson = false;

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];

    // If we're in an arrow function, track parentheses depth
    if (inArrowFunction) {
      arrowFunctionDepth += '('.allMatches(line).length;
      arrowFunctionDepth -= ')'.allMatches(line).length;

      // When we find the closing semicolon and depth is 0, close the function
      if (line.trim().endsWith(');') && arrowFunctionDepth == 0) {
        result.add(line.replaceFirst(RegExp(r'\);$'), ');\n  }'));
        inArrowFunction = false;
        continue;
      }
    }

    // If we're in base fromJson and found the closing );
    if (inBaseFromJson && line.trim() == ');') {
      result.add(line);
      // Check if next line already has closing brace
      bool hasClosingBrace = false;
      if (i + 1 < lines.length && lines[i + 1].trim() == '}') {
        hasClosingBrace = true;
      }
      // Only add closing brace if not already present
      if (!hasClosingBrace) {
        result.add('  }');
      }
      inBaseFromJson = false;
      continue;
    }

    if (line.contains('factory') &&
        line.contains('.fromJson') &&
        line.contains('Map<String, dynamic>')) {
      // Extract the class name from factory method
      final match = RegExp(r'factory\s+(\w+)\.fromJson').firstMatch(line);
      final currentClass = match?.group(1);

      // Only add autoSafe to the base class
      if (!addedToBase && currentClass == baseClassName) {
        // Check if it's an arrow function (=>)
        if (line.contains('=>')) {
          // Convert arrow function to block function
          final factoryLine = line.replaceFirst(RegExp(r'=>\s*'),
              '{\n    json = json.autoSafe.raw;\n    return ');
          result.add(factoryLine);
          addedToBase = true;
          inArrowFunction = true;
          arrowFunctionDepth =
              '('.allMatches(line).length - ')'.allMatches(line).length;
          continue;
        } else {
          // It's a block function
          result.add(line);
          // Add autoSafe on next line if not already there
          if (i + 1 < lines.length &&
              !lines[i + 1].contains('json = json.autoSafe.raw')) {
            result.add('    json = json.autoSafe.raw;');
          }
          // Mark that we're in base fromJson (always, regardless of whether autoSafe was added)
          addedToBase = true;
          inBaseFromJson = true;
          continue;
        }
      }
    }

    result.add(line);
  }

  return result.join('\n');
}

String wrapObjectsAndLists(String content) {
  // Pattern 1: Wrap custom objects with SafeJson.asMap()
  // Match: ClassName.fromJson(json["field"])
  // Replace with: ClassName.fromJson(SafeJson.asMap(json["field"]))
  content = content.replaceAllMapped(
    RegExp(r'(\w+)\.fromJson\(json\["(\w+)"\]\)'),
    (m) {
      final className = m.group(1);
      final fieldName = m.group(2);

      // Don't wrap if it's already wrapped
      if (content.contains('SafeJson.asMap(json["$fieldName"])')) {
        return m.group(0)!;
      }

      return '$className.fromJson(SafeJson.asMap(json["$fieldName"]))';
    },
  );

  // Pattern 2: Wrap Lists of custom objects with SafeJson.asList()
  // Match: List<ClassName>.from(json["field"]!.map((x) => ClassName.fromJson(x)))
  // Replace with: List<ClassName>.from(SafeJson.asList(json["field"]).map((x) => ClassName.fromJson(x)))
  content = content.replaceAllMapped(
    RegExp(
        r'List<(\w+)>\.from\(json\["(\w+)"\]!\.map\(\(x\) => (\w+)\.fromJson\(x\)\)\)'),
    (m) {
      final listType = m.group(1);
      final fieldName = m.group(2);
      final className = m.group(3);

      // Don't wrap if it's already wrapped
      if (content.contains('SafeJson.asList(json["$fieldName"])')) {
        return m.group(0)!;
      }

      return 'List<$listType>.from(SafeJson.asList(json["$fieldName"]).map((x) => $className.fromJson(x)))';
    },
  );

  // Pattern 3: Wrap primitive Lists with SafeJson.asList() - but keep conversion logic
  // For List<dynamic> - simple case
  content = content.replaceAllMapped(
    RegExp(r'List<dynamic>\.from\(json\["(\w+)"\]!\.map\(\(x\) => x\)\)'),
    (m) {
      final fieldName = m.group(1);

      // Don't wrap if it's already wrapped
      if (content.contains('SafeJson.asList(json["$fieldName"])')) {
        return m.group(0)!;
      }

      return 'List<dynamic>.from(SafeJson.asList(json["$fieldName"]).map((x) => x))';
    },
  );

  // For List<bool?> - keep the conversion logic
  content = content.replaceAllMapped(
    RegExp(r'List<bool\?>\.from\(json\["(\w+)"\]!\.map\(\(x\) => (.+?)\)\)'),
    (m) {
      final fieldName = m.group(1);
      final conversion = m.group(2);

      // Don't wrap if it's already wrapped
      if (content.contains('SafeJson.asList(json["$fieldName"])')) {
        return m.group(0)!;
      }

      return 'List<bool?>.from(SafeJson.asList(json["$fieldName"]).map((x) => $conversion))';
    },
  );

  // For List<double?> - keep the conversion logic
  content = content.replaceAllMapped(
    RegExp(r'List<double\?>\.from\(json\["(\w+)"\]!\.map\(\(x\) => (.+?)\)\)'),
    (m) {
      final fieldName = m.group(1);
      final conversion = m.group(2);

      // Don't wrap if it's already wrapped
      if (content.contains('SafeJson.asList(json["$fieldName"])')) {
        return m.group(0)!;
      }

      return 'List<double?>.from(SafeJson.asList(json["$fieldName"]).map((x) => $conversion))';
    },
  );

  // For List<int?> - keep the conversion logic
  content = content.replaceAllMapped(
    RegExp(r'List<int\?>\.from\(json\["(\w+)"\]!\.map\(\(x\) => (.+?)\)\)'),
    (m) {
      final fieldName = m.group(1);
      final conversion = m.group(2);

      // Don't wrap if it's already wrapped
      if (content.contains('SafeJson.asList(json["$fieldName"])')) {
        return m.group(0)!;
      }

      return 'List<int?>.from(SafeJson.asList(json["$fieldName"]).map((x) => $conversion))';
    },
  );

  return content;
}

String wrapPrimitiveFields(String content) {
  final lines = content.split('\n');
  final result = <String>[];
  
  // Track current class field types
  final currentClassFields = <String, String>{};
  var inClass = false;
  
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    
    // Detect class start
    if (line.contains('class ') && line.contains('{')) {
      inClass = true;
      currentClassFields.clear();
      result.add(line);
      continue;
    }
    
    // Detect class end
    if (inClass && line.trim() == '}' && !line.contains('factory') && !line.contains('Map<String')) {
      // Check if this is the end of the class (not a method)
      var braceCount = 0;
      for (var j = i - 1; j >= 0; j--) {
        braceCount += '{'.allMatches(lines[j]).length;
        braceCount -= '}'.allMatches(lines[j]).length;
        if (lines[j].contains('class ')) break;
      }
      if (braceCount == 0) {
        inClass = false;
        currentClassFields.clear();
      }
    }
    
    // Collect field types in current class
    if (inClass) {
      final fieldMatch = RegExp(r'final\s+(int|double|bool|String)\s*\?\s+(\w+)\s*;').firstMatch(line);
      if (fieldMatch != null) {
        final type = fieldMatch.group(1)!;
        final fieldName = fieldMatch.group(2)!;
        currentClassFields[fieldName] = type;
      }
    }
    
    // Check if already wrapped or has null check
    if (line.contains('SafeJson.') || line.contains('== null')) {
      result.add(line);
      continue;
    }
    
    // Wrap json assignments
    if (line.contains('json["')) {
      var modifiedLine = line;
      final pattern = RegExp(r'(\w+):\s*json\["(\w+)"\]');
      final matches = pattern.allMatches(line);
      
      for (var match in matches) {
        final fieldName = match.group(1)!;
        final jsonKey = match.group(2)!;
        
        if (currentClassFields.containsKey(fieldName)) {
          final type = currentClassFields[fieldName]!;
          
          if (type == 'int') {
            modifiedLine = modifiedLine.replaceFirst(
              'json["$jsonKey"]',
              'SafeJson.asInt(json["$jsonKey"])',
            );
          } else if (type == 'bool') {
            modifiedLine = modifiedLine.replaceFirst(
              'json["$jsonKey"]',
              'SafeJson.asBool(json["$jsonKey"])',
            );
          } else if (type == 'double') {
            modifiedLine = modifiedLine.replaceFirst(
              'json["$jsonKey"]',
              'SafeJson.asDouble(json["$jsonKey"])',
            );
          } else if (type == 'String') {
            modifiedLine = modifiedLine.replaceFirst(
              'json["$jsonKey"]',
              'SafeJson.asString(json["$jsonKey"])',
            );
          }
        }
      }
      
      result.add(modifiedLine);
    } else {
      result.add(line);
    }
  }
  
  return result.join('\n');
}

String updateNullChecks(String content) {
  // First, remove type conversion methods like ?.toDouble(), ?.toString(), ?.toInt()
  content =
      content.replaceAll(RegExp(r'\?\.(toDouble|toString|toInt)\(\)'), '');

  // Update List<int?> mapping to parse int
  content = content.replaceAllMapped(
    RegExp(r'List<int\?>.from\(json\["(\w+)"\]!\.map\(\(x\) => x\)\)'),
    (m) =>
        'List<int?>.from(json["${m.group(1)}"]!.map((x) => x == null || x == "" ? null : int.tryParse(x.toString())))',
  );

  // Update List<double?> mapping to parse double
  content = content.replaceAllMapped(
    RegExp(r'List<double\?>.from\(json\["(\w+)"\]!\.map\(\(x\) => x\)\)'),
    (m) =>
        'List<double?>.from(json["${m.group(1)}"]!.map((x) => x == null || x == "" ? null : double.tryParse(x.toString())))',
  );

  // Update List<bool?> mapping to parse bool
  content = content.replaceAllMapped(
    RegExp(r'List<bool\?>.from\(json\["(\w+)"\]!\.map\(\(x\) => x\)\)'),
    (m) =>
        'List<bool?>.from(json["${m.group(1)}"]!.map((x) => x == null || x == "" ? null : x.toString().toLowerCase() == "true"))',
  );

  // Then update null checks to include empty string checks
  // This handles both single-line and multi-line patterns
  content = content.replaceAllMapped(
    RegExp(r'json\["(\w+)"\]\s*==\s*null\s*\?', multiLine: true),
    (m) {
      final field = m.group(1);
      return 'json["$field"] == null || json["$field"] == "" ?';
    },
  );

  // Also handle the pattern: json["field"] == null (without the ?)
  // This catches cases like: json["department"] == null
  content = content.replaceAllMapped(
    RegExp(r'json\["(\w+)"\]\s*==\s*null(?!\s*\|\|)', multiLine: true),
    (m) {
      final field = m.group(1);
      return 'json["$field"] == null || json["$field"] == ""';
    },
  );

  return content;
}
