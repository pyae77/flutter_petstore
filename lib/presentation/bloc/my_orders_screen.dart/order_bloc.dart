import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_test_app/data/model/store_order_model.dart';
import 'package:my_test_app/domain/use_cases/delete_purchase_order_by_use_case.dart';
import 'package:my_test_app/domain/use_cases/find_purchase_order_by_id_use_case.dart';
import 'package:my_test_app/domain/use_cases/get_my_orders_use_case.dart';
import 'package:my_test_app/domain/use_cases/place_order_use_case.dart';
import 'package:my_test_app/presentation/bloc/my_orders_screen.dart/order_event.dart';
import 'package:my_test_app/presentation/bloc/my_orders_screen.dart/order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final PlaceStoreOrderUseCase placeStoreOrderUseCase;
  final FindPurchaseOrderByIdUseCase findPurchaseOrderByIdUseCase;
  final DeletePurchaseOrderByIdUseCase deletePurchaseOrderByIdUseCase;
  final GetMyOrdersUseCase getMyOrdersUseCase; 
  
  OrderBloc({
    required this.placeStoreOrderUseCase,
    required this.findPurchaseOrderByIdUseCase,
    required this.deletePurchaseOrderByIdUseCase,
    required this.getMyOrdersUseCase,
  }) : super(const OrderState()) {
    on<CreateOrderEvent>(_onCreateOrder);
    on<FetchOrdersEvent>(_onFetchOrders);
    on<FindOrderByIdEvent>(_onFindOrderById);
    on<CancelOrderEvent>(_onCancelOrder);
  }

  Future<void> _onFetchOrders(FetchOrdersEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderApiStatus.loading));
    try {
      // Hive ထဲက saved IDs များဖြင့် API ပြန်ခေါ်သည့် UseCase ဖြစ်ပါသည်
      final orders = await getMyOrdersUseCase();
      emit(state.copyWith(
        status: OrderApiStatus.success,
        orders: orders,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: OrderApiStatus.failure,
        errorMessage: 'Failed to load saved orders.',
      ));
    }
  }

  Future<void> _onFindOrderById(FindOrderByIdEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderApiStatus.loading));
    try {
      final fetchedOrder = await findPurchaseOrderByIdUseCase(event.orderId);
      final existingIndex = state.orders.indexWhere((o) => o.id == fetchedOrder.id);
      List<OrderModel> updatedOrders;

      if (existingIndex != -1) {
        updatedOrders = List.from(state.orders)..[existingIndex] = fetchedOrder;
      } else {
        updatedOrders = List.from(state.orders)..insert(0, fetchedOrder);
      }

      emit(state.copyWith(
        status: OrderApiStatus.success,
        orders: updatedOrders,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: OrderApiStatus.failure,
        errorMessage: 'Order not found for ID: #${event.orderId}',
      ));
    }
  }

  Future<void> _onCreateOrder(CreateOrderEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderApiStatus.loading));
    try {
      final responseOrder = await placeStoreOrderUseCase(event.order);
      final updatedOrders = List<OrderModel>.from(state.orders)..insert(0, responseOrder);

      emit(state.copyWith(
        status: OrderApiStatus.success,
        orders: updatedOrders,
        lastCreatedOrderId: responseOrder.id,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: OrderApiStatus.failure,
        errorMessage: 'Failed to place order. Please try again.',
      ));
    }
  }

  Future<void> _onCancelOrder(CancelOrderEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderApiStatus.loading));
    try {
      await deletePurchaseOrderByIdUseCase(event.orderId);
      final updatedOrders = state.orders.where((o) => o.id != event.orderId).toList();

      emit(state.copyWith(
        status: OrderApiStatus.success,
        orders: updatedOrders,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: OrderApiStatus.failure,
        errorMessage: 'Failed to cancel order. Please try again.',
      ));
    }
  }
}