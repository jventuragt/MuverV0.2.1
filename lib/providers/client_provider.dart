import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:move_app_1/model/client.dart';

class ClientProvider {
  CollectionReference _ref;

  ClientProvider() {
    _ref = FirebaseFirestore.instance.collection("client");
  }

  get authProvider => null;

  Future<void> create(Clients clients) {
    String errorMessage;

    try {
      return _ref.doc(clients.id).set(clients.toJson());
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

  Future<Clients> getById(String id) async {
    DocumentSnapshot document = await _ref.doc(id).get();
    if (document.exists) {
      Clients clients = Clients.fromJson(document.data());
      return clients;
    }
    return null;
  }

  Future<void> update(Map<String, dynamic> data, String id) {
    return _ref.doc(id).update(data);
  }

  static sendEmailVerification() {}

  void onAuthStateChanged(Null Function(Clients)) {}
}
