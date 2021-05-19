import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:move_app_1/model/users.dart';


class UsersProvider {
  CollectionReference _ref;

  UsersProvider() {
    _ref = FirebaseFirestore.instance.collection("Users");
  }

  get authProvider => null;

  Future<void> create(Users users) {
    String errorMessage;

    try {
      return _ref.doc(users.id).set(users.toJson());
    } catch (error) {
      errorMessage = error.code;
    }

    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
  }

  Stream<DocumentSnapshot> getByIdStream(String id) {
    return _ref.doc(id).snapshots(includeMetadataChanges: true);
  }

  Future<Users> getById(String id) async {
    DocumentSnapshot document = await _ref.doc(id).get();
    if (document.exists) {
      Users users = Users.fromJson(document.data());
      return users;
    }
    return null;
  }

  Future<void> update(Map<String, dynamic> data, String id) {
    return _ref.doc(id).update(data);
  }

  //static sendEmailVerification() {}

  void onAuthStateChanged(Null Function(User) ) {}
}
