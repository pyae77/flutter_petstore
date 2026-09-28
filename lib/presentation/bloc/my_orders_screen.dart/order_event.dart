import 'package:my_test_app/data/model/store_order_model.dart';

abstract class OrderEvent {}

class FetchOrdersEvent extends OrderEvent {}

class FetchInventoryEvent extends OrderEvent {}

class FindOrderByIdEvent extends OrderEvent {
  final int orderId;
  FindOrderByIdEvent(this.orderId);
}

class CancelOrderEvent extends OrderEvent {
  final int orderId;
  CancelOrderEvent(this.orderId);
}

class CreateOrderEvent extends OrderEvent {
  final OrderModel order;
  CreateOrderEvent(this.order);
}