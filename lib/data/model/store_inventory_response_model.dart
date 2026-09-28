import 'package:my_test_app/domain/entity/inventory_entity.dart';

class InventoryModel extends InventoryEntity {
  const InventoryModel({required super.statusCounts});

  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    final Map<String, int> counts = {};

    
    json.forEach((key, value) {
      counts[key] = (value as num).toInt();
    });

    return InventoryModel(statusCounts: counts);
  }

  Map<String, dynamic> toJson() {
    return statusCounts;
  }
}