class Utils {
  static String validate(String value) {
    late String _msg = "";

    if (value.isEmpty) {
      _msg = "Telefon numarası girilmelidir.";
    } else if (isNumeric(value) == false) {
      _msg = "Sadece sayılar kullanılmalıdır.";
    } else if (value.length < 10) {
      _msg = "Lütfen numaranızı doğru uzunlukta giriniz.";
    } else if (value[0] != "5" ||
        value[1] == "1" ||
        value[1] == "6" ||
        value[1] == "7" ||
        value[1] == "8" ||
        value[1] == "9") {
      _msg = "Lütfen telefon numaranızı doğru giriniz.";
    } else {
      _msg = "";
    }

    return _msg;
  }
}

bool isNumeric(String s) {
  // ignore: unnecessary_null_comparison
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}
