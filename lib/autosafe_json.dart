/// AutoSafe JSON - Automatic Safe JSON Parsing for Dart/Flutter
///
/// Eliminates JSON type mismatch errors by converting all values to safe types.
///
/// ## Quick Start
///
/// 1. Add to your model's `fromJson`:
/// ```dart
/// factory User.fromJson(Map<String, dynamic> json) {
///   json = json.autoSafe.raw;  // ← Add this ONE line!
///   return User(
///     id: json['id'],
///     name: json['name'],
///     // ... all fields work automatically!
///   );
/// }
/// ```
///
/// 2. Use the CLI to transform existing models:
/// ```bash
/// dart run autosafe lib/models/user_response.dart
/// ```
///
/// ## What it does
/// - null → '' (empty string)
/// - int/double/bool → String
/// - Nested objects and arrays are processed recursively
/// - No more "type 'int' is not a subtype of type 'String'" errors!
///
/// ## Helper Extensions
/// Convert String back to original types when needed:
/// ```dart
/// final age = json['age'].parseToInt();
/// final price = json['price'].parseToDouble();
/// final isActive = json['is_active'].parseToBool();
/// ```
library autosafe_json;

export 'src/safe_json_map.dart';
export 'src/extensions.dart';
