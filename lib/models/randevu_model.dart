import 'dart:convert';

List<Randevu> randevuFromJson(String str) =>
    List<Randevu>.from(json.decode(str).map((x) => Randevu.fromJson(x)));

String randevuToJson(List<Randevu> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Randevu {
  Randevu({
    required this.tarih,
    required this.saat,
    required this.poliklinik,
    required this.blok,
    required this.doktoradi,
    required this.hastane,
  });

  String tarih;
  String saat;
  String poliklinik;
  String blok;
  String doktoradi;
  String hastane;

  factory Randevu.fromJson(Map<String, dynamic> json) => Randevu(
        tarih: json["tarih"],
        saat: json["saat"],
        poliklinik: json["poliklinik"],
        blok: json["blok"],
        doktoradi: json["doktoradi"],
        hastane: json["hastane"],
      );

  Map<String, dynamic> toJson() => {
        "tarih": tarih,
        "saat": saat,
        "poliklinik": poliklinik,
        "blok": blok,
        "doktoradi": doktoradi,
        "hastane": hastane,
      };
}
