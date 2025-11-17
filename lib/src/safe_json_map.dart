import 'package:autosafe_json/autosafe_json.dart';

/// Extension for automatic safe JSON parsing
/// Handles ALL type conversions automatically - NO MORE TYPE ERRORS!
extension SafeMap on Map<String, dynamic> {
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
    if (value is num) {
      return SafeJson.asNum(value);
    }
  }

  /// Safe getter for raw map
  Map<String, dynamic> get raw => _map;

  /// Access value by key
  dynamic operator [](String key) => _map[key];
}
