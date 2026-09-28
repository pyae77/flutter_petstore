import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_test_app/core/di/injection_container.dart';
import 'package:my_test_app/core/theme/app_colors.dart';
import 'package:my_test_app/core/utils/responsive_extension.dart';
import 'package:my_test_app/data/model/store_order_model.dart';
import 'package:my_test_app/gen/assets.gen.dart';
import 'package:my_test_app/presentation/bloc/my_orders_screen.dart/order_bloc.dart';
import 'package:my_test_app/presentation/bloc/my_orders_screen.dart/order_event.dart';
import 'package:my_test_app/presentation/bloc/my_orders_screen.dart/order_state.dart';
import 'package:my_test_app/presentation/widgets/custom_text_widget.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<OrderBloc>()..add(FetchOrdersEvent()),  
      child: const MyOrdersScreenView(),
    );
  }
}

class MyOrdersScreenView extends StatelessWidget {
  const MyOrdersScreenView({super.key});

  void _showSearchDialog(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const CustomTextWidget(
            text: 'Find Order by ID',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          content: TextField(
            controller: searchController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter Order ID',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final int? id = int.tryParse(searchController.text.trim());
                if (id != null) {
                  context.read<OrderBloc>().add(FindOrderByIdEvent(id));
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: EdgeInsets.all(context.w(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  Assets.icons.icBox.path,
                  height: 25,
                  width: 25,
                ),
                const CustomTextWidget(
                  textAlign: TextAlign.start,
                  text: 'My Orders',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                Row(
                  children: [
                    
                    InkWell(
                      onTap: () {
                        context.read<OrderBloc>().add(FetchOrdersEvent());
                      },
                      child: Image.asset(
                        Assets.icons.icCircleArrow.path,
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(),
            SizedBox(height: context.h(1)),

            BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                return CustomTextWidget(
                  text: 'Active Orders (Total: ${state.orders.length})',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                );
              },
            ),
            SizedBox(height: context.h(1.5)),

            Expanded(
              child: BlocConsumer<OrderBloc, OrderState>(
                listener: (context, state) {
                  if (state.status == OrderApiStatus.failure && state.errorMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMessage!),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state.status == OrderApiStatus.loading && state.orders.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.orders.isEmpty) {
                    return const Center(
                      child: CustomTextWidget(text: 'No orders found'),
                    );
                  }

                  return ListView.builder(
                    itemCount: state.orders.length,
                    itemBuilder: (context, index) {
                      final order = state.orders[index];
                      return OrderCardItem(order: order);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderCardItem extends StatelessWidget {
  final OrderModel order;
  const OrderCardItem({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final bool isPlaced = order.status.toLowerCase() == 'placed';

    final String formattedDate = order.shipDate != null
        ? "${_monthName(order.shipDate!.month)} ${order.shipDate!.day.toString().padLeft(2, '0')}, ${order.shipDate!.year}"
        : 'N/A';

    return Container(
      margin: EdgeInsets.only(bottom: context.h(2)),
      padding: EdgeInsets.all(context.w(4)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextWidget(
                text: 'Order ID: #${order.id}',
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(2.5),
                  vertical: context.h(0.4),
                ),
                decoration: BoxDecoration(
                  color: isPlaced ? Colors.green.shade100 : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: CustomTextWidget(
                  text: '[ ${_capitalize(order.status)} ]',
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isPlaced ? Colors.green.shade800 : Colors.grey.shade700,
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(0.8)),

          CustomTextWidget(
            text: 'Pet ID: #${order.petId}',
            fontSize: 13,
          ),
          SizedBox(height: context.h(0.4)),
          CustomTextWidget(
            text: 'Quantity: ${order.quantity}',
            fontSize: 13,
          ),
          SizedBox(height: context.h(0.4)),
          CustomTextWidget(
            text: 'Order Date: $formattedDate',
            fontSize: 13,
            color: Colors.grey.shade600,
          ),

          if (isPlaced) ...[
            SizedBox(height: context.h(1)),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: () {
                  context.read<OrderBloc>().add(CancelOrderEvent(order.id));
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: context.w(3),
                    vertical: context.h(0.5),
                  ),
                ),
                child: const CustomTextWidget(
                  text: 'Cancel Order',
                  fontSize: 12,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}