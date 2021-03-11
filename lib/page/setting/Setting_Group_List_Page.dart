import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../firebase/Firebase_User_Data_Agent.dart';

class SettingGroupListPage extends StatefulWidget {
  @override
  _SettingGroupListPageState createState() => _SettingGroupListPageState();
}

class _SettingGroupListPageState extends State<SettingGroupListPage> {
  FirebaseUserDataAgent firebaseUserDataAgent = FirebaseUserDataAgent();

  QuerySnapshot groupList;

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
