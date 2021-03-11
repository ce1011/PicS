import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseUserDataAgent{

  CollectionReference _fireStoreInstance = FirebaseFirestore.instance.collection("user");

  firebase_storage.FirebaseStorage _storageInstance = firebase_storage.FirebaseStorage.instance;

  Future<String> getUserIconURL(String UID){

  }

  Future<String> getUserName(String UID){

  }

  Future<String> getUserPersonalDescription(String UID){

  }

  Future<QuerySnapshot> getUserCustomGroupList(String UID){

  }
}