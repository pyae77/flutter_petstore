import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_store_app/core/theme/app_colors.dart';
import 'package:pet_store_app/core/utils/responsive_extension.dart';
import 'package:pet_store_app/data/model/category_model.dart';
import 'package:pet_store_app/data/model/pet_model.dart';
import 'package:pet_store_app/gen/assets.gen.dart';
import 'package:pet_store_app/presentation/bloc/admin_management/admin_pet_bloc.dart';
import 'package:pet_store_app/presentation/bloc/admin_management/admin_pet_event.dart';
import 'package:pet_store_app/presentation/bloc/admin_management/admin_pet_state.dart';
import 'package:pet_store_app/presentation/widgets/custom_app_bar.dart';
import 'package:pet_store_app/presentation/widgets/custom_button.dart';
import 'package:pet_store_app/presentation/widgets/custom_dropdown_form_field.dart';
import 'package:pet_store_app/presentation/widgets/custom_text_widget.dart';
import 'package:pet_store_app/presentation/widgets/custom_textformfield.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AdminPetBloc>().add(const FetchAdminPetsEvent());

    return Scaffold(
      appBar: CustomAppBar(
        leading: Assets.icons.icArrowLeft.path,
        middleWidget: const Center(
          child: CustomTextWidget(
            text: "Admin Management",
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
        leadingPressed: () {
          if (context.canPop()) {
            context.pop();
          }
        },
      ),
      body: BlocConsumer<AdminPetBloc, AdminPetState>(
        listener: (context, state) {
          if (state is AdminPetActionSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is AdminPetErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: context.w(4),
              vertical: context.h(2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    buttonHeight: context.h(5.5),
                    backgroundColor: AppColors.primaryGreen,
                    borderRadius: 12,
                    onPressed: () => _showAddPetDialog(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          Assets.icons.icPlus.path,
                          height: 15,
                          width: 15,
                          color: AppColors.black,
                        ),
                        const SizedBox(width: 8),
                        const CustomTextWidget(
                          text: 'Add New Pet',
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: context.h(2.5)),

                const CustomTextWidget(
                  text: 'Manage Pets',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),

                SizedBox(height: context.h(1)),

                if (state is AdminPetLoadingState)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (state is AdminPetLoadedState)
                  state.pets.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: CustomTextWidget(
                              text: 'No pets found.',
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.pets.length,
                          itemBuilder: (context, index) {
                            final pet = state.pets[index];

                            return _buildAdminPetCard(
                              context,
                              pet: pet,
                            );
                          },
                        )
                else
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CustomTextWidget(
                        text: 'Failed to load pets.',
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdminPetCard(
    BuildContext context, {
    required PetModel pet,
  }) {
    return Container(
      margin: EdgeInsets.only(
        bottom: context.h(1.5),
      ),
      padding: EdgeInsets.all(
        context.w(3),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            spreadRadius: 2,
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: context.w(16),
                height: context.w(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Image.asset(
                    Assets.icons.icPawprint.path,
                    height: 40,
                    width: 40,
                  ),
                ),
              ),

              SizedBox(width: context.w(3)),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      text: pet.name ?? 'No Name',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),

                    SizedBox(height: context.h(0.5)),

                    CustomTextWidget(
                      text:
                          'Category: ${pet.category?.name ?? 'Uncategorized'}  |  Status: ${pet.status ?? 'Unknown'}',
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: context.h(1)),

          const Divider(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                icon: Assets.icons.icCamera.path,
                label: 'Upload',
                color: Colors.blue,
                onTap: () => _uploadPetPhoto(context, pet),
              ),

              _buildActionButton(
                icon: Assets.icons.icEdit.path,
                label: 'Edit',
                color: Colors.orange,
                onTap: () => _showEditPetDialog(
                  context,
                  pet,
                ),
              ),

              _buildActionButton(
                icon: Assets.icons.icTrash.path,
                label: 'Delete',
                color: Colors.red,
                onTap: () => _showDeleteConfirmDialog(
                  context,
                  pet,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
 Future<void> _uploadPetPhoto(
    BuildContext context,
    PetModel pet,
  ) async {
    final adminPetBloc = context.read<AdminPetBloc>();
    final ImagePicker picker = ImagePicker();

    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (image == null) {
        return;
      }

      final File imageFile = File(image.path);

      debugPrint('Selected image: ${imageFile.path}');
      debugPrint('Pet ID: ${pet.id}');

    
      adminPetBloc.add(
        UploadPetImageEvent(
          petId: pet.id!,
          imageFile: imageFile,
          metadata: null,
        ),
      );

    
      await Future.delayed(const Duration(seconds: 1));
      adminPetBloc.add(const FetchAdminPetsEvent());

    } catch (e) {
      debugPrint('Upload image error: $e');
    }
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 6,
        ),
        child: Row(
          children: [
            Image.asset(
              icon,
              height: 16,
              width: 16,
              color: color,
            ),

            const SizedBox(width: 4),

            CustomTextWidget(
              text: label,
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ADD PET DIALOG
  // ============================================================

void _showAddPetDialog(BuildContext context) {
  final adminPetBloc = context.read<AdminPetBloc>();
    final petNameController = TextEditingController();
    final categoryController = TextEditingController();
    final photoController = TextEditingController();
    String selectedStatus = 'available';
    File? selectedImage;

    final ImagePicker picker = ImagePicker();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const CustomTextWidget(
            text: 'Add New Pet',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: context.h(0.5)),
                
                
                GestureDetector(
                  onTap: () async {
                    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        selectedImage = File(image.path);
                        photoController.text = image.path.split('/').last;
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: CustomTextFormField(
                      controller: photoController,
                      labelText: 'Pet Photo',
                      hintText: 'Tap to pick pet photo',
                      suffixIcon: const Icon(Icons.add_a_photo_outlined, size: 20, color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(height: context.h(1.5)),

                CustomTextFormField(
                  controller: petNameController,
                  labelText: 'Pet Name',
                  hintText: 'Enter pet name',
                ),
                SizedBox(height: context.h(1.5)),

                CustomTextFormField(
                  controller: categoryController,
                  labelText: 'Category',
                  hintText: 'Enter category name',
                ),
                SizedBox(height: context.h(1.5)),

            
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    filled: true,
                    fillColor: const Color.fromARGB(255, 239, 237, 237),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'available', child: Text('available')),
                    DropdownMenuItem(value: 'pending', child: Text('pending')),
                    DropdownMenuItem(value: 'sold', child: Text('sold')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedStatus = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    buttonHeight: context.h(4.5),
                    backgroundColor: Colors.grey.shade200,
                    borderRadius: 8,
                    onPressed: () => Navigator.of(dialogContext, rootNavigator: true).pop(),
                    child: const CustomTextWidget(
                      text: 'Cancel',
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'Add',
                    fontSize: 13,
                    textWeight: FontWeight.bold,
                    textColor: Colors.black,
                    backgroundColor: AppColors.primaryGreen,
                    borderRadius: 8,
                    buttonHeight: context.h(4.5),
                   
                  
onPressed: () {
  final uniqueId = DateTime.now().millisecondsSinceEpoch;
  
  final newPet = PetModel(
    id: uniqueId,
    name: petNameController.text.trim(),
    status: selectedStatus,
    category: CategoryModel(
      id: 0,
      name: categoryController.text.trim(),
    ),
    photoUrls: const ['string'],
    tags: const [],
  );

 
  adminPetBloc.add(AddNewPetEvent(newPet, imageFile: selectedImage));

  Navigator.of(dialogContext, rootNavigator: true).pop();
},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // EDIT PET DIALOG
  // ============================================================

  void _showEditPetDialog(
    BuildContext context,
    PetModel pet,
  ) {
    final petNameController =
        TextEditingController(text: pet.name);
    final statusController=
         TextEditingController(text: pet.status);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),

        title: const CustomTextWidget(
          text: 'Edit Pet',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: context.h(1)),

            CustomTextFormField(
              controller: petNameController,
              labelText: 'Pet Name',
            ),
            CustomTextFormField(
              controller: statusController,
              labelText: 'Pet Status',
            ),
          ],
        ),

        actionsPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),

        actions: [
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  buttonHeight: context.h(4.5),
                  backgroundColor:
                      Colors.grey.shade200,
                  borderRadius: 8,

                  onPressed: () {
                    Navigator.of(
                      dialogContext,
                      rootNavigator: true,
                    ).pop();
                  },

                  child: const CustomTextWidget(
                    text: 'Cancel',
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: CustomButton(
                  text: 'Update',
                  fontSize: 13,
                  textWeight: FontWeight.bold,
                  textColor: AppColors.black,
                  backgroundColor:
                      AppColors.primaryGreen,
                  borderRadius: 8,
                  buttonHeight: context.h(4.5),

                  onPressed: () {
                    final updatedPet = PetModel(
                      id: pet.id,
                      name:
                          petNameController.text.trim(),
                      category: pet.category,
                      status: statusController.text.trim(),
                      photoUrls: pet.photoUrls,
                      tags: pet.tags,
                    );

                    context
                        .read<AdminPetBloc>()
                        .add(
                          UpdateExistingPetEvent(
                            updatedPet,
                          ),
                        );

                    Navigator.of(
                      dialogContext,
                      rootNavigator: true,
                    ).pop();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DELETE CONFIRM DIALOG
  // ============================================================

  void _showDeleteConfirmDialog(
    BuildContext context,
    PetModel pet,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),

        title: const CustomTextWidget(
          text: 'Delete Pet',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),

        content: CustomTextWidget(
          text:
              'Are you sure you want to delete "${pet.name}"?',
          fontSize: 14,
        ),

        actionsPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),

        actions: [
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  buttonHeight: context.h(4.5),
                  backgroundColor:
                      Colors.grey.shade200,
                  borderRadius: 8,

                  onPressed: () {
                    Navigator.of(
                      dialogContext,
                      rootNavigator: true,
                    ).pop();
                  },

                  child: const CustomTextWidget(
                    text: 'Cancel',
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: CustomButton(
                  text: 'Delete',
                  fontSize: 13,
                  textWeight: FontWeight.bold,
                  textColor: Colors.white,
                  backgroundColor: Colors.red,
                  borderRadius: 8,
                  buttonHeight: context.h(4.5),

                  onPressed: () {
                    if (pet.id != null) {
                      context
                          .read<AdminPetBloc>()
                          .add(
                            DeletePetByIdEvent(
                              pet.id!,
                            ),
                          );
                    }

                    Navigator.of(
                      dialogContext,
                      rootNavigator: true,
                    ).pop();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}