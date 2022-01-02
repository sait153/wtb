import 'package:cloud_firestore/cloud_firestore.dart';

class Konusma {
  final String? benimId;
  final String? kimId;
  final DateTime? tarih;
  String? konusulanUserName;
  String? konusulanUserProfilURL;

  Konusma(
      {this.benimId,
      this.kimId,
      this.tarih,
      this.konusulanUserName,
      this.konusulanUserProfilURL});

  Map<String, dynamic> toMap() {
    return {
      'benimId': benimId,
      'kimId': kimId,
      'tarih': tarih ?? FieldValue.serverTimestamp(),
      'konusulanUserName': konusulanUserName,
      'konusulanUserProfilURL': konusulanUserProfilURL
    };
  }

  Konusma.fromMap(Map<String, dynamic> map)
      : benimId = map['benimId'],
        kimId = map['kimId'],
        tarih = map['tarih'],
        konusulanUserName = map['konusulanUserName'],
        konusulanUserProfilURL = map['konusulanUserProfilURL'];
}
