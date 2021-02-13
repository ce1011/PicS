import 'package:flutter/material.dart';

class CircleIcon extends StatelessWidget {
  String url;

  CircleIcon({Key key, String url}) : super(key: key){
    this.url = url;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.fill,
              image: NetworkImage(
                  url))),
    );
  }
}
