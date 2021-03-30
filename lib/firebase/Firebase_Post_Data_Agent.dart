import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebasePostDataAgent{

  CollectionReference _fireStoreInstance = FirebaseFirestore.instance.collection("post");

  firebase_storage.FirebaseStorage _storageInstance = firebase_storage.FirebaseStorage.instance;

  Future<String> getPostImageURL(String postID) async {
    String url;
    url = await _storageInstance.ref('/post/'+postID+'.jpg').getDownloadURL();
    return url;
  }

  Future<String> getPostVideoURL(String postID) async {
    String url;
    url = await _storageInstance.ref('/post/'+postID+'.mp4').getDownloadURL();
    return url;
  }

}