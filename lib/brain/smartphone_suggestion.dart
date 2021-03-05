class SmartphoneSuggestion {
  static final List<String> phone = [
    'iPhone 4',
    'iPhone 4s',
    'iPhone 5',
    'iPhone 5s',
    'iPhone 5se',
    'iPhone 6',
    'iPhone 6 Plus',
    'iPhone 6s',
    'iPhone 6s Plus',
    'iPhone 7',
    'iPhone 7 Plus',
    'iPhone 8',
    'iPhone 8 Plus',
    'iPhone X',
    'iPhone Xs',
    'iPhone Xs Max',
    'iPhone Xr',
    'iPhone 11',
    'iPhone 11 Pro',
    'iPhone 12 mini',
    'iPhone 12 Pro',
    'iPhone 12',
    'Huawei',
    'Vivo',
    'Xiaomi',
    'Redmi',
    'Poco',
    'Realme',
    'Samsung',
    'Lenovo',
    'Honor',
  ];

  static List<String> getSuggestions(String query) {
    List<String> matches = [];
    matches.addAll(phone);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}
