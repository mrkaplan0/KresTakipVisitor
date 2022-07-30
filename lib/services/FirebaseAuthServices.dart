import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:krestakipapp/models/photo.dart';
import 'package:krestakipapp/models/student.dart';
import 'package:krestakipapp/models/user.dart';
import 'package:krestakipapp/services/base/auth_base.dart';

class FirebaseAuthService implements AuthBase {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<MyUser?> currentUser() async {
    try {
      User? user = _auth.currentUser;

      return _usersFromFirebase(user!);
    } catch (e) {
      debugPrint("Hata CurrentUser $e");
      return null;
    }
  }

  MyUser _usersFromFirebase(User user) {
    return MyUser(userID: user.uid, phone: user.phoneNumber);
  }

  @override
  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      await _auth.currentUser?.delete();
      return true;
    } catch (e) {
      debugPrint("Hata SignOut $e");
      return false;
    }
  }

  @override
  Future<bool> deleteUser() async {
    try {
      await _auth.currentUser?.delete();
      return true;
    } catch (e) {
      debugPrint("Error delete account $e");
      return false;
    }
  }

  @override
  Future<MyUser?> signingWithPhone(UserCredential userCredential,
      String kresCode, String kresAdi, String ogrID, String phone) async {
    try {
      return _usersFromFirebase(userCredential.user!);
    } catch (e) {
      debugPrint("Hata phone auth $e");
      return null;
    }
  }

  @override
  Future<List<String>> getCriteria() {
    // TODO: implement getCriteria
    throw UnimplementedError();
  }

  @override
  Future<String> queryKresList(String kresCode) {
    // TODO: implement queryKresList
    throw UnimplementedError();
  }

  @override
  Future<Student?> queryOgrID(
      String kresCode, String kresAdi, String ogrID, String phoneNumber) {
    // TODO: implement ogrNoControl
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> getKresList() {
    // TODO: implement getKresList
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> getAnnouncements(
      String kresCode, String kresAdi) {
    // TODO: implement getAnnouncements
    throw UnimplementedError();
  }

  @override
  Future<List<Photo>> getPhotoToMainGallery(String kresCode, String kresAdi) {
    // TODO: implement getPhotoToMainGallery
    throw UnimplementedError();
  }

  @override
  Future<List<Photo>> getPhotoToSpecialGallery(
      String kresCode, String kresAdi, String ogrID) {
    // TODO: implement getPhotoToSpecialGallery
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> getRatings(
      String kresCode, String kresAdi, String ogrID) {
    // TODO: implement getRatings
    throw UnimplementedError();
  }
}
