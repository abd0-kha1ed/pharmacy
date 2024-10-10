class PharmacyModel {
  final String pharmacyName;
  final String pharmacyId;

  PharmacyModel({
    required this.pharmacyName,
    required this.pharmacyId,
  });

  factory PharmacyModel.fromJson(Map<String, dynamic> jsonData) {
    return PharmacyModel(
      pharmacyName: jsonData['name'] ?? 'Unnamed Pharmacy',  
      pharmacyId: jsonData['id'] ?? 'Unknown ID',  
    );
  }
}
