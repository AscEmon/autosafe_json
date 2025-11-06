# AutoSafe JSON 🛡️

**Never worry about JSON type mismatches again!**

AutoSafe JSON automatically converts all JSON values to safe types, preventing the dreaded `type 'X' is not a subtype of type 'Y'` errors in Dart/Flutter applications.


## Quick Start Guide 🚀

### Step 1: Generate Your Model with QuickType

When you receive JSON from an API, use [QuickType](https://app.quicktype.io/) or any other model generator to create your Dart model class.

**QuickType Settings:**
- ✅ Enable **Null Safety**
- ✅ Enable **Make all properties optional**
- ✅ Enable **Make properties final**

Example JSON:
```json
{
  "id": 12345,
  "name": null,
  "email": "test@example.com",
  "age": 25,
  "salary": 50000.50,
  "is_active": true
}
```

This generates a model like:
```dart
// To parse this JSON data, do
//
//     final userResponse = userResponseFromJson(jsonString);

import 'dart:convert';

UserResponse userResponseFromJson(String str) => UserResponse.fromJson(json.decode(str));

String userResponseToJson(UserResponse data) => json.encode(data.toJson());

class UserResponse {
    final int? id;
    final dynamic name;
    final String? email;
    final int? age;
    final double? salary;
    final bool? isActive;

 const UserResponse({
        this.id,
        this.name,
        this.email,
        this.age,
        this.salary,
        this.isActive,
    });

    factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        age: json["age"],
        salary: json["salary"]?.toDouble(),
        isActive: json["is_active"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "age": age,
        "salary": salary,
        "is_active": isActive,
    };
}
```

### Step 2: Add AutoSafe JSON Package

```yaml
dependencies:
  autosafe_json: ^1.0.0
```

### Step 3: Transform Your Model with CLI

Run the AutoSafe CLI to automatically transform your model:

```bash
# From the autosafe_json package directory
cd /path/to/autosafe_json
dart run bin/autosafe.dart /path/to/your/model/user_response.dart

# Or use the full path
dart /path/to/autosafe_json/bin/autosafe.dart /path/to/your/model/user_response.dart
```

**What the CLI does:**
- ✅ Adds `json = json.autoSafe.raw;` to your base Response class
- ✅ Converts all field types to `String?` (int, double, bool, dynamic → String)
- ✅ Updates null checks to handle empty strings
- ✅ Handles List parsing for `List<int?>`, `List<double?>`, `List<bool?>`

**After transformation:**
```dart
import 'package:autosafe_json/autosafe_json.dart';

class UserResponse {
 final String? id;          // ← Changed from int?
 final String? name;        // ← Changed from dynamic
 final String? email;
 final String? age;         // ← Changed from int?
 final String? salary;      // ← Changed from double?
 final String? isActive;    // ← Changed from bool?


 const UserResponse({
        this.id,
        this.name,
        this.email,
        this.age,
        this.salary,
        this.isActive,
    });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    json = json.autoSafe.raw;  // ← Added automatically!
    return UserResponse(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      age: json["age"],
      salary: json["salary"],
      isActive: json["is_active"],
    );
  }
}
```

### Step 4: Handle Map/List Mismatches (Optional)

If backend accidentally sends wrong structure (List instead of Map or vice versa), use `SafeJson.asMap()` or `SafeJson.asList()`:

```dart
// Backend sends: "status": ["active", "inactive"]  (List)
// But you expect: Status object (Map)

factory Business.fromJson(Map<String, dynamic> json) {
  json = json.autoSafe.raw;
  return Business(
    status: json["status"] == null || json["status"] == "" 
        ? null 
        : Status.fromJson(SafeJson.asMap(json["status"])),  // ← Converts List to Map
  );
}
```

**What `SafeJson.asMap()` does:**
```dart
["active", "inactive"] → {"0": "active", "1": "inactive"}
```

**What `SafeJson.asList()` does:**
```dart
{"0": "value1", "1": "value2"} → ["value1", "value2"]
```

### Step 5: Use Specific Types When Needed

If you need a field to be a specific type (int, double, bool), just declare it with that type and use the helper extensions:

```dart
class UserResponse {
  final int? id;             // ← Keep as int? if you need it as int
  final String? name;
  final String? email;
  final int? age;            // ← Keep as int? if you need it as int
  final double? salary;      // ← Keep as double? if you need it as double
  final bool? isActive;      // ← Keep as bool? if you need it as bool


 const UserResponse({
        this.id,
        this.name,
        this.email,
        this.age,
        this.salary,
        this.isActive,
    });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    json = json.autoSafe.raw;
    return UserResponse(
      id: json["id"].toString().parseToInt(),           // ← Convert back to int
      name: json["name"],
      email: json["email"],
      age: json["age"].toString().parseToInt(),         // ← Convert back to int
      salary: json["salary"].toString().parseToDouble(), // ← Convert back to double
      isActive: json["is_active"].toString().parseToBool(), // ← Convert back to bool
    );
  }
}
```

**That's it!** 🎉 Your JSON parsing will **NEVER** throw type mismatch errors again!

---

## Features ⭐

- 🛡️ **Zero Crashes** - Eliminates all JSON type mismatch errors
- 🚀 **One-Line Integration** - Just add `json = json.autoSafe.raw;`
- 🤖 **CLI Tool** - Automatically transforms existing models
- 📦 **Lightweight** - No external dependencies
- 🔄 **Recursive Processing** - Handles nested objects and arrays
- 💪 **Production Ready** - Battle-tested in real applications
- 🎯 **Type Safe** - Preserves Dart's type system with helper extensions

---

### How It Works 🔧

AutoSafe JSON uses a simple strategy to eliminate type errors:

```dart
/// Convert any value to a safe type:
/// - null → '' (empty string)
/// - int/double/bool → String (prevents type mismatch)
/// - String stays String
/// - Maps and Lists are processed recursively
```

**Example transformations:**
```dart
// Input JSON values → AutoSafe output
null           → ""
123            → "123"
45.67          → "45.67"
true           → "true"
"hello"        → "hello"
{"key": null}  → {"key": null} //Map and list are not changed
[1, null, 3]   → [1, null, 3] //Map and list are not changed
```

---

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


## Troubleshooting 🔍

### Issue: "Type 'String' is not a subtype of type 'int'"

**Solution:** Make sure you're using `.parseToInt()` for int fields:
```dart
age: json['age'].toString().parseToInt()  // Not just json['age']
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

If this package helped you, please give it a ⭐ on [GitHub](https://github.com/AscEmon/autosafe_json)!

## Changelog 📋

See [CHANGELOG.md](CHANGELOG.md) for a list of changes.

---

Made with ❤️ by [Abu Sayed Chowdhury](https://github.com/AscEmon)
