import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:krestakipapp/models/photo.dart';
import 'package:krestakipapp/models/student.dart';
import 'package:krestakipapp/models/teacher.dart';
import 'package:krestakipapp/models/user.dart';
import 'package:krestakipapp/services/base/database_base.dart';
import 'package:flutter/material.dart';

class FirestoreDBService implements DBBase {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  @override
  Future<bool> saveUser(MyUser users) async {
    await _firestore
        .collection("Users")
        .doc(users.userID)
        .set(users.toMap(), SetOptions(merge: true))
        .then((value) => print("User Kaydedildi."))
        .catchError((error) => print("Kullanıcı kayıt hatası: $error"));

    DocumentSnapshot _okunanUser =
        await _firestore.doc('Users/${users.userID}').get();

    Map<String, dynamic> map = _okunanUser.data() as Map<String, dynamic>;
    MyUser _okunanUserNesnesi = MyUser.fromMap(map);

    print("Okunan user nesnesi" + _okunanUserNesnesi.toString());

    return true;
  }

  @override
  Future<MyUser> readUser(String userId) async {
    DocumentSnapshot _okunanUser =
        await _firestore.collection('Users').doc(userId).get();
    Map<String, dynamic> map = _okunanUser.data() as Map<String, dynamic>;
    MyUser _okunanUserNesnesi = MyUser.fromMap(map);

    print("Okunan user nesnesi" + map.toString());
    return _okunanUserNesnesi;
  }

  @override
  Future<bool> deleteUser(String userID) async {
    await _firestore
        .collection('Users')
        .doc(userID)
        .delete()
        .then((value) => print("User deleted."))
        .catchError((error) => print("error user can't deleted: $error"));

    return true;
  }

  @override
  Future<List<Map<String, dynamic>>> getKresList() async {
    QuerySnapshot kresler =
        await _firestore.collection("KreslerChecking").get();

    List<Map<String, dynamic>> list = [];

    for (DocumentSnapshot kres in kresler.docs) {
      Map<String, dynamic> map = kres.data()! as Map<String, dynamic>;
      list.add(map);
    }
    debugPrint(list.toString());
    return list;
  }

  @override
  Future<String> queryKresList(String kresCode) async {
    QuerySnapshot checkKresCode = await _firestore
        .collection("KreslerChecking")
        .where('kresCode', isEqualTo: kresCode)
        .get();

    if (checkKresCode.docs.isNotEmpty) {
      debugPrint(checkKresCode.docs.first.data().toString());
      Map<String, dynamic> map =
          checkKresCode.docs.first.data() as Map<String, dynamic>;
      return map['kresAdi'].toString();
    } else {
      return '';
    }
  }

  @override
  Future<Student> getStudent(String ogrNo) async {
    DocumentSnapshot docSnapshot =
        await _firestore.collection('Student').doc(ogrNo).get();

    Student student =
        Student.fromMap(docSnapshot.data()! as Map<String, dynamic>);

    print(student);

    return student;
  }

  @override
  Stream<List<Teacher>> getTeachers() {
    var snapShot = _firestore.collection('Teacher').snapshots();

    return snapShot.map((ogrList) => ogrList.docs
        .map((teacher) => Teacher.fromMap(teacher.data()))
        .toList());
  }

  @override
  Future<Student?> queryOgrID(
      String kresCode, String kresAdi, String ogrID, String phone) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection("Kresler")
        .doc(kresCode + '_' + kresAdi)
        .collection(kresAdi)
        .doc(kresAdi)
        .collection("Students")
        .where('ogrID', isEqualTo: ogrID)
        .get();
    Student? student;
    if (querySnapshot.docs.isNotEmpty) {
      debugPrint(querySnapshot.docs.first.data().toString());
      Map<String, dynamic> map =
          querySnapshot.docs.first.data() as Map<String, dynamic>;
      student = Student.fromMap(map);

      if (student.veliTelefonNo == phone) {
        String? token = await _messaging.getToken();
        student.token = token;
        await _firestore
            .collection("Kresler")
            .doc(kresCode + '_' + kresAdi)
            .collection(kresAdi)
            .doc(kresAdi)
            .collection("Students")
            .doc(student.ogrID)
            .update({'token': token});

        return student;
      } else {
        return student = null;
      }
    } else {
      return student = null;
    }
  }

  @override
  Future<List<String>> getCriteria() async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection("Criteria").doc("Criteria").get();

    List<String> kriterList = [];
    Map<String, dynamic> map = documentSnapshot.data()! as Map<String, dynamic>;
    map.values.forEach((element) {
      kriterList.add(element.toString());
    });
    return kriterList;
  }

  @override
  Future<List<Map<String, dynamic>>> getRatings(
      String kresCode, String kresAdi, String ogrID) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection("Kresler")
        .doc(kresCode + '_' + kresAdi)
        .collection(kresAdi)
        .doc(kresAdi)
        .collection('Students')
        .doc(ogrID)
        .collection("Ratings")
        .get();
    List<Map<String, dynamic>> list = [];

    for (DocumentSnapshot rating in querySnapshot.docs) {
      list.add(rating.data()! as Map<String, dynamic>);
    }

    list.sort((a, b) {
      return DateTime.parse(b['Değerlendirme Tarihi'])
          .compareTo(DateTime.parse(a['Değerlendirme Tarihi']));
    });

    return list;
  }

  @override
  Future<List<Photo>> getPhotoToMainGallery(
      String kresCode, String kresAdi) async {
    DocumentSnapshot documentSnapshot = await _firestore
        .collection("Kresler")
        .doc(kresCode + '_' + kresAdi)
        .collection(kresAdi)
        .doc(kresAdi)
        .collection('Main')
        .doc('Gallery')
        .get();

    List<Photo> photoList = [];
    Map<String, dynamic> map = documentSnapshot.data()! as Map<String, dynamic>;

    for (Map<String, dynamic> map in map.values) {
      photoList.add(Photo.fromMap(map));
    }
    debugPrint(photoList.toString());
    return photoList;
  }

  @override
  Future<List<Photo>> getPhotoToSpecialGallery(
      String kresCode, String kresAdi, String ogrID) async {
    DocumentSnapshot documentSnapshot = await _firestore
        .collection("Kresler")
        .doc(kresCode + '_' + kresAdi)
        .collection(kresAdi)
        .doc(kresAdi)
        .collection("Students")
        .doc(ogrID)
        .collection('Gallery')
        .doc(ogrID)
        .get();

    List<Photo> photoList = [];
    Map<String, dynamic> map = documentSnapshot.data()! as Map<String, dynamic>;

    for (Map<String, dynamic> map in map.values) {
      photoList.add(Photo.fromMap(map));
    }

    return photoList;
  }

  @override
  Future<List<Map<String, dynamic>>> getAnnouncements(
      String kresCode, String kresAdi) async {
    DocumentSnapshot documentSnapshot = await _firestore
        .collection("Kresler")
        .doc(kresCode + '_' + kresAdi)
        .collection(kresAdi)
        .doc(kresAdi)
        .collection("Announcement")
        .doc("Announcement")
        .get();
    List<Map<String, dynamic>> duyuruList = [];
    Map<String, dynamic> maps =
        documentSnapshot.data()! as Map<String, dynamic>;

    for (Map<String, dynamic> map in maps.values) {
      duyuruList.add(map);
    }
    duyuruList.sort((a, b) {
      return DateTime.parse(b['Duyuru Tarihi'])
          .compareTo(DateTime.parse(a['Duyuru Tarihi']));
    });
    debugPrint(duyuruList.toString());
    return duyuruList;
  }
}
