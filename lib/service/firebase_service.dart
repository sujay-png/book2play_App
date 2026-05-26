import 'package:cloud_firestore/cloud_firestore.dart';

class Database {


  final String? uid;
  Database({
     this.uid,
    });
  //collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('booktoplay');

 Future<void> updateUserData({
    required String password,
    required String email,
  }) async {
    return await userCollection.doc(uid).set({
      'uid': uid,
      'name': password,
      'email': email,
     
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}