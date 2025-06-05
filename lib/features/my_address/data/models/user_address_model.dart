class UserAddressModel {
  final int id;
  final int regionId;
  final int cityId;
  final String addressLine;
  final String postalCode;
  final String label;

  UserAddressModel({
    required this.id,
    required this.regionId,
    required this.cityId,
    required this.addressLine,
    required this.postalCode,
    required this.label,
  });

  factory UserAddressModel.fromJson(Map<String, dynamic> json) {
    return UserAddressModel(
      id: json['id'],
      regionId: json['regionId'],
      cityId: json['cityId'],
      addressLine: json['addressLine'],
      postalCode: json['postalCode'],
      label: json['label'],
    );
  }

  Map<String, dynamic> toJson() => {
    'regionId': regionId,
    'cityId': cityId,
    'addressLine': addressLine,
    'postalCode': postalCode,
    'label': label,
  };
}
