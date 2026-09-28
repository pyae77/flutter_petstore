import 'package:hive_flutter/adapters.dart';

abstract class OrderLocalDataSource {
  Future<void> saveOrderId(int orderId);
  Future<List<int>> getSavedOrderIds(); 
  Future<void> removeOrderId(int orderId);
}

class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  static const String _boxName = 'order_ids_box';

  Future<Box<int>> _getBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<int>(_boxName);
    }
    return await Hive.openBox<int>(_boxName);
  }

  static Future<void> init() async {
    await Hive.openBox<int>(_boxName);
  }

  @override
  Future<void> saveOrderId(int orderId) async {
    final box = await _getBox();
    if (!box.values.contains(orderId)) {
      await box.add(orderId);
    }
  }

  @override
  Future<List<int>> getSavedOrderIds() async {
    final box = await _getBox(); 
    return box.values.toList().reversed.toList();
  }

  @override
  Future<void> removeOrderId(int orderId) async {
    final box = await _getBox();
    final map = box.toMap();
    final dynamic key = map.keys.firstWhere(
      (k) => map[k] == orderId,
      orElse: () => null,
    );
    if (key != null) {
      await box.delete(key);
    }
  }
}