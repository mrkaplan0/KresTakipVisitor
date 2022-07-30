import 'package:firebase_auth/firebase_auth.dart';
import 'package:krestakipapp/locator.dart';
import 'package:krestakipapp/models/photo.dart';
import 'package:krestakipapp/models/student.dart';
import 'package:krestakipapp/models/user.dart';
import 'package:krestakipapp/services/FirebaseAuthServices.dart';
import 'package:krestakipapp/services/base/auth_base.dart';
import 'package:krestakipapp/services/firestore_db_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();

  var appMode = AppMode.RELEASE;

  @override
  Future<MyUser?> currentUser() async {
    var _user = await _firebaseAuthService.currentUser();
    if (_user != null)
      return await _firestoreDBService.readUser(_user.userID!);
    else
      return null;
  }

  @override
  Future<MyUser?> signingWithPhone(UserCredential userCredential,
      String kresCode, String kresAdi, String ogrID, String phone) async {
    MyUser? _user = await _firebaseAuthService.signingWithPhone(
        userCredential, kresAdi, kresAdi, ogrID, phone);

    _user!.position = 'visitor';

    bool _sonuc = await _firestoreDBService.saveUser(_user);
    if (_sonuc) {
      return await _firestoreDBService.readUser(_user.userID!);
    } else {
      return null;
    }
  }

  @override
  Future<bool> signOut() async {
    return await _firebaseAuthService.signOut();
  }

  @override
  Future<bool> deleteUser() async {
    var _user = await _firebaseAuthService.currentUser();
    await _firestoreDBService.deleteUser(_user!.userID!);
    return await _firebaseAuthService.deleteUser();
  }

  @override
  Future<String> queryKresList(String kresAdi) async {
    return await _firestoreDBService.queryKresList(kresAdi);
  }

  @override
  Future<Student?> queryOgrID(
      String kresCode, String kresAdi, String ogrID, String phoneNumber) async {
    Student? student = await _firestoreDBService.queryOgrID(
        kresCode, kresAdi, ogrID, phoneNumber);
    if (student != null) {
      var _user = await _firebaseAuthService.currentUser();
      _user!.kresAdi = kresAdi;
      _user.kresCode = kresCode;
      _user.studentMap = student.toMap();
      _user.username = student.veliAdiSoyadi;
      _user.position = 'visitor';
      print("repo" + _user.toString());
      bool _sonuc = await _firestoreDBService.saveUser(_user);
      if (_sonuc) {
        return student;
      } else {
        return null;
      }
    } else
      return null;
  }

  @override
  Future<List<String>> getCriteria() async {
    return await _firestoreDBService.getCriteria();
  }

  @override
  Future<List<Map<String, dynamic>>> getRatings(
      String kresCode, String kresAdi, String ogrID) async {
    return await _firestoreDBService.getRatings(kresCode, kresAdi, ogrID);
  }

  @override
  Future<List<Photo>> getPhotoToMainGallery(
      String kresCode, String kresAdi) async {
    return await _firestoreDBService.getPhotoToMainGallery(kresCode, kresAdi);
  }

  @override
  Future<List<Photo>> getPhotoToSpecialGallery(
      String kresCode, String kresAdi, String ogrID) async {
    return await _firestoreDBService.getPhotoToSpecialGallery(
        kresCode, kresAdi, ogrID);
  }

  @override
  Future<List<Map<String, dynamic>>> getAnnouncements(
      String kresCode, String kresAdi) async {
    return await _firestoreDBService.getAnnouncements(kresCode, kresAdi);
  }

  @override
  Future<List<Map<String, dynamic>>> getKresList() async {
    return await _firestoreDBService.getKresList();
  }
}
