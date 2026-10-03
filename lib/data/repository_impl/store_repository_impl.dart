import 'package:pet_store_app/data/data_source/local/order_local_data_source.dart';
import 'package:pet_store_app/data/data_source/remote/store_remote_data_source.dart';
import 'package:pet_store_app/data/model/store_inventory_response_model.dart';
import 'package:pet_store_app/data/model/store_order_model.dart';
import 'package:pet_store_app/domain/repository/store_repository.dart';

class StoreRepositoryImpl implements StoreRepository {
  final StoreRemoteDataSource remoteDataSource;
  final OrderLocalDataSource localDataSource;

  StoreRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<void> deletePurchaseOrderById(int orderId) async {
    await remoteDataSource.deletePurchaseOrderById(orderId);
    try {
      await localDataSource.removeOrderId(orderId);
    } catch (e) {
      print('Failed to remove order ID from Hive: $e');
    }
  }

  @override
  Future<OrderModel> placeStoreOrder(OrderModel order) async {
    final responseOrder = await remoteDataSource.placeStoreOrder(order);
    try {
      await localDataSource.saveOrderId(responseOrder.id);
    } catch (e) {
      print('Failed to save order ID to Hive: $e');
    }
    return responseOrder;
  }

  @override
  Future<List<OrderModel>> getMyOrders() async {
   
    final List<int> savedIds = await localDataSource.getSavedOrderIds();
    final List<OrderModel> orders = [];

    for (final id in savedIds) {
      try {
        final order = await remoteDataSource.findPurchaseOrderById(id);
        orders.add(order);
      } catch (e) {
    
        print('Failed to fetch order ID #$id: $e');
      }
    }
    return orders;
  }

  @override
  Future<InventoryModel> getStoreInventory() async {
    return await remoteDataSource.getStoreInventory();
  }

  @override
  Future<OrderModel> findPurchaseOrderById(int orderId) async {
    return await remoteDataSource.findPurchaseOrderById(orderId);
  }
}