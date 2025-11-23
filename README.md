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
  "is_active": true,
  "address": {
    "street": "123 Main St",
    "city": "Anytown",
    "state": "CA",
    "zip": "12345"
  },
  "tags": [
    {
      "id": 1,
      "label": "admin"
    },
    {
      "id": 2,
      "label": "user"
    }
  ]
}
```

This generates a model like:
```dart
class UserResponse {
  final int? id;
  final dynamic name;
  final String? email;
  final int? age;
  final num? salary;
  final bool? isActive;
  final Address? address;
  final List<Tag>? tags;

  const UserResponse({
    this.id,
    this.name,
    this.email,
    this.age,
    this.salary,
    this.isActive,
    this.address,
    this.tags,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        age: json["age"],
        salary: json["salary"],
        isActive: json["is_active"],
        address: json["address"] == null
            ? null
            : Address.fromJson(json["address"]),
        tags: json["tags"] == null
            ? []
            : List<Tag>.from(
                json["tags"].map((x) => Tag.fromJson(x)),
              ),
      );
}

class Address {
  final String? city;
  final String? state;
  final String? country;

  const Address({
    this.city,
    this.state,
    this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        city: json["city"],
        state: json["state"],
        country: json["country"],
      );
}

class Tag {
  final int? id;
  final String? label;

  const Tag({
    this.id,
    this.label,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        id: json["id"],
        label: json["label"],
      );
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
  final int? id;
  final String? name;
  final int? age;
  final num? salary;
  final bool? isActive;
  final Address? address;
  final List<Tag>? tags;

  const UserResponse({
    this.id,
    this.name,
    this.age,
    this.salary,
    this.isActive,
    this.address,
    this.tags,
  });
  factory UserResponse.fromJson(Map<String, dynamic> json) {
    json = json.autoSafe.raw; // inserted automatically by autosafe_json CLI
    return UserResponse(
      id: SafeJson.asInt(json["id"]),
      name: SafeJson.asString(json["name"]),
      age: SafeJson.asInt(json["age"]),
      salary: SafeJson.asNum(json["salary"]),
      isActive: SafeJson.asBool(json["is_active"]),
      address: json["address"] == null || json["address"] == ""
          ? null
          : Address.fromJson(SafeJson.asMap(json["address"])),
      tags: json["tags"] == null || json["tags"] == ""
          ? []
          : List<Tag>.from(
              SafeJson.asList(json["tags"]).map((x) => Tag.fromJson(SafeJson.asMap(x)))),
    );
  }
}
class Address {
  final String? city;
  final String? state;
  final String? country;
  
  const Address({
    this.city,
    this.state,
    this.country,
  });
  
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: SafeJson.asString(json["city"]),
      state: SafeJson.asString(json["state"]),
      country: SafeJson.asString(json["country"]),
    );
  }
}
class Tag {
  final int? id;
  final String? label;
  
  const Tag({
    this.id,
    this.label,
  });
  
  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: SafeJson.asInt(json["id"]),
      label: SafeJson.asString(json["label"]),
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
