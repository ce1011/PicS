import 'package:fluro/fluro.dart';
import '../page/Login_Page.dart';
import '../page/Home_Page.dart';
import '../page/register/Register_Page_Email.dart';
import '../page/comment/View_Comment_Page.dart';
import 'package:flutter/material.dart';

var usersHandler =
    Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return LoginPage();
});

var homeHandler =
Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return HomePage();
});

var viewCommentHandler =
Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return ViewCommentPage(postID: params["postID"][0]);
});

var registerHandler =
Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return RegisterPageEmail();
});