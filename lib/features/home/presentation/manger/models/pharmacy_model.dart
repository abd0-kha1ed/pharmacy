class PharmacyModel {
  final String pharmacyName;
  final String pharmacyId;

  PharmacyModel({
    required this.pharmacyName,
    required this.pharmacyId,
  });

  // دالة التحويل من JSON
  factory PharmacyModel.fromJson(Map<String, dynamic> jsonData) {
    return PharmacyModel(
      // تأكد من أن أسماء الحقول تطابق تلك الموجودة في Firestore
      pharmacyName: jsonData['name'] ?? 'Unnamed Pharmacy',  // معالجة في حال عدم وجود الاسم
      pharmacyId: jsonData['id'] ?? 'Unknown ID',  // يجب إضافة معرف المستند عند استرجاعه
    );
  }
}
