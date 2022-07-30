import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:krestakipapp/common_widget/image_widget.dart';
import 'package:krestakipapp/models/student.dart';

class StudentProfileWidget extends StatelessWidget {
  final Student student;

  StudentProfileWidget(this.student);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(shrinkWrap: true, slivers: [
        SliverAppBar(
            backgroundColor: ThemeData().scaffoldBackgroundColor,
            centerTitle: true,
            expandedHeight: MediaQuery.of(context).size.height * 2,
            // floating: true,
            stretch: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
                centerTitle: true, background: studentProfile(context))),
      ]),
    );
  }

  Column studentProfile(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 28),
        Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 4 / 8,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                color: Colors.amberAccent,
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.elliptical(75, 55)),
              ),
              child: Stack(
                children: [
                  SizedBox.fromSize(
                      child: stuProfileImage(context),
                      size: Size(MediaQuery.of(context).size.width,
                          MediaQuery.of(context).size.height * 3 / 8 + 45)),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 1 / 8,
                      width: MediaQuery.of(context).size.width + 2,
                      decoration: BoxDecoration(
                        color: ThemeData().scaffoldBackgroundColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.elliptical(70, 50)),
                      ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                student.adiSoyadi,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26,
                                ),
                              ),
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: '(Veli)  ',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12)),
                                TextSpan(
                                    text: student.veliAdiSoyadi!,
                                    style: TextStyle(color: Colors.black)),
                              ])),
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: student.dogumTarihi!,
                                    style: TextStyle(color: Colors.black)),
                                TextSpan(text: '  '),
                                TextSpan(
                                    text: student.cinsiyet!,
                                    style: TextStyle(color: Colors.black))
                              ])),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget stuProfileImage(BuildContext context) => Container(
        child: student.fotoUrl != null
            ? ExtendedImage.network(
                student.fotoUrl!,
                fit: BoxFit.cover,
                mode: ExtendedImageMode.gesture,
                cache: true,
              )
            : Center(
                child: Icon(
                Icons.person,
                size: 250,
                color: Colors.black45,
              )),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.only(bottomRight: Radius.elliptical(75, 55)),
        ),
      );

  Widget stuName() => Align(
        alignment: Alignment.topRight,
        child: Text(
          student.adiSoyadi,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
      );
}
