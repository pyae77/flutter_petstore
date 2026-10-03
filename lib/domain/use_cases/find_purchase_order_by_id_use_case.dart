import 'package:pet_store_app/data/model/store_order_model.dart';
import 'package:pet_store_app/domain/repository/store_repository.dart';

class FindPurchaseOrderByIdUseCase {
  final StoreRepository repository;

  FindPurchaseOrderByIdUseCase(this.repository);

  Future<OrderModel> call(int orderId) async {
   
    if (orderId <= 0) {
      throw Exception('Order ID must be a positive number.');
    }

    try {
      return await repository.findPurchaseOrderById(orderId);
    } catch (e) {
      rethrow;
    }
  }
}