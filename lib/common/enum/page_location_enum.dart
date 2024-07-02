// this file is used for rendering Icons based on the user role and location onto the AppBar in heading.dart
enum PageLocation {
  homePage('Home'),
  budgetPage('Budget'),
  goals('Goals'),
  settingsPage('Settings');
  

  // profilePage,
  const PageLocation(this.name);

  // final String hexCode;
  final String name;

  @override
  String toString() => name;

  static PageLocation fromString(String name) {
    // get the role from the name
    for (var role in PageLocation.values) {
      if (role.name == name) {
        return role;
      }
    }
    // default to er
    return PageLocation.homePage;
  }
}
