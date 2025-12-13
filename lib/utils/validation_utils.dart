/// Utility functions for input validation
class ValidationUtils {
  /// Validates that a string is not empty
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// Validates that a duration is positive
  static bool isPositiveDuration(Duration? duration) {
    return duration != null && duration.inMilliseconds > 0;
  }

  /// Validates that a double is positive
  static bool isPositiveDouble(double? value) {
    return value != null && value > 0;
  }

  /// Validates that a double is within a range
  static bool isInRange(double? value, double min, double max) {
    if (value == null) return false;
    return value >= min && value <= max;
  }

  /// Validates that an integer is positive
  static bool isPositiveInt(int? value) {
    return value != null && value > 0;
  }
}

