import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/entities/UserEntity.dart';
import '../../presentation/bloc/profile_bloc.dart';
import '../controllers/EditProfileController.dart';

class EditProfilePage extends StatefulWidget {
  final UserEntity user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final controller = EditProfileController();

  @override
  void initState() {
    super.initState();
    controller.init(widget.user);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _save() async {
    if (controller.isLoading) return; // ← ВОТ СЮДА

    final updatedUser = await controller.buildUpdatedUser(widget.user);

    context.read<ProfileBloc>().add(UpdateProfile(updatedUser));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Профиль сохранён")),
          );

          Navigator.pop(context);
        }

        if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },

      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Редактировать профиль'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  /// AVATAR
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage:
                          // Приоритет: новое выбранное фото → загруженное из сети
                          (controller.selectedImage != null)
                              ? FileImage(controller.selectedImage!)
                              : (controller.photoUrl != null && controller.photoUrl!.isNotEmpty)
                              ? NetworkImage(controller.photoUrl!)
                              : null,
                          child: (controller.selectedImage == null &&
                              (controller.photoUrl == null || controller.photoUrl!.isEmpty))
                              ? const Icon(Icons.person, size: 50, color: Colors.grey)
                              : null,
                        ),

                        // Кнопка выбора фото
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: controller.pickImageFromGallery,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(8),
                              child: controller.isLoading
                                  ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                              )
                                  : const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// FIELDS
                  TextField(
                    controller: controller.nameController,
                    decoration: const InputDecoration(
                      labelText: 'Имя',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: controller.surnameController,
                    decoration: const InputDecoration(
                      labelText: 'Фамилия',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: controller.patronymicController,
                    decoration: const InputDecoration(
                      labelText: 'Отчество',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: controller.phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Телефон',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: controller.aboutController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'О себе',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const Spacer(),

                  /// SAVE BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isLoading ? null : _save,
                      child: controller.isLoading
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : const Text('Сохранить'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}