// To parse this JSON data, do
//
//     final soruCevap = soruCevapFromJson(jsonString);

import 'dart:convert';

List<SoruCevap> soruCevapFromJson(String str) =>
    List<SoruCevap>.from(json.decode(str).map((x) => SoruCevap.fromJson(x)));

String soruCevapToJson(List<SoruCevap> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SoruCevap {
  SoruCevap({
    required this.soru,
    required this.cevap1,
    required this.cevap2,
    required this.cevap3,
    required this.cevap4,
    required this.dogrucevap,
  });

  String soru;
  String cevap1;
  String cevap2;
  String cevap3;
  String cevap4;
  String dogrucevap;

  factory SoruCevap.fromJson(Map<String, dynamic> json) => SoruCevap(
        soru: json["soru"],
        cevap1: json["cevap1"],
        cevap2: json["cevap2"],
        cevap3: json["cevap3"],
        cevap4: json["cevap4"],
        dogrucevap: json["dogrucevap"],
      );

  Map<String, dynamic> toJson() => {
        "soru": soru,
        "cevap1": cevap1,
        "cevap2": cevap2,
        "cevap3": cevap3,
        "cevap4": cevap4,
        "dogrucevap": dogrucevap,
      };
}
