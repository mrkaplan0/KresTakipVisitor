import 'dart:ui';

import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:krestakipapp/View_models/user_model.dart';
import 'package:krestakipapp/constants.dart';
import 'package:krestakipapp/models/student.dart';
import 'package:krestakipapp/models/user.dart';
import 'package:krestakipapp/signin/error_login.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class VerifyPhoneNumberScreen extends StatelessWidget {
  final String phoneNumber;
  final String kresCode;
  final String kresAdi;
  final String ogrID;

  String? _enteredOTP;

  VerifyPhoneNumberScreen({
    Key? key,
    required this.phoneNumber,
    required this.kresCode,
    required this.kresAdi,
    required this.ogrID,
  }) : super(key: key);

  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FirebasePhoneAuthHandler(
        phoneNumber: phoneNumber,
        autoRetrievalTimeOutDuration: const Duration(seconds: 60),
        onLoginSuccess: (userCredential, autoVerified) async {
          await loginSuccessMethod(userCredential, context);
        },
        onLoginFailed: (authException, st) {
          debugPrint(authException.message);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ErrorLoginPage(),
              ));

// handle error further if needed
        },
        builder: (context, controller) {
          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: backgroundColor,
              actions: [
                const SizedBox(width: 5),
              ],
            ),
            body: controller.codeSent
                ? Column(
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        "Size Bir SMS doğrulama kodu gönderdik.",
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "$phoneNumber",
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 30),
                      const Divider(),
                      const SizedBox(height: 30),
                      AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        height:
                            controller.isListeningForOtpAutoRetrieve ? null : 0,
                        child: Column(
                          children: const [
                            CircularProgressIndicator.adaptive(),
                            SizedBox(height: 50),
                          ],
                        ),
                      ),
                      const Text(
                        "Doğrulama Kodunu Giriniz.",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                        onChanged: (String v) async {
                          _enteredOTP = v;
                          if (_enteredOTP?.length == 6) {
                            final isValidOTP =
                                await controller.verifyOtp(_enteredOTP!);
// Incorrect OTP
                            if (!isValidOTP) {
                              _showSnackBar(
                                context,
                                "Lütfen kodu doğru girdiğinizden emin olunuz.",
                              );
                            }
                          }
                        },
                      ),
                      if (controller.codeSent)
                        TextButton(
                          child: Text(
                            controller.isListeningForOtpAutoRetrieve
                                ? "${controller.autoRetrievalTimeLeft}s"
                                : "Tekrar Gönder",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: controller.isListeningForOtpAutoRetrieve
                              ? null
                              : () async => await controller.sendOTP(),
                        ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator.adaptive(),
                      SizedBox(height: 50),
                      Center(
                        child: Text(
                          "Doğrulama Kodu Gönderiliyor.",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Future<void> loginSuccessMethod(
      UserCredential userCredential, BuildContext context) async {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    try {
      MyUser? _user = await _userModel.signingWithPhone(
          userCredential, kresAdi, kresAdi, ogrID, phoneNumber);
      print("Giriş yapan Kullanıcı $_user");
      if (_user != null) {
        Student? student =
            await _userModel.queryOgrID(kresCode, kresAdi, ogrID, phoneNumber);
        if (student != null) {
          Navigator.pushNamed(context, '/LandingPage');
        } else {
          await _userModel.deleteUser();
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ErrorLoginPage(),
              ));
        }
      }
    } catch (e) {
      debugPrint('Hata Giriş yaparken hata çıktı: ' + e.toString());
      _showSnackBar(
        context,
        'Phone number verified successfully!',
      );
    }
  }
}
