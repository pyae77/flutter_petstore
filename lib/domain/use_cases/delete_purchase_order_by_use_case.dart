import 'package:my_test_app/domain/repository/store_repository.dart';

class DeletePurchaseOrderByIdUseCase {
  final StoreRepository repository;

  DeletePurchaseOrderByIdUseCase(this.repository);

  Future<void> call(int orderId) async {
    await repository.deletePurchaseOrderById(orderId);
  }
}