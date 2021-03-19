import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebaseProvider with ChangeNotifier {
  static final fireStore = FirebaseFirestore.instance;
  final appInfoCollection = fireStore.collection('app_info');
  final userCollection = fireStore.collection('users');
  final projectCollection = fireStore.collection('projects');
  late DocumentSnapshot _userSnapshot;

  DocumentSnapshot get userSnapshot => _userSnapshot;

  Future<void> getUserInfo(String userId) async {
    _userSnapshot = await userCollection.doc(userId).get();
  }

  Future<DocumentSnapshot> getAppInfo() async {
    DocumentSnapshot appInfoSnapshot =
        await appInfoCollection.doc('info').get();
    return appInfoSnapshot;
  }

  Future<List<QueryDocumentSnapshot>> getAdminData() async {
    QuerySnapshot _adminData =
        await userCollection.where("is_staff", isEqualTo: true).get();
    return _adminData.docs;
  }

  Future<List<QueryDocumentSnapshot>> getUsersData() async {
    QuerySnapshot _usersData = await userCollection.get().catchError((err) {
      print(err.message);
      throw err;
    });
    return _usersData.docs;
  }

  Future<List<QueryDocumentSnapshot>> getDownloads() async {
    QuerySnapshot _projectData = await projectCollection.get();
    return _projectData.docs;
  }
}
