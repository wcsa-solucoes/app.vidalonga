enum LanguageEnum {
  english("en_", 0x00),
  portuguese("pt_", 0x01);

  final String shortLocale;
  final int byte;

  const LanguageEnum(this.shortLocale, this.byte);

  factory LanguageEnum.fromByte(int byte) {
    return LanguageEnum.values.firstWhere((item) => item.byte == byte,
        orElse: () => LanguageEnum.english);
  }

  String get title {
    switch (this) {
      case LanguageEnum.english:
        return "English";
      case LanguageEnum.portuguese:
        return "Portuguese";
    }
  }
}
