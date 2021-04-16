import 'package:fluro/fluro.dart';
import '../page/Login_Page.dart';
import '../page/Home_Page.dart';
import '../page/register/Register_Page_Email.dart';
import '../page/comment/View_Comment_Page.dart';
import '../page/profile/Profile_Page.dart';
import '../page/View_Post_Page.dart';
import 'package:flutter/material.dart';

var usersHandler =
    Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return LoginPage();
});

var homeHandler =
    Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return HomePage();
});

var viewPostHandler =
Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return ViewPostPage(params["postID"][0]);
});

var viewCommentHandler =
    Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return ViewCommentPage(postID: params["postID"][0]);
});

var registerHandler =
    Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return RegisterPageEmail();
});

var profileHandler =
    Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return ProfilePage(UID: params["uid"][0]);
});
