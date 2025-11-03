/// Helper extensions to convert String back to original types
///
/// After using autoSafe, all values become Strings.
/// Use these extensions to convert them back when needed.
extension NumGenericExtensions<T extends String> on T? {
  /// Parse String to double
  ///
  /// Returns 0.0 if parsing fails or value is null/empty
  ///
  /// Example:
  /// ```dart
  /// final price = json['price'].parseToDouble(); // "99.99" → 99.99
  /// ```
  double parseToDouble() {
    if (this?.isEmpty ?? true) {
      return 0.0;
    }
    try {
      return double.parse(this!);
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
  String parseToString() {
    try {
      if (this == null) {
        return '';
      }
      return toString();
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
  int parseToInt() {
    try {
      if (this == null) {
        return 0;
      }
      return int.parse(this!);
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
  bool parseToBool() {
    if (this?.isEmpty ?? true) {
      return false;
    }
    try {
      return this!.toLowerCase() == 'true';
    } catch (e) {
      return false;
    }
  }
}
