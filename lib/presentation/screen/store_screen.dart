import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_store_app/core/di/injection_container.dart';
import 'package:pet_store_app/core/theme/app_colors.dart';
import 'package:pet_store_app/core/utils/responsive_extension.dart';
import 'package:pet_store_app/data/model/pet_model.dart';
import 'package:pet_store_app/gen/assets.gen.dart';
import 'package:pet_store_app/presentation/bloc/my_orders/order_bloc.dart';
import 'package:pet_store_app/presentation/bloc/store_screen/pet_bloc.dart';
import 'package:pet_store_app/presentation/bloc/store_screen/pet_event.dart';
import 'package:pet_store_app/presentation/bloc/store_screen/pet_state.dart';
import 'package:pet_store_app/presentation/widgets/custom_button.dart';
import 'package:pet_store_app/presentation/widgets/custom_text_field.dart';
import 'package:pet_store_app/presentation/widgets/custom_text_widget.dart';
import 'package:pet_store_app/presentation/widgets/order_dialog.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              sl<PetBloc>()..add(const FetchPetsByStatusEvent('available')),
        ),
        BlocProvider(create: (context) => sl<OrderBloc>()),
      ],
      child: const StoreScreenView(),
    );
  }
}

class StoreScreenView extends StatelessWidget {
  const StoreScreenView({super.key});

  final List<String> statusOptions = const ['available', 'pending', 'sold'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Input Field
        Padding(
          padding: EdgeInsets.fromLTRB(
            context.w(4),
            context.h(2),
            context.w(4),
            context.h(1),
          ),
          child: CustomTextField(
            hintText: 'Search pet name...',
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(3)),
              child: Image.asset(
                Assets.icons.icSearch.path,
                height: 20,
                width: 20,
              ),
            ),
            onChanged: (value) {
              context.read<PetBloc>().add(SearchPetByNameEvent(value));
            },
          ),
        ),

        // Status Filter Chips
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.w(4)),
          child: BlocBuilder<PetBloc, PetState>(
            builder: (context, state) {
              return Row(
                children: statusOptions.map((status) {
                  final isSelected = state.selectedStatus == status;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.w(1)),
                      child: ChoiceChip(
                        label: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              _getStatusIcon(status),
                              width: 16,
                              height: 16,
                            ),
                            SizedBox(width: context.w(1)),
                            Flexible(
                              child: CustomTextWidget(
                                text: _getStatusLabel(status),
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? AppColors.black
                                    : Colors.grey,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        selected: isSelected,
                        selectedColor: AppColors.primaryGreen.withValues(
                          alpha: 0.2,
                        ),
                        backgroundColor: Colors.grey.shade100,
                        showCheckmark: false,
                        onSelected: (selected) {
                          if (selected) {
                            context.read<PetBloc>().add(
                              FetchPetsByStatusEvent(status),
                            );
                          }
                        },
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),

        SizedBox(height: context.h(1)),

        // Pet List View with NotificationListener Pagination
        Expanded(
          child: BlocConsumer<PetBloc, PetState>(
            listener: (context, state) {
              if (state.status == PetStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.errorMessage.isEmpty
                          ? 'Failed to fetch pets'
                          : state.errorMessage,
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state.status == PetStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryGreen,
                  ),
                );
              }

              if (state.filteredPets.isEmpty) {
                return const Center(
                  child: CustomTextWidget(text: 'No pets found'),
                );
              }

              return NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (scrollInfo is ScrollEndNotification &&
                      scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent - 50) {
                    context.read<PetBloc>().add(const LoadMorePetsEvent());
                  }
                  return false;
                },
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: context.w(4)),
                  itemCount:
                      state.filteredPets.length + (state.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == state.filteredPets.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryGreen,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    }

                    final pet = state.filteredPets[index];
                    return PetCardItem(pet: pet);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return Assets.icons.icAvailable.path;
      case 'pending':
        return Assets.icons.icPending.path;
      case 'sold':
        return Assets.icons.icNotFound.path;
      default:
        return Assets.icons.icAvailable.path;
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return 'Available';
      case 'pending':
        return 'Pending';
      case 'sold':
        return 'Sold';
      default:
        return status;
    }
  }
}

class PetCardItem extends StatelessWidget {
  final PetModel pet;
  const PetCardItem({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    final categoryName = pet.category?.name.isNotEmpty == true
        ? pet.category!.name
        : 'N/A';

    return Card(
      margin: EdgeInsets.only(bottom: context.h(1.5)),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(context.w(3)),
        child: Row(
          children: [
            // Image Section
            Container(
              width: context.w(20),
              height: context.w(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: pet.photoUrls.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        pet.photoUrls.first,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Center(
                          child: Image.asset(
                            Assets.icons.icPawprint.path,
                            height: 40,
                            width: 40,
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Image.asset(
                        Assets.icons.icPawprint.path,
                        height: 40,
                        width: 40,
                      ),
                    ),
            ),
            SizedBox(width: context.w(3)),

            // Pet Info Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    text: pet.name.isEmpty ? 'Unnamed' : pet.name,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: context.h(0.5)),
                  CustomTextWidget(
                    text: 'Category: $categoryName  |  Status: ${pet.status}',
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                  SizedBox(height: context.h(1)),
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomButton(
                      text: pet.status == 'available'
                          ? 'Buy Now'
                          : 'Unavailable',
                      fontSize: 12,
                      textWeight: FontWeight.w600,
                      textColor: AppColors.black,
                      backgroundColor: pet.status == 'available'
                          ? AppColors.primaryGreen
                          : Colors.grey.shade300,
                      borderRadius: 8,
                      buttonWidth: context.w(24),
                      buttonHeight: context.h(4.2),
                      onPressed: pet.status == 'available'
                          ? () => showPlaceOrderDialog(context, pet)
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
