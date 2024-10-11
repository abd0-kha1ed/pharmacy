import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> addPharmacy(String name) async {
    if (name.isEmpty) {
      throw ArgumentError('Pharmacy name must not be empty');
    }

    await db.collection('pharmacies').add({
      'name': name,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getPharmacies() {
    return db
        .collection('pharmacies')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> addRevenue(
      String pharmacyId, double amount, String? notes) async {
    await db
        .collection('pharmacies')
        .doc(pharmacyId)
        .collection('revenues')
        .add({
      'amount': amount,
      'createdAt': FieldValue.serverTimestamp(),
      'notes': notes,
    });
  }

  Stream<QuerySnapshot> getRevenues(String pharmacyId) {
    return db
        .collection('pharmacies')
        .doc(pharmacyId)
        .collection('revenues')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getRevenuesByMonthAndYear(
      String pharmacyId, int month, int year) {
    DateTime startDate = DateTime(year, month, 1);
    DateTime endDate = DateTime(year, month + 1, 0);

    return db
        .collection('pharmacies')
        .doc(pharmacyId)
        .collection('revenues')
        .orderBy('createdAt', descending: true)
        .where('createdAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .snapshots();
  }

  Stream<QuerySnapshot> getExportsByMonthAndYear(
      String pharmacyId, int month, int year) {
    DateTime startDate = DateTime(year, month, 1);
    DateTime endDate = DateTime(year, month + 1, 0);

    return db
        .collection('pharmacies')
        .doc(pharmacyId)
        .collection('exports')
        .orderBy('createdAt', descending: true)
        .where('createdAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .snapshots();
  }

  Future<void> addExport(
      String pharmacyId, double amount, String? notes) async {
    await db
        .collection('pharmacies')
        .doc(pharmacyId)
        .collection('exports')
        .add({
      'amount': amount,
      'createdAt': FieldValue.serverTimestamp(),
      'notes': notes,
    });
  }

  Stream<QuerySnapshot> getExports(String pharmacyId) {
    return db
        .collection('pharmacies')
        .doc(pharmacyId)
        .collection('exports')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> addPartner(
      String pharmacyId, String partnerName, double sharePercentage) async {
    await db
        .collection('pharmacies')
        .doc(pharmacyId)
        .collection('partners')
        .add({
      'partnerName': partnerName,
      'sharePercentage': sharePercentage,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getPartners(String pharmacyId) {
    return db
        .collection('pharmacies')
        .doc(pharmacyId)
        .collection('partners')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<double> getTotalRevenues(String pharmacyId) async {
    double totalRevenues = 0.0;

    QuerySnapshot snapshot = await db
        .collection('pharmacies')
        .doc(pharmacyId)
        .collection('revenues')
        .get();

    for (var doc in snapshot.docs) {
      double revenue = (doc.data() as Map<String, dynamic>)['amount'] ?? 0.0;
      totalRevenues += revenue;
    }

    return totalRevenues;
  }

  Future<double> getTotalExports(String pharmacyId) async {
    double totalExports = 0.0;

    QuerySnapshot snapshot = await db
        .collection('pharmacies')
        .doc(pharmacyId)
        .collection('exports')
        .get();

    for (var doc in snapshot.docs) {
      double exportAmount =
          (doc.data() as Map<String, dynamic>)['amount'] ?? 0.0;
      totalExports += exportAmount;
    }

    return totalExports;
  }

  Future<double> getTotalSharePercentage(String pharmacyId) async {
    double totalShare = 0.0;
    QuerySnapshot snapshot = await db
        .collection('pharmacies')
        .doc(pharmacyId)
        .collection('partners')
        .get();

    for (var doc in snapshot.docs) {
      double sharePercentage =
          (doc.data() as Map<String, dynamic>)['sharePercentage'].toDouble();
      totalShare += sharePercentage;
    }

    return totalShare;
  }

  Stream<QuerySnapshot> getRevenuesByYear(String pharmacyId, int year) {
    DateTime startDate = DateTime(year, 1, 1);
    DateTime endDate = DateTime(year, 12, 31);

    return db
        .collection('pharmacies')
        .doc(pharmacyId)
        .collection('revenues')
        .where('createdAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .snapshots();
  }

  Stream<QuerySnapshot> getExpensesByYear(String pharmacyId, int year) {
    DateTime startDate = DateTime(year, 1, 1);
    DateTime endDate = DateTime(year, 12, 31);

    return db
        .collection('pharmacies')
        .doc(pharmacyId)
        .collection('exports')
        .where('createdAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .snapshots();
  }

  Future<void> deleteRevenue(String pharmacyId, String revenueId) async {
    await db
        .collection('pharmacies')
        .doc(pharmacyId)
        .collection('revenues')
        .doc(revenueId)
        .delete();
  }

  Future<void> updateRevenue(
      String pharmacyId, String revenueId, double amount, String? note) async {
    await db
        .collection('pharmacies')
        .doc(pharmacyId)
        .collection('revenues')
        .doc(revenueId)
        .update({
      'amount': amount,
      'notes': note,
    });
  }

  Future<void> updateExport(
      String pharmacyId, String exportId, double amount, String? note) async {
    await db
        .collection('pharmacies')
        .doc(pharmacyId)
        .collection('exports')
        .doc(exportId)
        .update({
      'amount': amount,
      'notes': note,
    });
  }

  Future<void> deleteExport(String pharmacyId, String exportId) async {
    await db
        .collection('pharmacies')
        .doc(pharmacyId)
        .collection('exports')
        .doc(exportId)
        .delete();
  }
}
