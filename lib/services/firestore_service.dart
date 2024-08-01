import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/medicine.dart';
import '../models/alarm.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Medicine related methods
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

  Future<Medicine?> getMedicineById(String id) async {
    final doc = await _db.collection('medicines').doc(id).get();
    if (doc.exists) {
      return Medicine.fromMap(doc.data()!);
    }
    return null;
  }

  Future<String?> addAlarm(String userId, Alarm alarm) async {
    final docRef = await _db.collection('alarms').add({
      'userId': userId,
      ...alarm.toMap(),
    });
    return docRef.id; // Firestore'un otomatik oluşturduğu belge ID'sini döndür
  }

  Future<void> updateAlarm(String userId, Alarm alarm) {
    return _db.collection('alarms').doc(alarm.firestoreId).update({
      'userId': userId,
      ...alarm.toMap(),
    });
  }

  Future<void> deleteAlarm(String userId, String firestoreId) async {
    try {
      await _db.collection('alarms').doc(firestoreId).delete();
      print("Alarm başarıyla silindi: $firestoreId");
    } catch (e) {
      print("Alarm silinirken bir hata oluştu: $e");
      throw e; // Hatanın yukarıya doğru iletilmesini sağlıyoruz
    }
  }

  Stream<List<Alarm>> getAlarms(String userId) {
    return _db
        .collection('alarms')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Alarm.fromMap(doc.data(), doc.id))
            .toList());
  }
}
