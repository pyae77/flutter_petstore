import 'package:pet_store_app/data/model/store_order_model.dart';

enum OrderApiStatus { initial, loading, success, failure }

class OrderState {
  final OrderApiStatus status;
  final List<OrderModel> orders;
  final String? errorMessage;
  final int? lastCreatedOrderId;

  const OrderState({
    this.status = OrderApiStatus.initial,
    this.orders = const [],
    this.errorMessage,
    this.lastCreatedOrderId,
  });

  OrderState copyWith({
    OrderApiStatus? status,
    List<OrderModel>? orders,
    String? errorMessage,
    int? lastCreatedOrderId,
  }) {
    return OrderState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      errorMessage: errorMessage ?? this.errorMessage,
      lastCreatedOrderId: lastCreatedOrderId ?? this.lastCreatedOrderId,
    );
  }
}