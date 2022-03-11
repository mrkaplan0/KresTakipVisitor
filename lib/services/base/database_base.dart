import 'package:krestakipapp/models/photo.dart';
import 'package:krestakipapp/models/student.dart';
import 'package:krestakipapp/models/teacher.dart';
import 'package:krestakipapp/models/user.dart';

abstract class DBBase {
  Future<bool> saveUser(MyUser users);
  Future<MyUser> readUser(String userId);
  Future<bool> ogrNoControl(String ogrNo);
  Future<bool> saveStudent(Student student);
  Future<bool> deleteStudent(Student student);
  Stream<List<Student>> getStudents();
  Future<List<Student>> getStudentsFuture();
  Future<Student> getStudent(String ogrNo);

  Future<bool> saveTeacher(Teacher teacher);
  Future<bool> deleteTeacher(Teacher teacher);
  Stream<List<Teacher>> getTeachers();
  Future<bool> addCriteria(String criteria);
  Future<List<String>> getCriteria();
  Future<bool> deleteCriteria(String criteria);
  Future<bool> uploadPhotoToGallery(String ogrID, String fotoUrl);
  Future<bool> deletePhoto(String ogrID, String fotoUrl);
  Future<bool> saveRatings(
      String ogrID, Map<String, dynamic> ratings, bool showPhotoMainPage);
  Future<List<Map<String, dynamic>>> getRatings(String ogrID);
  Future<bool> savePhotoToMainGallery(Photo myPhoto);
  Future<bool> savePhotoToSpecialGallery(Photo myPhoto);
  Future<List<Photo>> getPhotoToMainGallery();
  Future<List<Photo>> getPhotoToSpecialGallery(String ogrID);
  Future<bool> addAnnouncement(Map<String, dynamic> map);
  Future<List<Map<String, dynamic>>> getAnnouncements();
}