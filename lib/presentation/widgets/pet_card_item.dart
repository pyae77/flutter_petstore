import 'package:flutter/material.dart';
import 'package:pet_store_app/core/theme/app_colors.dart';
import 'package:pet_store_app/core/utils/responsive_extension.dart';
import 'package:pet_store_app/data/model/pet_model.dart';
import 'package:pet_store_app/presentation/widgets/custom_text_widget.dart';

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
                        errorBuilder: (_, _, _) => const Icon(Icons.pets, size: 36, color: Colors.grey),
                      ),
                    )
                  : const Icon(Icons.pets, size: 36, color: Colors.grey),
            ),
            SizedBox(width: context.w(3)),

            // Text Info Section
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
                    child: ElevatedButton(
                      onPressed: pet.status == 'available' ? () {} : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: context.w(4),
                          vertical: context.h(0.8),
                        ),
                      ),
                      child: CustomTextWidget(
                        text: pet.status == 'available' ? 'Buy Now' : 'Unavailable',
                        fontSize: 12,
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
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