// ignore_for_file: must_be_immutable

import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingDetailsWidget extends StatelessWidget {
  final Map<String, dynamic> rating;
  late DragStartDetails startVerticalDragDetails;
  late DragUpdateDetails updateVerticalDragDetails;
  RatingDetailsWidget(this.rating);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AlertDialog(
        content: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white),
            child: singleRatingWidget(rating)),
      ),
      onVerticalDragStart: (dragDetails) {
        startVerticalDragDetails = dragDetails;
      },
      onVerticalDragUpdate: (dragDetails) {
        updateVerticalDragDetails = dragDetails;

        double dx = updateVerticalDragDetails.globalPosition.dx -
            startVerticalDragDetails.globalPosition.dx;
        double dy = updateVerticalDragDetails.globalPosition.dy -
            startVerticalDragDetails.globalPosition.dy;
        double? velocity = dragDetails.primaryDelta;

        //Convert values to be positive
        if (dx < 0) dx = -dx;
        if (dy < 0) dy = -dy;

        if (velocity! < 0) {
          Navigator.of(context).pop();
        }
      },
    );
  }

  Widget singleRatingWidget(Map<String, dynamic> ratingDaily) {
    return Container(
      height: 500,
      width: 140,
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              ratingDaily['Değerlendirme Tarihi'],
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              itemCount: ratingDaily.keys.length,
              itemBuilder: (context, i) {
                if (ratingDaily.keys.elementAt(i) != 'Değerlendirme Tarihi' &&
                    ratingDaily.keys.elementAt(i) != 'Özel Not') {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8),
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              ratingDaily.keys.elementAt(i),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: RatingBar(
                              itemSize: 20,
                              initialRating: ratingDaily.values.elementAt(i),
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
                                  EdgeInsets.symmetric(horizontal: 2.0),
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
          if (ratingDaily['Özel Not'] != null) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Özel Not: \n" + rating['Özel Not'].toString(),
                  style: TextStyle(color: Colors.black, fontSize: 12)),
            ),
          ],
        ],
      ),
    );
  }
}
