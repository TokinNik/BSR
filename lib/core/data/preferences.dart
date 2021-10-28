class Preferences {
  final String locale;
  final bool isSoundEnable;
  final bool isMusicEnable;

  Preferences({
    this.locale = 'en',
    this.isSoundEnable = false,
    this.isMusicEnable = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'locale': this.locale,
      'isSoundEnable': this.isSoundEnable,
      'isMusicEnable': this.isMusicEnable,
    };
  }

  factory Preferences.fromMap(Map<String, dynamic> map) {
    return Preferences(
      locale: map['locale'] as String,
      isSoundEnable: map['isSoundEnable'] as bool,
      isMusicEnable: map['isMusicEnable'] as bool,
    );
  }

  Preferences copyWith({
    String locale,
    bool isSoundEnable,
    bool isMusicEnable,
  }) {
    return Preferences(
      locale: locale ?? this.locale,
      isSoundEnable: isSoundEnable ?? this.isSoundEnable,
      isMusicEnable: isMusicEnable ?? this.isMusicEnable,
    );
  }

  @override
  String toString() {
    return 'Preferences{locale: $locale, isSoundEnable: $isSoundEnable, isMusicEnable: $isMusicEnable}';
  }
}
