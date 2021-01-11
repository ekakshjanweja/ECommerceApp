import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  String getUserId() {
    return _firebaseAuth.currentUser.uid;
  }

  final CollectionReference productReference =
      FirebaseFirestore.instance.collection('Products');
  final CollectionReference userReference =
      FirebaseFirestore.instance.collection('Users');
}
