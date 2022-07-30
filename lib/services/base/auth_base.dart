import 'package:firebase_auth/firebase_auth.dart';
import 'package:krestakipapp/models/photo.dart';
import 'package:krestakipapp/models/student.dart';
import 'package:krestakipapp/models/user.dart';

abstract class AuthBase {
  Future<MyUser?> currentUser();
  Future<MyUser?> signingWithPhone(UserCredential userCredential,
      String kresCode, String kresAdi, String ogrID, String phone);
  Future<bool> deleteUser();
  Future<bool> signOut();
  Future<List<Map<String, dynamic>>> getKresList();

  Future<String> queryKresList(String kresAdi);
  Future<Student?> queryOgrID(
      String kresCode, String kresAdi, String ogrID, String phoneNumber);
  Future<List<String>> getCriteria();
  Future<List<Map<String, dynamic>>> getRatings(
      String kresCode, String kresAdi, String ogrID);
  Future<List<Photo>> getPhotoToMainGallery(String kresCode, String kresAdi);
  Future<List<Photo>> getPhotoToSpecialGallery(
      String kresCode, String kresAdi, String ogrID);

  Future<List<Map<String, dynamic>>> getAnnouncements(
      String kresCode, String kresAdi);
}
