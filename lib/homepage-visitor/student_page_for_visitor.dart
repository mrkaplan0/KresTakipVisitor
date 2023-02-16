import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:krestakipapp/View_models/user_model.dart';
import 'package:krestakipapp/common_widget/show_photo_widget.dart';
import 'package:krestakipapp/models/photo.dart';
import 'package:krestakipapp/models/student.dart';
import 'package:krestakipapp/services/admob_service.dart';
import 'package:provider/provider.dart';

import '../common_widget/show_rating_details.dart';

class StudentPage extends StatefulWidget {
  final Student student;

  StudentPage(this.student);

  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  bool isExpanded = false;
  DateTime dateTime = DateTime.now();
  List<Map<String, dynamic>> allRatings = [];

  List<Photo> album = [];

  @override
  void initState() {
    super.initState();
    getRatingsMethod().then((value) => setState(() {}));
    getIndividualPhotos().then((value) => setState(() {}));

    AdmobService.showInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          SliverAppBar(
              centerTitle: true,
              expandedHeight: MediaQuery.of(context).size.height * 4 / 8,
              //floating: true,
              stretch: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: studentProfile(context))),
          SliverList(
              delegate: SliverChildListDelegate([
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Performans Değerlendirmeleri",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                  ),
                  allRatings.isNotEmpty
                      ? SizedBox(height: 10)
                      : Text(
                          "Henüz değerlendirme yok!",
                        ),
                  allRatings.isNotEmpty ? last3Ratings() : Container(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Kişisel Galeri",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                  ),
                  album.isNotEmpty
                      ? photoGalleryWidget()
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Galeride henüz fotoğraf yok!"),
                        ),
                ])
          ]))
        ],
      ),
    );
  }

  Widget studentProfile(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 28),
        Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 4 / 8,
              width: MediaQuery.of(context).size.width,
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
                      padding: EdgeInsets.only(right: 12),
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
                                widget.student.adiSoyadi,
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
                                    text: widget.student.veliAdiSoyadi!,
                                    style: TextStyle(color: Colors.black)),
                              ])),
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: widget.student.dogumTarihi!,
                                    style: TextStyle(color: Colors.black)),
                                TextSpan(text: '  '),
                                TextSpan(
                                    text: widget.student.cinsiyet!,
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
        child: widget.student.fotoUrl != null
            ? ExtendedImage.network(
                widget.student.fotoUrl!,
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

  Widget studentProfileName() => Align(
        alignment: Alignment.topRight,
        child: Text(
          widget.student.adiSoyadi,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
      );

  Widget photoGalleryWidget() {
    if (album.length > 0)
      return Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 15),
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemCount: album.length,
          itemBuilder: (context, i) {
            return GestureDetector(
              child: Container(
                margin: EdgeInsets.all(6),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  child: ExtendedImage.network(
                    album[i].photoUrl,
                    fit: BoxFit.cover,
                    mode: ExtendedImageMode.gesture,
                    cache: true,
                  ),
                ),
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return ShowPhotoWidget(album[i].photoUrl);
                    });
              },
            );
          },
        ),
      );
    else
      return Padding(
        padding: const EdgeInsets.only(left: 14.0, right: 14),
        child: Container(
          height: 200,
        ),
      );
  }

  Future getRatingsMethod() async {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);

    allRatings = await _userModel.getRatings(_userModel.users!.kresCode!,
        _userModel.users!.kresAdi!, widget.student.ogrID);
    print(allRatings);
  }

  Widget last3Ratings() {
    return Padding(
      padding: const EdgeInsets.only(right: 15, left: 8),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 5,
        child: GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: allRatings.length > 3 ? 3 : allRatings.length,
            itemBuilder: (context, i) {
              return GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: singleRatingWidgetMini(allRatings[i]),
                ),
                onTap: () {
                  _showRatingDetails(allRatings[i]);
                },
              );
            }),
      ),
    );
  }

  Widget singleRatingWidgetMini(Map<String, dynamic> ratingDaily) {
    String date =
        ratingDaily['Değerlendirme Tarihi'].toString().substring(0, 11);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (ratingDaily['Özel Not'] != null) ...[
          Positioned(
            right: -10,
            top: -10,
            child: Icon(
              Icons.star_outlined,
              color: Colors.black,
            ),
          )
        ],
        Container(
          height: 150,
          width: 140,
          decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    date,
                    style: TextStyle(color: Colors.black, fontSize: 10),
                  ),
                ),
              ),
              Flexible(
                flex: 4,
                fit: FlexFit.tight,
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: ratingDaily.keys.length,
                    itemBuilder: (context, i) {
                      if (ratingDaily.keys.elementAt(i) !=
                              'Değerlendirme Tarihi' &&
                          ratingDaily.keys.elementAt(i) != 'Özel Not') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2.0, horizontal: 2.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    ratingDaily.keys.elementAt(i),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 8),
                                  ),
                                ),
                                Expanded(
                                  child: RatingBar(
                                    itemSize: 8,
                                    initialRating:
                                        ratingDaily.values.elementAt(i),
                                    ignoreGestures: true,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    ratingWidget: RatingWidget(
                                      full: Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      half: Icon(
                                        Icons.star_half_rounded,
                                        color: Colors.amber,
                                      ),
                                      empty: Icon(
                                        Icons.star_border_rounded,
                                        color: Colors.amber,
                                      ),
                                    ),
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 1.0),
                                    onRatingUpdate: (rating) {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future getIndividualPhotos() async {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    album = await _userModel.getPhotoToSpecialGallery(
        _userModel.users!.kresCode!,
        _userModel.users!.kresAdi!,
        widget.student.ogrID);
  }

  void _showRatingDetails(Map<String, dynamic> rating) {
    showDialog(
        context: context,
        builder: (context) {
          return RatingDetailsWidget(rating);
        });
  }
}
