import 'package:my_test_app/data/model/store_order_model.dart';
import 'package:my_test_app/domain/repository/store_repository.dart';

class GetMyOrdersUseCase {
  final StoreRepository repository;

  GetMyOrdersUseCase(this.repository);

  Future<List<OrderModel>> call() async {
    return await repository.getMyOrders();
  }
}