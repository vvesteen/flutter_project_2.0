import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../../../core/entities/UserEntity.dart';

class EditProfileController extends ChangeNotifier {
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final patronymicController = TextEditingController();
  final phoneController = TextEditingController();
  final aboutController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _photoUrl;
  String? get photoUrl => _photoUrl;

  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  final ImagePicker _picker = ImagePicker();

  // ================== Cloudinary ==================
  final String cloudName = "dtwbkgcyn";
  final String uploadPreset = "profile_images";   // создадим ниже

  void init(UserEntity user) {
    nameController.text = user.name ?? '';
    surnameController.text = user.surname ?? '';
    patronymicController.text = user.patronymic ?? '';
    phoneController.text = user.phoneNumber ?? '';
    aboutController.text = user.about ?? '';
    _photoUrl = user.photoUrl;
  }

  Future<void> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 75,
        maxWidth: 900,
      );

      if (pickedFile == null) return;

      _selectedImage = File(pickedFile.path);
      notifyListeners();

      await _uploadToCloudinary();
    } catch (e) {
      debugPrint('Ошибка выбора фото: $e');
    }
  }

  Future<UserEntity> buildUpdatedUser(UserEntity user) async {
    return user.copyWith(
      name: nameController.text.trim(),
      surname: surnameController.text.trim(),
      patronymic: patronymicController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      about: aboutController.text.trim(),
      photoUrl: _photoUrl,
    );
  }

  Future<void> _uploadToCloudinary() async {
    if (_selectedImage == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final uri = Uri.parse(
          'https://api.cloudinary.com/v1_1/$cloudName/image/upload');

      var request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', _selectedImage!.path));

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(responseString);
        _photoUrl = jsonResponse['secure_url'];
        debugPrint('✅ Фото успешно загружено: $_photoUrl');
      } else {
        debugPrint('❌ Ошибка Cloudinary: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Ошибка загрузки: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<UserEntity> save(UserEntity user) async {
    _isLoading = true;
    notifyListeners();

    final updatedUser = user.copyWith(
      name: nameController.text.trim(),
      surname: surnameController.text.trim(),
      patronymic: patronymicController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      about: aboutController.text.trim(),
      photoUrl: _photoUrl,
    );

    _isLoading = false;
    notifyListeners();
    return updatedUser;
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    patronymicController.dispose();
    phoneController.dispose();
    aboutController.dispose();
    super.dispose();
  }
}