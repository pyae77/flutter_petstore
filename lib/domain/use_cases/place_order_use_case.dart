import 'package:my_test_app/data/model/store_order_model.dart';
import 'package:my_test_app/domain/repository/store_repository.dart';

class PlaceStoreOrderUseCase {
  final StoreRepository repository;

  PlaceStoreOrderUseCase(this.repository);

  Future<OrderModel> call(OrderModel body) async {
    return await repository.placeStoreOrder(body);
  }
}