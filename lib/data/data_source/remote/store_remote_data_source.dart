import 'package:my_test_app/core/services/dio_client.dart';
import 'package:my_test_app/data/model/store_inventory_response_model.dart';
import 'package:my_test_app/data/model/store_order_model.dart';

abstract class StoreRemoteDataSource {
  Future<InventoryModel> getStoreInventory();
  Future<OrderModel> placeStoreOrder(OrderModel body);
  Future<OrderModel> findPurchaseOrderById(int orderId);
  Future<void> deletePurchaseOrderById(int orderId);

}
class StoreRemoteDataSourceImpl implements StoreRemoteDataSource{
  final DioClient dio;
  StoreRemoteDataSourceImpl(this.dio);
  @override
  Future<void> deletePurchaseOrderById(int orderId) async{
    await dio.instance.delete('/store/order/$orderId');
    
  }

  @override
  Future<OrderModel> placeStoreOrder(OrderModel body) async{
    final response=await dio.instance.post('/store/order',data: body.toJson());
    return OrderModel.fromJson(response.data);
  }

  @override
  Future<InventoryModel> getStoreInventory() async{
    final response=await dio.instance.get('/store/inventory');
    return InventoryModel.fromJson(response.data);
  }

  @override
  Future<OrderModel> findPurchaseOrderById(int orderId)async {
    final response=await dio.instance.get('/store/order/$orderId');
    return OrderModel.fromJson(response.data);
  }

}