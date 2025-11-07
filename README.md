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
1. dart pub global activate autosafe_json //it will install the autosafe_json package globally .Dont need to run this every time

2. autosafe /path/to/your/model/user_response.dart //run this every time you want to transform your model


```

**What the CLI does:**
- ✅ Adds `json = json.autoSafe.raw;` to your base Response class
- ✅ Automatically wraps primitive fields with the correct helper (`SafeJson.asInt`, `SafeJson.asDouble`, `SafeJson.asBool`, `SafeJson.asString`)
- ✅ Wraps nested Maps/Lists with `SafeJson.asMap` / `SafeJson.asList`
- ✅ Updates null checks to handle `null` / empty string gracefully

**After transformation:**
```dart
import 'package:autosafe_json/autosafe_json.dart';

class UserResponse {
  final int? id;            // ← Primitive type preserved
  final String? name;
  final String? email;
  final int? age;            // ← Primitive type preserved
  final double? salary;      // ← Primitive type preserved
  final bool? isActive;      // ← Primitive type preserved


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
      id: SafeJson.asInt(json["id"]),
      name: SafeJson.asString(json["name"]),
      email: SafeJson.asString(json["email"]),
      age: SafeJson.asInt(json["age"]),
      salary: SafeJson.asDouble(json["salary"]),
      isActive: SafeJson.asBool(json["is_active"]),
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
// If a Map is passed to asList(), it safely returns []
```

### Step 5: Use Specific Types When Needed

Declare the field with the type you expect and let the CLI insert the proper helper call:

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
      id: SafeJson.asInt(json["id"]),
      name: SafeJson.asString(json["name"]),
      email: SafeJson.asString(json["email"]),
      age: SafeJson.asInt(json["age"]),
      salary: SafeJson.asDouble(json["salary"]),
      isActive: SafeJson.asBool(json["is_active"]),
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

AutoSafe JSON keeps your model types intact and uses helper methods to safely coerce JSON values at runtime. The helpers handle malformed data (e.g. strings that should be numbers, `"true"` vs `true`) and fall back to `null` when conversion fails.

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
