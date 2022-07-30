import 'package:krestakipapp/models/photo.dart';
import 'package:krestakipapp/models/student.dart';
import 'package:krestakipapp/models/teacher.dart';
import 'package:krestakipapp/models/user.dart';

abstract class DBBase {
  Future<bool> saveUser(MyUser users);
  Future<MyUser> readUser(String userId);
  Future<bool> deleteUser(String userID);

  Future<List<Map<String, dynamic>>> getKresList();
  Future<String> queryKresList(String kresCode);
  Future<Student?> queryOgrID(
      String kresCode, String kresAdi, String ogrID, String phone);

  Future<Student> getStudent(String ogrNo);

  Stream<List<Teacher>> getTeachers();

  Future<List<String>> getCriteria();

  Future<List<Map<String, dynamic>>> getRatings(
      String kresCode, String kresAdi, String ogrID);

  Future<List<Photo>> getPhotoToMainGallery(String kresCode, String kresAdi);
  Future<List<Photo>> getPhotoToSpecialGallery(
      String kresCode, String kresAdi, String ogrID);

  Future<List<Map<String, dynamic>>> getAnnouncements(
      String kresCode, String kresAdi);
}
