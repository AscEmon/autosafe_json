/// Utility helpers that coerce dynamic JSON values into safe Dart primitives.
///
/// These helpers are used by the CLI-generated code as well as at runtime to
/// accept inconsistent backend payloads while keeping strongly typed models.
class SafeJson {
  /// Convert any dynamic input into a `Map<String, dynamic>`.
  ///
  /// - `null`/`` -> `{}`
  /// - `Map`     -> cloned map (keeps original key/value types)
  /// - `List`    -> index-based map (`{"0": value}`)
  /// - primitive -> single-entry map (`{"0": value}`)
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

  /// Convert any dynamic input into a `List` while restoring primitives.
  ///
  /// - `null`/`` -> `[]`
  /// - `List`    -> returned as-is with primitive restoration
  /// - `Map`     -> returns `[]` (maps should use [asMap])
  /// - primitive -> wrapped in a single-element list
  ///
  /// Each String element is parsed back to its original primitive where
  /// possible (`"true"` → `true`, numeric strings → `int`/`double`). Empty
  /// strings become `null`.
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

  /// Coerce the supplied value to `double`.
  ///
  /// - `null`/``  -> `0.0`
  /// - parsable   -> parsed `double`
  /// - otherwise  -> `0.0`
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

  /// Coerce the supplied value to `String` using a safe `toString`.
  ///
  /// - `null`/`` -> `""`
  /// - otherwise -> `value.toString()`
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

  /// Coerce the supplied value to `int`.
  ///
  /// - `null`/``  -> `0`
  /// - parsable   -> parsed `int`
  /// - otherwise  -> `0`
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

  /// Coerce the supplied value to `bool`.
  ///
  /// - `null`/``        -> `false`
  /// - case-insensitive "true" -> `true`
  /// - any other string/primitive -> `false`
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
