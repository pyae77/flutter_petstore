import 'package:my_test_app/domain/entity/store_order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.petId,
    required super.quantity,
    super.shipDate,
    required super.status,
    required super.complete,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      petId: json['petId'] ?? 0,
      quantity: json['quantity'] ?? 0,
      shipDate: json['shipDate'] != null
          ? DateTime.tryParse(json['shipDate'].toString())
          : null,
      status: json['status'] ?? '',
      complete: json['complete'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'petId': petId,
      'quantity': quantity,
      'shipDate': shipDate?.toIso8601String(),
      'status': status,
      'complete': complete,
    };
  }

  
}