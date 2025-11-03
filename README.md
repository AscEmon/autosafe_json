# AutoSafe JSON 🛡️

**Eliminate JSON type mismatch errors forever!** 

AutoSafe JSON automatically converts all JSON values to safe types, preventing the dreaded `type 'X' is not a subtype of type 'Y'` errors in Dart/Flutter applications.

[![pub package](https://img.shields.io/pub/v/autosafe_json.svg)](https://pub.dev/packages/autosafe_json)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## The Problem 😫

```dart
// Backend sends: {"age": 25}  (int)
// But sometimes: {"age": "25"} (String)
// Or even: {"age": null}

factory User.fromJson(Map<String, dynamic> json) {
  return User(
    age: json['age'],  // 💥 CRASH! Type mismatch!
  );
}
```

## The Solution ✨

```dart
import 'package:autosafe_json/autosafe_json.dart';

factory User.fromJson(Map<String, dynamic> json) {
  json = json.autoSafe.raw;  // ← Add this ONE line!
  return User(
    age: json['age'].parseToInt(),  // ✅ Always works!
  );
}
```

## Features 🚀

- ✅ **Zero Configuration** - Just one line of code
- ✅ **Automatic Type Conversion** - int/double/bool → String
- ✅ **Null Safety** - null → empty string
- ✅ **Nested Objects** - Recursive processing
- ✅ **CLI Tool** - Transform existing models automatically
- ✅ **Helper Extensions** - Easy type conversions
- ✅ **Production Ready** - Battle-tested in real apps

## Installation 📦

Add to your `pubspec.yaml`:

```yaml
dependencies:
  autosafe_json: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Quick Start 🏃

### Option 1: Manual (New Models)

```dart
import 'package:autosafe_json/autosafe_json.dart';

class UserResponse {
  final String? id;
  final String? name;
  final String? email;
  
  UserResponse({this.id, this.name, this.email});
  
  factory UserResponse.fromJson(Map<String, dynamic> json) {
    json = json.autoSafe.raw;  // ← Magic line!
    return UserResponse(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}
```

### Option 2: CLI Tool (Existing Models)

Transform your existing model files automatically:

```bash
# Transform a single file
dart run autosafe lib/models/user_response.dart

# Transform multiple files
dart run autosafe lib/models/product_response.dart
dart run autosafe lib/data/models/order_response.dart
```

**What the CLI does:**
- ✅ Adds `json = json.autoSafe.raw;` to base Response class
- ✅ Converts `int?/double?/bool?/dynamic` fields to `String?`
- ✅ Updates null checks to handle empty strings
- ✅ Removes type conversion methods (`?.toDouble()`, etc.)
- ✅ Handles `List<int?>`, `List<double?>`, `List<bool?>` parsing
- ✅ Converts arrow functions to block functions
- ✅ Adds the import automatically

## How It Works 🔧

### The Conversion Strategy

```dart
// Before autoSafe
{
  "id": 123,           // int
  "name": null,        // null
  "price": 99.99,      // double
  "active": true       // bool
}

// After json.autoSafe.raw
{
  "id": "123",         // String
  "name": "",          // String (empty)
  "price": "99.99",    // String
  "active": "true"     // String
}
```

### Helper Extensions

Convert String back to original types when needed:

```dart
factory Product.fromJson(Map<String, dynamic> json) {
  json = json.autoSafe.raw;
  return Product(
    id: json['id'].parseToInt(),           // String → int
    price: json['price'].parseToDouble(),  // String → double
    active: json['active'].parseToBool(),  // String → bool
    name: json['name'].parseToString(),    // String → String (safe)
  );
}
```

## Complete Example 📝

See the [example](example/) directory for a complete working example with:
- `test.json` - Sample JSON data with various types
- `test_response.dart` - Transformed model class
- Usage demonstration

```dart
import 'dart:convert';
import 'package:autosafe_json/autosafe_json.dart';

void main() {
  final jsonString = '''
  {
    "id": 123,
    "name": null,
    "price": 99.99,
    "active": true,
    "tags": [1, 2, "three", null]
  }
  ''';
  
  final product = Product.fromJson(jsonDecode(jsonString));
  print('ID: ${product.id}');        // 123
  print('Name: ${product.name}');    // (empty)
  print('Price: ${product.price}');  // 99.99
  print('Active: ${product.active}'); // true
}
```

## CLI Usage 💻

```bash
# Show help
dart run autosafe

# Transform a file
dart run autosafe lib/models/user_response.dart

# Output:
# Processing: lib/models/user_response.dart
# Success! File transformed
# 
# Make sure to add this import if not already present:
#   import 'package:autosafe_json/autosafe_json.dart';
```

## API Reference 📚

### SafeMap Extension

```dart
extension SafeMap on Map<String, dynamic> {
  SafeJsonMap get autoSafe;
}
```

### SafeJsonMap Class

```dart
class SafeJsonMap {
  Map<String, dynamic> get raw;
  dynamic operator [](String key);
}
```

### NumGenericExtensions

```dart
extension NumGenericExtensions<T extends String> on T? {
  double parseToDouble();  // Returns 0.0 on error
  int parseToInt();        // Returns 0 on error
  bool parseToBool();      // Returns false on error
  String parseToString();  // Returns '' on null
}
```

## Best Practices 💡

1. **Always add `autoSafe` in the base Response class only**
   ```dart
   // ✅ Good
   factory UserResponse.fromJson(Map<String, dynamic> json) {
     json = json.autoSafe.raw;  // Only in base class
     return UserResponse(
       user: User.fromJson(json['user']),  // Nested classes don't need it
     );
   }
   ```

2. **Use the CLI for existing projects**
   - Saves time
   - Consistent transformations
   - Handles edge cases

3. **Keep field types as String?**
   ```dart
   // ✅ Good
   class User {
     final String? id;
     final String? name;
   }
   
   // ❌ Avoid
   class User {
     final int? id;  // Will cause type errors
   }
   ```

4. **Use helper extensions for type conversions**
   ```dart
   // ✅ Good
   age: json['age'].parseToInt()
   
   // ❌ Avoid
   age: int.parse(json['age'])  // Can throw
   ```

## Troubleshooting 🔍

### Issue: "Type 'String' is not a subtype of type 'int'"

**Solution:** Make sure you're using `.parseToInt()` for int fields:
```dart
age: json['age'].parseToInt()  // Not just json['age']
```

### Issue: "Type 'String' is not a subtype of type 'Map<String, dynamic>'"

**Solution:** Check for null/empty before parsing nested objects:
```dart
user: json['user'] == null || json['user'] == ''
    ? null
    : User.fromJson(json['user'])
```

The CLI automatically adds these checks!

## Contributing 🤝

Contributions are welcome! Please feel free to submit a Pull Request.

## License 📄

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support ❤️

If this package helped you, please give it a ⭐ on [GitHub](https://github.com/yourusername/autosafe_json)!

## Changelog 📋

See [CHANGELOG.md](CHANGELOG.md) for a list of changes.

---

Made with ❤️ by [Your Name]
