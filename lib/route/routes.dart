import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:pics/page/comment/View_Comment_Page.dart';
import 'route_handlers.dart';

class Routes {
  final router = FluroRouter();

  static void defineRoutes(FluroRouter router) {
    router.define("/",
        handler: usersHandler, transitionType: TransitionType.inFromLeft);
    router.define("/home",
        handler: homeHandler, transitionType: TransitionType.inFromBottom);
    router.define("/post/:postID/comment", handler: viewCommentHandler);
    router.define("/register", handler: registerHandler);
    router.define("/profile/:uid", handler: profileHandler);
  }
}
