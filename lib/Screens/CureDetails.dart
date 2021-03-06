import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical_app/Models/MyIcons.dart';
import 'package:medical_app/Widgets/PlacesCards.dart';

class CureDetails extends StatefulWidget {
  String name;
  String bigImage;
  CureDetails({@required this.name, @required this.bigImage});

  @override
  _CureDetailsState createState() => _CureDetailsState();
}

class _CureDetailsState extends State<CureDetails> {
  List list = List();
  bool _loading = true;
  bool _first = true;

  void _fetchNearestHealthCare(String keyword) async {
    String mainURL =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=500&types=hospitals&keyword=$keyword&key=AIzaSyCPHmXKSKZrg23UlHQ-0UZ1xoppupA2sIs';
    http.Response response =
        await http.get(mainURL, headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      Map decode = json.decode(response.body);
      list = decode["results"];
      for (var e in list) {
        print(e["geometry"]);
      }
      setState(() {
        _loading = false;
      });
    } else {
      throw Exception("Loading Data Failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_first) {
      _fetchNearestHealthCare('dentist');
      setState(() {
        _first = false ;
      });
    }
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          new Stack(
            children: <Widget>[
              new SafeArea(
                child: new Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: new BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0.0, 8.0),
                            blurRadius: 10.0)
                      ]),
                  child: new Hero(
                    tag: widget.name,
                    child: new ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0)),
                      child: new Image(
                        image: new AssetImage(widget.bigImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              new SafeArea(
                child: Container(
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0)),
                      color: Colors.white,
                      gradient: LinearGradient(
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                          colors: [
                            Colors.grey.withOpacity(0.0),
                            Colors.black.withOpacity(0.6),
                          ],
                          stops: [
                            0.0,
                            1.0
                          ])),
                ),
              ),
              new SafeArea(
                  child: Container(
                margin: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
                child: new IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: new Icon(Icons.arrow_back),
                  iconSize: 35.0,
                  color: Colors.black,
                ),
              )),
              new Positioned(
                top: MediaQuery.of(context).size.height / 3 - 20,
                left: 10.0,
                child: new Row(
                  children: <Widget>[
                    new Text(
                      widget.name,
                      style: new TextStyle(
                          letterSpacing: 1.2,
                          fontSize: 25.0,
                          fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              )
            ],
          ),
          new Expanded(
              child: new Container(
            child: new ListView.builder(
              itemCount: _loading ? 1 : list.length,
              itemBuilder: (builder, index) {
                return _loading
                    ? Center(
                        child: CircularProgressIndicator(
                        semanticsLabel: "Loading",
                      ))
                    : PlacesCard(
                        placeName: list[index]["name"],
                        streetName: list[index]["vicinity"],
                        rating: list[index]["rating"]);
              },
            ),
          ))
        ],
      ),
    );
  }
}
