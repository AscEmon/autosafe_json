/// AutoSafe JSON — Automatic Safe JSON Parsing for Dart & Flutter
///
/// 🚀 **Eliminate JSON type mismatch errors forever!**
///
/// AutoSafe converts all JSON values into *safe, consistent types* —
/// so you never see `type 'int' is not a subtype of type 'String'` again.
///
///
/// ## 🌟 Quick Start
///
/// 1. Add one line in your model’s `fromJson`:
/// ```dart
/// factory User.fromJson(Map<String, dynamic> json) {
///   json = json.autoSafe.raw; // ← Just add this ONE line!
///   return User(
///     id: json['id'],
///     name: json['name'],
///   );
/// }
/// ```
///
/// 2. (Optional) Use the CLI to auto-transform your models:
/// ```bash
/// dart run autosafe lib/models/user_response.dart
/// ```
///
///
/// ## 🧠 What AutoSafe Does
///
/// | Original Value | Becomes |
/// |-----------------|----------|
/// | `null`          | `''` (empty string) |
/// | `int` / `double` / `bool` | Converted to `String` |
/// | `Map` / `List` | Recursively processed safely |
/// | Mismatched structures (List ↔ Map) | Automatically fixed at runtime |
///
/// ✅ Prevents runtime crashes and parsing exceptions  
/// ✅ Works with deeply nested models and lists  
/// ✅ Safe for any API response — even malformed ones!
///
///
/// ## 🧩 Helper Extensions
///
/// ### Convert Strings Back to Real Types
/// ```dart
/// final age = json['age'].parseToInt();       // "25" → 25
/// final price = json['price'].parseToDouble(); // "99.99" → 99.99
/// final isActive = json['is_active'].parseToBool(); // "true" → true
/// final name = json['name'].parseToString();   // null → ''
/// ```
///
///
/// ### Fix Backend Structure Mismatches Instantly
/// ```dart
/// // Backend accidentally sends a Map instead of a List:
/// // "users": { "0": {"id": 1}, "1": {"id": 2} }
///
/// final users = json['users'].asSafeList();
/// // → [ {"id": 1}, {"id": 2} ]
///
/// // Or backend sends a single value:
/// // "users": "oops"
/// final users = json['users'].asSafeList();
/// // → ["oops"]
///
/// // Expecting a Map but backend sends a List:
/// final settings = json['settings'].asSafeMap();
/// // → { "0": {...}, "1": {...} }
/// ```
///
///
/// ## 🔒 Key Benefits
/// - No crashes on malformed or inconsistent backend data  
/// - Backward compatible and zero-breaking changes  
/// - Works with any `Map<String, dynamic>` JSON model  
/// - Designed for large-scale apps and generated models  
///
///
/// ## 📦 Example CLI Usage
/// ```bash
/// dart run autosafe --response-path lib/api/user_api.dart --model-path lib/models/user_model.dart
/// ```
///
/// — Part of the [AutoSafe JSON](https://github.com/AscEmon/autosafe_json) package.

library autosafe_json;

export 'src/safe_json_map.dart';
export 'src/helper.dart';
