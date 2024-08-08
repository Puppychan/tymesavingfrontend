enum ThemeModeType {
  custom("Custom"),
  system("System Default"),
  time("Time-based");

  const ThemeModeType(this.value);

  // final String hexCode;
  final String value;

  @override
  String toString() => value;

  static ThemeModeType fromString(String value) {
    // get the role from the value
    for (var mode in ThemeModeType.values) {
      if (mode.value == value) {
        return mode;
      }
    }
    // default to customer
    return ThemeModeType.system;
  }
}