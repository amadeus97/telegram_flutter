class Country {
  Country(this.name, this.code, this.flag);

  final String name;
  final String code;
  final String flag;

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      json['name'],
      json['code'],
      json['flag'],
    );
  }
}
