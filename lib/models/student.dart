class Student {
  String? kresAdi;
  String? kresCode;
  String ogrID;
  String adiSoyadi;
  String? dogumTarihi;
  String? cinsiyet;
  String? veliAdiSoyadi;
  String? veliTelefonNo;
  String? sinifi;
  String? token;
  String? fotoUrl;

  Student(
      {this.kresAdi,
      this.kresCode,
      required this.ogrID,
      required this.adiSoyadi,
      this.dogumTarihi,
      this.cinsiyet,
      this.veliAdiSoyadi,
      this.veliTelefonNo,
      this.sinifi,
      this.token,
      this.fotoUrl});

  Map<String, dynamic> toMap() {
    return {
      'kresAdi': kresAdi,
      'kresCode': kresCode,
      'ogrID': ogrID,
      'adiSoyadi': adiSoyadi,
      'dogumTarihi': dogumTarihi,
      'cinsiyet': cinsiyet,
      'veliAdiSoyadi': veliAdiSoyadi,
      'veliTelefonNo': veliTelefonNo,
      'sinifi': sinifi ?? 'A',
      'token': token,
      'fotoUrl': fotoUrl,
    };
  }

  Student.fromMap(Map<String, dynamic> map)
      : kresAdi = map['kresAdi'],
        kresCode = map['kresCode'],
        ogrID = map['ogrID'],
        adiSoyadi = map['adiSoyadi'],
        dogumTarihi = map['dogumTarihi'],
        cinsiyet = map['cinsiyet'],
        veliAdiSoyadi = map['veliAdiSoyadi'],
        veliTelefonNo = map['veliTelefonNo'],
        sinifi = map['sinifi'],
        token = map['token'],
        fotoUrl = map['fotoUrl'];

  @override
  String toString() {
    return 'Student{kresAdi: $kresAdi, kresCode: $kresCode, ogrID: $ogrID, adiSoyadi: $adiSoyadi, dogumTarihi: $dogumTarihi, cinsiyet: $cinsiyet, veliAdiSoyadi: $veliAdiSoyadi, veliTelefonNo: $veliTelefonNo, sinifi: $sinifi, token: $token, fotoUrl: $fotoUrl}';
  }
}
