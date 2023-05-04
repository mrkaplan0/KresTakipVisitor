import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:krestakipapp/locator.dart';
import 'package:krestakipapp/models/photo.dart';
import 'package:krestakipapp/models/student.dart';
import 'package:krestakipapp/models/user.dart';
import 'package:krestakipapp/repository/user_repository.dart';
import 'package:krestakipapp/services/base/auth_base.dart';

enum ViewState { idle, busy }

class UserModel with ChangeNotifier implements AuthBase {
  UserRepository _userRepository = locator<UserRepository>();
  MyUser? _users;

  String? emailHataMesaj;
  String? sifreHataMesaj;

  // ignore: unnecessary_getters_setters
  MyUser? get users => _users;
  // ignore: unnecessary_getters_setters
  set users(MyUser? value) {
    _users = value;
  }

  UserModel() {
    currentUser();
  }
  var _state = ViewState.idle;
  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  @override
  Future<MyUser?> currentUser() async {
    try {
      state = ViewState.busy;
      _users = await _userRepository.currentUser();
      if (_users != null)
        return _users;
      else
        return null;
    } catch (e) {
      return null;
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.busy;
      bool sonuc = await _userRepository.signOut();
deleteUser();
      _users = null;
      return sonuc;
    } catch (e) {
      debugPrint("User Model signout HATAAAA :" + e.toString());
      return false;
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<bool> deleteUser() async {
    try {
      state = ViewState.busy;
      bool sonuc = await _userRepository.deleteUser();

      _users = null;
      return sonuc;
    } catch (e) {
      debugPrint("Error user delete :" + e.toString());
      return false;
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<MyUser?> signingWithPhone(UserCredential userCredential,
      String kresCode, String kresAdi, String ogrID, String phone) async {
    try {
      state = ViewState.busy;
      _users = await _userRepository.signingWithPhone(
          userCredential, kresAdi, kresAdi, ogrID, phone);

      return _users;
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<String> queryKresList(String kresAdi) async {
    try {
      state = ViewState.busy;
      var sonuc = await _userRepository.queryKresList(kresAdi);

      return sonuc;
    } catch (e) {
      debugPrint("User Model query kres hata :" + e.toString());
      return "HATA:" + e.toString();
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<Student?> queryOgrID(
      String kresCode, String kresAdi, String ogrID, String phoneNumber) async {
    try {
      state = ViewState.busy;
      return await _userRepository.queryOgrID(
          kresCode, kresAdi, ogrID, phoneNumber);
    } catch (e) {
      debugPrint("User Model noContorl hata :" + e.toString());
      return null;
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<List<String>> getCriteria() async {
    try {
      var sonuc = await _userRepository.getCriteria();

      return sonuc;
    } catch (e) {
      debugPrint("User Model criter sil hata :" + e.toString());
      return List.empty();
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getRatings(
      String kresCode, String kresAdi, String ogrID) async {
    try {
      return await _userRepository.getRatings(kresCode, kresAdi, ogrID);
    } catch (e) {
      debugPrint("User Model criter getir hata :" + e.toString());
      return List.empty();
    }
  }

  @override
  Future<List<Photo>> getPhotoToMainGallery(
      String kresCode, String kresAdi) async {
    try {
      var sonuc =
          await _userRepository.getPhotoToMainGallery(kresCode, kresAdi);

      return sonuc;
    } catch (e) {
      debugPrint("User Model getphoto hata :" + e.toString());
      return List.empty();
    }
  }

  @override
  Future<List<Photo>> getPhotoToSpecialGallery(
      String kresCode, String kresAdi, String ogrID) async {
    try {
      var sonuc = await _userRepository.getPhotoToSpecialGallery(
          kresCode, kresAdi, ogrID);

      return sonuc;
    } catch (e) {
      debugPrint("User Model getphoto hata :" + e.toString());
      return List.empty();
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAnnouncements(
      String kresCode, String kresAdi) async {
    try {
      var sonuc = await _userRepository.getAnnouncements(kresCode, kresAdi);

      return sonuc;
    } catch (e) {
      debugPrint("User Model get announcement hata :" + e.toString());
      return List.empty();
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getKresList() async {
    try {
      var sonuc = await _userRepository.getKresList();

      return sonuc;
    } catch (e) {
      debugPrint("User Model get kresList hata :" + e.toString());
      return List.empty();
    } finally {
      state = ViewState.idle;
    }
  }
}
