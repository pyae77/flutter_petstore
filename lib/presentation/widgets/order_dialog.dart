import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_test_app/core/theme/app_colors.dart';
import 'package:my_test_app/core/utils/responsive_extension.dart';
import 'package:my_test_app/data/model/pet_model.dart';
import 'package:my_test_app/data/model/store_order_model.dart';
import 'package:my_test_app/presentation/bloc/main_home/main_home_bloc.dart';
import 'package:my_test_app/presentation/bloc/main_home/main_home_event.dart';
import 'package:my_test_app/presentation/bloc/my_orders_screen.dart/order_bloc.dart' show OrderBloc;
import 'package:my_test_app/presentation/bloc/my_orders_screen.dart/order_event.dart';
import 'package:my_test_app/presentation/bloc/my_orders_screen.dart/order_state.dart';
import 'package:my_test_app/presentation/cubit/quantity_cubit.dart';
import 'package:my_test_app/presentation/widgets/custom_button.dart';
import 'package:my_test_app/presentation/widgets/custom_text_widget.dart';

void showPlaceOrderDialog(BuildContext context, PetModel pet) {
  final orderBloc = context.read<OrderBloc>();
  final mainHomeBloc = context.read<MainHomeBloc>();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: orderBloc),
          BlocProvider.value(value: mainHomeBloc),
          BlocProvider(create: (context) => QuantityCubit()),
        ],
        child: PlaceOrderDialogContent(pet: pet),
      );
    },
  );
}

class PlaceOrderDialogContent extends StatelessWidget {
  final PetModel pet;

  const PlaceOrderDialogContent({
    super.key,
    required this.pet,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state.status == OrderApiStatus.success) {
      
          Navigator.of(context, rootNavigator: true).pop();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: CustomTextWidget(
                text: 'Order placed successfully! Order ID: #${state.lastCreatedOrderId}',
                color: Colors.white,
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );

       
          context.read<MainHomeBloc>().add(TabChangedEvent(1));
        }

        if (state.status == OrderApiStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: CustomTextWidget(
                text: state.errorMessage ?? "Failed to place order. Please try again.",
                color: Colors.white,
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == OrderApiStatus.loading;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: CustomTextWidget(
            text: 'Place Order for ${pet.name}',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(),
              SizedBox(height: context.h(1)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomTextWidget(
                    text: 'Pet ID:',
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  CustomTextWidget(
                    text: '#${pet.id}',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              SizedBox(height: context.h(1.5)),

              // Quantity Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomTextWidget(
                    text: 'Quantity:',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  BlocBuilder<QuantityCubit, int>(
                    builder: (context, quantity) {
                      return Row(
                        children: [
                          IconButton(
                            onPressed: (quantity > 1 && !isLoading)
                                ? () => context.read<QuantityCubit>().decrement()
                                : null,
                            icon: const Icon(Icons.remove_circle_outline),
                            color: AppColors.primaryGreen,
                          ),
                          CustomTextWidget(
                            text: '$quantity',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          IconButton(
                            onPressed: !isLoading
                                ? () => context.read<QuantityCubit>().increment()
                                : null,
                            icon: const Icon(Icons.add_circle_outline),
                            color: AppColors.primaryGreen,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: CustomButton(
                    buttonHeight: context.h(4.5),
                    backgroundColor: Colors.grey.shade200,
                    onPressed: isLoading ? null : () => Navigator.of(context, rootNavigator: true).pop(),
                    child: const CustomTextWidget(
                      text: 'Cancel',
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Confirm Button
                BlocBuilder<QuantityCubit, int>(
                  builder: (context, quantity) {
                    return Expanded(
                      child: CustomButton(
                        text: 'Confirm Order',
                        fontSize: 12,
                        textWeight: FontWeight.bold,
                        textColor: AppColors.black,
                        backgroundColor: isLoading
                            ? AppColors.primaryGreen.withValues(alpha: 0.5)
                            : AppColors.primaryGreen,
                        borderRadius: 8,
                        buttonHeight: context.h(4.5),
                        // PlaceOrderDialogContent ထဲရှိ Confirm Button Code

onPressed: isLoading
    ? null
    : () {
        final newOrder = OrderModel(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          petId: pet.id,
          quantity: quantity,
          shipDate: DateTime.now(),
          status: 'placed',
          complete: true,
        );

        context.read<OrderBloc>().add(CreateOrderEvent(newOrder));
      },
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                            : null,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}