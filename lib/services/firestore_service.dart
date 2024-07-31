import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/medicine.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addMedicine(Medicine medicine) {
    return _db.collection('medicines').doc(medicine.id).set(medicine.toMap());
  }

  Future<void> updateMedicine(Medicine medicine) {
    return _db
        .collection('medicines')
        .doc(medicine.id)
        .update(medicine.toMap());
  }

  Future<void> deleteMedicine(String id) {
    return _db.collection('medicines').doc(id).delete();
  }

  Stream<List<Medicine>> getMedicines(String userId) {
    return _db
        .collection('medicines')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Medicine.fromMap(doc.data())).toList());
  }
}
