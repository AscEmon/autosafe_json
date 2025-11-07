/// Extension for safe access to dynamic JSON values
/// Extension for safe Map conversions that works with any type
/// Generic extension for type checking
class SafeJson {
  /// Safely convert to Map
  static Map<String, dynamic> asMap(dynamic thisValue) {
    final value = thisValue;
    if (value == null || value == '') return {};

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    if (value is List) {
      final map = <String, dynamic>{};
      for (var i = 0; i < value.length; i++) {
        map[i.toString()] = value[i];
      }
      return map;
    }

    return {'0': value};
  }

  /// Safely convert to List and restore primitive types
  /// This reverses the autoSafe conversion for List items:
  /// - "true"/"false" → bool
  /// - "123" → int (if it's a valid int)
  /// - "123.45" → double (if it's a valid double)
  /// - "" → null
  static List<dynamic> asList(dynamic thisValue) {
    try {
      final value = thisValue;

      if (value == null || value == '') return [];

      List<dynamic> list;
      if (value is List) {
        list = value;
      } else if (value is Map) {
        // If it's a Map, return empty list (Maps should use asMap, not asList)
        return [];
      } else {
        list = [value];
      }

      // Restore primitive types from Strings
      return list.map((item) {
        if (item == null || item == '') return null;

        // If it's already a primitive type, keep it
        if (item is! String) return item;

        final str = item;

        // Try to restore bool
        if (str.toLowerCase() == 'true') return true;
        if (str.toLowerCase() == 'false') return false;

        // Try to restore int
        final intValue = int.tryParse(str);
        if (intValue != null) return intValue;

        // Try to restore double
        final doubleValue = double.tryParse(str);
        if (doubleValue != null) return doubleValue;

        // Keep as String
        return str;
      }).toList();
    } catch (_) {
      return [];
    }
  }

  /// Parse String to double
  ///
  /// Returns 0.0 if parsing fails or value is null/empty
  ///
  /// Example:
  /// ```dart
  /// final price = json['price'].parseToDouble(); // "99.99" → 99.99
  /// ```
  static double asDouble(dynamic thisValue) {
    final value = thisValue?.toString();
    if (value == null || value == '') {
      return 0.0;
    }
    try {
      return double.parse(value);
    } catch (e) {
      return 0.0;
    }
  }

  /// Parse to String (safe toString)
  ///
  /// Returns empty string if value is null
  ///
  /// Example:
  /// ```dart
  /// final name = json['name'].parseToString(); // null → ''
  /// ```
  static String asString(dynamic thisValue) {
    final value = thisValue?.toString();
    if (value == null || value == '') {
      return '';
    }
    try {
      return value;
    } catch (e) {
      return '';
    }
  }

  /// Parse String to int
  ///
  /// Returns 0 if parsing fails or value is null/empty
  ///
  /// Example:
  /// ```dart
  /// final age = json['age'].parseToInt(); // "25" → 25
  /// ```
  static int asInt(dynamic thisValue) {
    final value = thisValue?.toString();
    if (value == null || value == '') {
      return 0;
    }
    try {
      return int.parse(value);
    } catch (e) {
      return 0;
    }
  }

  /// Parse String to bool
  ///
  /// Returns false if parsing fails or value is null/empty
  ///
  /// Example:
  /// ```dart
  /// final isActive = json['is_active'].parseToBool(); // "true" → true
  /// ```
  static bool asBool(dynamic thisValue) {
    final value = thisValue?.toString();
    if (value == null || value == '') {
      return false;
    }
    try {
      return value.toLowerCase() == 'true';
    } catch (e) {
      return false;
    }
  }
}
