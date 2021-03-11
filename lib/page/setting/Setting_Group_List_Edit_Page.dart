import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../firebase/Firebase_User_Data_Agent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingGroupListEditPage extends StatefulWidget {
  @override
  _SettingGroupListEditPageState createState() => _SettingGroupListEditPageState();
}

class _SettingGroupListEditPageState extends State<SettingGroupListEditPage> {
  DocumentReference firestoreInstance = FirebaseFirestore.instance.collection('group').doc('UID').collection('friends').doc();

  Future<void> updateGroup(String groupName){

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

