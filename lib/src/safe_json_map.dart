// /// Extension for automatic safe JSON parsing
// /// Handles ALL type conversions automatically - NO MORE TYPE ERRORS!
// extension SafeMap on Map<String, dynamic> {
//   /// Convert to SafeJsonMap - access any field without type errors!
//   ///
//   /// Usage:
//   /// ```dart
//   /// factory User.fromJson(Map<String, dynamic> json) {
//   ///   json = json.autoSafe.raw;  // ← Just add this ONE line!
//   ///   // Now ALL fields are safe - null becomes '', int becomes String, etc.
//   ///   return User(
//   ///     id: json['id'] ?? 0,
//   ///     name: json['name'] ?? '',
//   ///     // ... ALL 1000 fields work automatically!
//   ///   );
//   /// }
//   /// ```
//   SafeJsonMap get autoSafe => SafeJsonMap._convert(this);
// }

// /// Safe JSON Map that converts all values to prevent type errors
// class SafeJsonMap {
//   final Map<String, dynamic> _map;

//   SafeJsonMap._(this._map);

//   /// Convert entire map recursively to safe types
//   factory SafeJsonMap._convert(Map<String, dynamic> json) {
//     final converted = <String, dynamic>{};

//     json.forEach((key, value) {
//       converted[key] = _convertValue(value);
//     });

//     return SafeJsonMap._(converted);
//   }

//   /// Convert any value to a safe type
//   /// Simple strategy:
//   /// - null → '' (empty string)
//   /// - int/double/bool → String (prevents type mismatch)
//   /// - String stays String
//   /// - Maps and Lists are processed recursively
//   static dynamic _convertValue(dynamic value) {
//     if (value == null) {
//       // Convert null to empty string
//       return '';
//     } else if (value is Map) {
//       // Recursively process nested maps
//       final converted = <String, dynamic>{};
//       value.forEach((k, v) {
//         converted[k.toString()] = _convertValue(v);
//       });
//       return converted;
//     } else if (value is List) {
//       // Recursively process lists
//       return value.map((item) => _convertValue(item)).toList();
//     } else if (value is int || value is double || value is bool) {
//       // Convert numbers and bools to String to prevent type mismatch
//       return value.toString();
//     } else {
//       // Keep everything else as-is (String, etc.)
//       return value;
//     }
//   }

//   /// Get the converted map
//   Map<String, dynamic> get raw => _map;
import 'package:autosafe_json/autosafe_json.dart';

/// Extension for automatic safe JSON parsing
/// Handles ALL type conversions automatically - NO MORE TYPE ERRORS!
extension SafeMap on Map<String, dynamic> {
  /// Convert to SafeJsonMap - access any field without type errors!
  ///
  /// Usage:
  /// ```dart
  /// factory User.fromJson(Map<String, dynamic> json) {
  ///   json = json.autoSafe.raw;  // ← Just add this ONE line!
  ///   return User(
  ///     id: json['id'] ?? 0,
  ///     name: json['name'] ?? '',
  ///   );
  /// }
  /// ```
  SafeJsonMap get autoSafe => SafeJsonMap._convert(this);
}

/// Safe JSON Map that converts all values to prevent type errors
class SafeJsonMap {
  final Map<String, dynamic> _map;

  SafeJsonMap._(this._map);

  /// Convert entire map recursively to safe types
  factory SafeJsonMap._convert(Map<String, dynamic> json) {
    final converted = <String, dynamic>{};

    json.forEach((key, value) {
      converted[key] = _convertValue(value, smartConvert: true);
    });

    return SafeJsonMap._(converted);
  }

  /// Convert any value to a safe type
  /// Simple strategy:
  /// - null → '' (empty string)
  /// - int/double/bool → String
  /// - String stays String
  /// - Maps and Lists processed recursively
  /// - Handles List↔Map mismatches gracefully
  ///
  /// [smartConvert] - When true, adds helper methods for Map/List conversion
  static dynamic _convertValue(dynamic value, {bool smartConvert = false}) {
    if (value == null) {
      // Convert null to empty string
      return '';
    }

    // === Handle Lists safely ===
    if (value is List) {
      return value
          .map((item) => _convertValue(item, smartConvert: smartConvert))
          .toList();
    }

    // === Handle Maps safely ===
    if (value is Map) {
      final converted = <String, dynamic>{};
      value.forEach((k, v) {
        converted[k.toString()] = _convertValue(v, smartConvert: smartConvert);
      });
      return converted;
    }

    // === Handle primitive values ===
    // if (value is int || value is double || value is bool) {
    //   try {
    //     return value.toString();
    //   } catch (e) {
    //     return '';
    //   }
    // }
    if (value is int) {
      return SafeJson.asInt(value);
    }
    if (value is double) {
      return SafeJson.asDouble(value);
    }
    if (value is bool) {
      return SafeJson.asBool(value);
    }
    if (value is String) {
      // Everything else (String, etc.)
      return SafeJson.asString(value);
    }
  }

  /// Safe getter for raw map
  Map<String, dynamic> get raw => _map;

  /// Access value by key
  dynamic operator [](String key) => _map[key];
}
