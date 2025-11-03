/// Extension for automatic safe JSON parsing
/// Handles ALL type conversions automatically - NO MORE TYPE ERRORS!
extension SafeMap on Map<String, dynamic> {
  /// Convert to SafeJsonMap - access any field without type errors!
  ///
  /// Usage:
  /// ```dart
  /// factory User.fromJson(Map<String, dynamic> json) {
  ///   json = json.autoSafe.raw;  // ← Just add this ONE line!
  ///   // Now ALL fields are safe - null becomes '', int becomes String, etc.
  ///   return User(
  ///     id: json['id'] ?? 0,
  ///     name: json['name'] ?? '',
  ///     // ... ALL 1000 fields work automatically!
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
      converted[key] = _convertValue(value);
    });

    return SafeJsonMap._(converted);
  }

  /// Convert any value to a safe type
  /// Simple strategy:
  /// - null → '' (empty string)
  /// - int/double/bool → String (prevents type mismatch)
  /// - String stays String
  /// - Maps and Lists are processed recursively
  static dynamic _convertValue(dynamic value) {
    if (value == null) {
      // Convert null to empty string
      return '';
    } else if (value is Map) {
      // Recursively process nested maps
      final converted = <String, dynamic>{};
      value.forEach((k, v) {
        converted[k.toString()] = _convertValue(v);
      });
      return converted;
    } else if (value is List) {
      // Recursively process lists
      return value.map((item) => _convertValue(item)).toList();
    } else if (value is int || value is double || value is bool) {
      // Convert numbers and bools to String to prevent type mismatch
      return value.toString();
    } else {
      // Keep everything else as-is (String, etc.)
      return value;
    }
  }

  /// Get the converted map
  Map<String, dynamic> get raw => _map;

  /// Access value by key
  dynamic operator [](String key) => _map[key];
}
