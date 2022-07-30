import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:krestakipapp/landing_page.dart';
import 'package:krestakipapp/main.dart';

import 'package:provider/provider.dart';
import 'View_models/user_model.dart';
import 'constants.dart';
import 'locator.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print(
      "Handling a background message: ${message.messageId} ve ${message.data}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Container();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return ChangeNotifierProvider(
            create: (context) => UserModel(),
            child: GetMaterialApp(
              navigatorKey: navigatorKey,
              routes: {
                '/LandingPage': (context) => LandingPage(),
              },
              theme: ThemeData(
                  primarySwatch: primarySwatch,
                  primaryColor: primaryColor,
                  textTheme: Theme.of(context)
                      .textTheme
                      .apply(displayColor: textColor),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: TextButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: EdgeInsets.all(kdefaultPadding),
                    ),
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    border: textFieldBorder,
                    enabledBorder: textFieldBorder,
                    focusedBorder: textFieldBorder,
                  ),
                  appBarTheme:
                      AppBarTheme(backgroundColor: Colors.white, elevation: 0)),
              debugShowCheckedModeBanner: false,
              home: LandingPage(),
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}

Future<void> showDialogToVisitor(RemoteMessage remoteMessage) async {
  showDialog(
      context: navigatorKey.currentState!.context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(remoteMessage.data['title']),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(remoteMessage.data['message']),
            ),
            ButtonBar(
              children: [
/*
                  ElevatedButton(
                    onPressed: () async {
                      try {

                        final UserModel _userModel =
                            Provider.of<UserModel>(context, listen: false);
                        bool sonuc = await _firmModel.personelEkleVeSil(
                            _userModel.users!.firma!,
                            remoteMessage.data['gonderenUserID'],
                            remoteMessage.data['gonderenUserEmail'],
                            true);

                        if (sonuc == true) {
                          Navigator.of(context).pop();
                          Get.snackbar('İşlem Tamam!', 'Kayıt Başarılı.',
                              snackPosition: SnackPosition.BOTTOM);
                          _sendingNotificationService
                              .sendNotificationToPersonel(
                                  remoteMessage.data['gönderenUserToken']);
                        } else {
                          Get.snackbar('HATA',
                              'Kayıt işlemi başarısız, lütfen tekrar deneyiniz.');
                        }
                      } catch (e) {
                        debugPrint(
                            'Personel ekleme arama hatası ' + e.toString());
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.orangeAccent)),
                    child: Text("Kaydet"),
                  ),
*/
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blueGrey)),
                  child: Text("İptal"),
                ),
              ],
            ),
          ],
        );
      });
}
