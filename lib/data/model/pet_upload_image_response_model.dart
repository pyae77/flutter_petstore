class PetUploadImageResponseModel {
  final int code;
  final String type;
  final String message;

  PetUploadImageResponseModel({
    required this.code,
    required this.type,
    required this.message,
  });

  factory PetUploadImageResponseModel.fromJson(Map<String, dynamic> json) {
    return PetUploadImageResponseModel(
      code: json['code'] ?? 0,
      type: json['type'] ?? '',
      message: json['message'] ?? '',
    );
  }
}