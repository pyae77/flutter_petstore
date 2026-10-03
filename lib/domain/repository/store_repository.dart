import 'package:pet_store_app/data/model/store_inventory_response_model.dart';
import 'package:pet_store_app/data/model/store_order_model.dart';

abstract class StoreRepository {
  Future<InventoryModel> getStoreInventory();
  Future<OrderModel> placeStoreOrder(OrderModel body);
  Future<OrderModel> findPurchaseOrderById(int orderId);
  Future<void> deletePurchaseOrderById(int orderId);
  Future<List<OrderModel>> getMyOrders();
}