import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:krestakipapp/View_models/user_model.dart';
import 'package:krestakipapp/common_widget/show_photo_widget.dart';
import 'package:krestakipapp/constants.dart';
import 'package:krestakipapp/homepage-visitor/announcement_page.dart';
import 'package:krestakipapp/homepage-visitor/photo_gallery.dart';
import 'package:krestakipapp/models/photo.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Photo>? album = [];
  @override
  void initState() {
    super.initState();
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    _userModel
        .getPhotoToMainGallery(
            _userModel.users!.kresCode!, _userModel.users!.kresAdi!)
        .then((value) {
      setState(() {
        album = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
          //centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            "${_userModel.users!.kresAdi}",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          actions: [
            IconButton(
              onPressed: () => _cikisyap(context),
              icon: Icon(Icons.logout),
            ),
          ]),
      body: SingleChildScrollView(
        child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: kdefaultPadding,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Fotoğraf Galerisi",
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PhotoGallery(album)));
                        },
                        child: Text(
                          "Tümünü Gör",
                          style: TextStyle(color: Colors.black26),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                photoGalleryWidget(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: GestureDetector(
                    child: Container(
                        child: Image.asset("assets/images/gallery7.png")),
                    onTap: () {},
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        "Duyurular",
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 11.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AnnouncementPage()));
                        },
                        child: Text(
                          "Tümünü Gör",
                          style: TextStyle(color: Colors.black26),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: announcementList(),
                ),
              ],
            )),
      ),
    );
  }

  Widget announcementList() {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: _userModel.getAnnouncements(
            _userModel.users!.kresCode!, _userModel.users!.kresAdi!),
        builder: (context, sonuc) {
          if (sonuc.hasData) {
            var announceList = sonuc.data!;
            if (announceList.length > 0) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: announceList.length > 3 ? 3 : announceList.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "${announceList[i]['Duyuru Tarihi']}      ${announceList[i]['Duyuru Başlığı']}"),
                          /*  Text(
                            "Detayı Gör",
                            style: TextStyle(
                                // fontStyle: FontStyle.italic,
                                color: Colors.black26),
                          )*/
                          IconButton(
                            icon: Icon(
                                Icons.keyboard_double_arrow_right_outlined),
                            onPressed: () => _showAnnouncementDetail(
                                announceList[i]['Duyuru Başlığı'],
                                announceList[i]['Duyuru']),
                          )
                        ],
                      ),
                    );
                  });
            } else {
              return Text("Henüz duyuru yok.");
            }
          } else
            return Center(
              child: Text("Henüz duyuru yok."),
            );
        });
  }

  Widget photoGalleryWidget() {
    if (album!.length > 0)
      return Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 15),
        child: Container(
          height: 160,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: album!.length > 3 ? 3 : album!.length,
              itemBuilder: (context, i) {
                return GestureDetector(
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 6),
                        height: 130,
                        width: 180,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          child: ExtendedImage.network(
                            album![i].photoUrl,
                            fit: BoxFit.cover,
                            mode: ExtendedImageMode.gesture,
                            cache: true,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 6),
                        height: 130,
                        width: 180,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.grey.shade200.withOpacity(0.1),
                                  Colors.black12.withOpacity(0.3),
                                  Colors.black26.withOpacity(0.5),
                                ],
                                stops: [
                                  0.4,
                                  0.8,
                                  1,
                                ])),
                      ),
                      album![i].info != null
                          ? Positioned(
                              child: Text(
                                album![i].info!,
                                style: TextStyle(color: Colors.grey),
                              ),
                              bottom: 35,
                              left: 13,
                            )
                          : Text(""),
                    ],
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return ShowPhotoWidget(album![i].photoUrl);
                        });
                  },
                );
              }),
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

  Future<bool> _cikisyap(BuildContext context) async {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    bool sonuc = await _userModel.signOut();
    return sonuc;
  }

  _showAnnouncementDetail(
      String announcementTitle, String? announcementDetail) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(announcementTitle),
            content: SingleChildScrollView(
              child: Text(announcementDetail != null
                  ? announcementDetail
                  : "Detay Yok"),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Kapat'),
              )
            ],
          );
        });
  }
}
