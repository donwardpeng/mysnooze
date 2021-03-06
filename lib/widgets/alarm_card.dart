import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/alarm.dart';

class AlarmCard extends StatelessWidget {
  Alarm alarm;
  bool inFavorites;
  Function onFavoriteButtonPressed;

  AlarmCard([
    @required this.alarm,
    // @required this.inFavorites,
    // @required this.onFavoriteButtonPressed
  ]);

  @override
  Widget build(BuildContext context) {
    RawMaterialButton _buildFavoriteButton() {
      return RawMaterialButton(
        constraints: const BoxConstraints(minWidth: 40.0, minHeight: 40.0),
        onPressed: () => onFavoriteButtonPressed(alarm.id),
        child: Icon(
          // Conditional expression:
          // show "favorite" icon or "favorite border" icon depending on widget.inFavorites:
          inFavorites == true ? Icons.favorite : Icons.favorite_border,
        ),
        elevation: 2.0,
        fillColor: Colors.white,
        shape: CircleBorder(),
      );
    }

    Padding _buildTitleSection() {
      return Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          // Default value for crossAxisAlignment is CrossAxisAlignment.center.
          // We want to align title and description of recipes left:
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              alarm.name,
              style: Theme.of(context).textTheme.title,
            ),
            // Empty space:
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.timer, size: 20.0),
                SizedBox(width: 5.0),
                Text(new DateFormat.yMMMMd().format(alarm.dateTime) +
                    ' ' +
                    new DateFormat.jm().format(alarm.dateTime)),
                Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0),),
                Icon(
                  Icons.timelapse,
                  size: 20.0,
                ),
                Text(alarm.duration.inHours.toString() +
                    "h," +
                    ((alarm.duration.inMinutes - alarm.duration.inHours*60)).toString()+
                    "m")
              ],
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () => print("Tapped!"),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Card(
          color: Color.fromARGB(0xff, 0xff, 0xec, 0xb3),
          //  Colors.amber,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // We overlap the image and the button by
              // creating a Stack object:
              Stack(
                children: <Widget>[
                  AspectRatio(
                      aspectRatio: 16.0 / 9.0,
                      child: Image.asset(
                          // './assets/alarm' + alarm.id.toString() + '.jpg',
                      './assets/alarm1.jpg',

                          fit: BoxFit.cover)
                      // Image.network(
                      //   recipe.imageURL,
                      //   fit: BoxFit.cover,
                      // ),
                      ),
                  Positioned(
                    child: _buildFavoriteButton(),
                    top: 2.0,
                    right: 2.0,
                  ),
                ],
              ),
              _buildTitleSection(),
            ],
          ),
        ),
      ),
    );
  }
}
