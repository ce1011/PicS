import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseUserDataAgent {
  CollectionReference _fireStoreInstance =
      FirebaseFirestore.instance.collection("user");

  firebase_storage.FirebaseStorage _storageInstance =
      firebase_storage.FirebaseStorage.instance;

  Future<String> getUserIconURL(String UID) {}

  Future<String> getDocumentID(String UID) async {
    String documentID;

    await _fireStoreInstance
        .where('UID', isEqualTo: UID)
        .get()
        .then((data) => documentID = data.docs[0].id);

    return documentID;
  }

  Future<String> getUserName(String UID) async {
    String username;

    await _fireStoreInstance
        .where('UID', isEqualTo: UID)
        .get()
        .then((data) => username = data.docs[0].data()['username']);

    return username;
  }

  Future<String> getUIDByUsername(String username) async {
    String UID;

    await _fireStoreInstance
        .where('username', isEqualTo: username)
        .get()
        .then((data) => UID = data.docs[0].data()['UID']);

    return UID;
  }

  Future<String> getDisplayName(String UID) async {
    String displayName;

    await _fireStoreInstance
        .where('UID', isEqualTo: UID)
        .get()
        .then((data) => displayName = data.docs[0].data()['displayName'])
        .catchError((onError) => displayName = "Error");

    return displayName;
  }

  Future<String> getUserPersonalDescription(String UID) {}

  Future<QuerySnapshot> getUserCustomGroupList(String UID) {}
}
