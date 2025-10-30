class Scheme {
  final String schemeName;
  final String schemeCode;

  Scheme({required this.schemeName, required this.schemeCode});

  factory Scheme.fromJson(Map<String, dynamic> j) => Scheme(
    schemeName: j['schemeName'] ?? '',
    schemeCode: j['schemeCode']?.toString() ?? '',
  );

  Map<String, dynamic> toJson() => {
    'schemeName': schemeName,
    'schemeCode': schemeCode,
  };
}
