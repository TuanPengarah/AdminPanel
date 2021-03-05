class ManufactorSuggestion {
  static final List<String> manufactor = [
    'OEM',
    'ORI',
    'AAA',
    'AA',
    'AP',
    'OLED',
    'OLED Burn In',
    'GX OLED',
    'ORI Change Glass',
    'ORI China',
    'ORI Used',
  ];

  static List<String> getSuggestions(String query) {
    List<String> matches = [];
    matches.addAll(manufactor);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}
