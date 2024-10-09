class PartnerModel {
  final String partnerName;
  final double sharePercentage;

  PartnerModel({
    required this.partnerName,
    required this.sharePercentage,
  });

  factory PartnerModel.fromJson(Map<String, dynamic> jsonData) {
    return PartnerModel(
      partnerName: jsonData['partnerName'] ?? '',
      sharePercentage: (jsonData['sharePercentage'] as num).toDouble(),
    );
  }
}
