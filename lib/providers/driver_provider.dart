import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:move_app_1/model/drivers.dart';


class DriverProvider {
  CollectionReference _ref;

  DriverProvider() {
    _ref = FirebaseFirestore.instance.collection("Drivers");
  }

  Future<void> create(Driver driver) {
    String errorMessage;

    try {
      return _ref.doc(driver.id).set(driver.toJson());
    } catch (error) {
      errorMessage = error.code;
    }

    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
  }

  Stream<DocumentSnapshot> getByIdStream(String telefono) {
    return _ref.doc(telefono).snapshots(includeMetadataChanges: true);
  }

  Future<Driver> getById(String id) async {
    DocumentSnapshot document = await _ref.doc(id).get();
    if (document.exists) {
      Driver drive = Driver.fromJson(document.data());
      return drive;
    }
    return null;
  }

  Future<void> update(Map<String, dynamic> data, String id) {
    return _ref.doc(id).update(data);
  }
}
