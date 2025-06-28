import 'dart:io' show File;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/imageb_upload.dart';
import '../models/food_item.dart';
import 'package:food_app/views/dish_details_view.dart';
import 'package:food_app/models/app_Enviroment.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

class ScanFoodViewModel extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImageFile;
  Uint8List? _selectedImageBytes;
  bool isLoading = false;

  // Getters
  File? get selectedImageFile => _selectedImageFile;
  Uint8List? get selectedImageBytes => _selectedImageBytes;

  // Image picking
  Future<void> pickImageFromGallery() => _pickImage(ImageSource.gallery);
  Future<void> pickImageFromCamera() => _pickImage(ImageSource.camera);

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        if (kIsWeb) {
          _selectedImageBytes = await pickedFile.readAsBytes();
        } else {
          _selectedImageFile = File(pickedFile.path);
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error al seleccionar imagen: $e");
    }
  }

  // Image preview widget
  Widget imagePreviewWidget() {
    if (kIsWeb && _selectedImageBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10.5),
        child: Image.memory(_selectedImageBytes!, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
      );
    } else if (!kIsWeb && _selectedImageFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10.5),
        child: Image.file(_selectedImageFile!, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
      );
    } else {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_outlined, size: 50, color: Colors.grey),
            SizedBox(height: 8),
            Text('Toca para añadir una imagen', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }
  }

  // Upload logic (mock)
  Future<void> uploadImage(BuildContext context) async {
    final bool noImageSelected = (kIsWeb && _selectedImageBytes == null) ||
        (!kIsWeb && _selectedImageFile == null);

    if (noImageSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona una imagen primero.')),
      );
      return;
    }

    isLoading = true;
    notifyListeners();
    String? imageUrl;

    Uint8List imageBytes;
    if (kIsWeb && _selectedImageBytes != null) {
      imageBytes = _selectedImageBytes!;
    } else if (!kIsWeb && _selectedImageFile != null) {
      imageBytes = await _selectedImageFile!.readAsBytes();
    } else {
      isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: imagen no válida')),
      );
      return;
    }

    // 🔍 Paso 1: Predicción
    final predictionResult = await predictFood(imageBytes);

    if (predictionResult == null || predictionResult['prediction'] == null) {
      isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al realizar la predicción')),
      );
      return;
    }

    final String predictedCategory = predictionResult['prediction'];
    final String confidence = predictionResult['confidence'];

    if (kIsWeb && _selectedImageBytes != null) {
      imageUrl = await ImageUploadService().uploadImageBytesToImgBB(_selectedImageBytes!);
    } else if (!kIsWeb && _selectedImageFile != null) {
      imageUrl = await ImageUploadService().uploadImageToImgBB(_selectedImageFile!);
    }

    isLoading = false;
    notifyListeners();

    if (imageUrl != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Imagen subida exitosamente: $imageUrl')),
      );
      FoodItem item=await FoodItem.createFoodItem(category:predictedCategory,accuracy:confidence,imageUrl: imageUrl,userId: 1);
      await Future.delayed(const Duration(seconds: 2));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DishDetailsView(item: item),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al subir la imagen')),
      );
    }
  }

  //prediccion
  Future<Map<String, dynamic>?> predictFood(Uint8List imageBytes) async {
    final uri = Uri.parse('${AppEnvironment.apiBaseUrl}/predict');

    final request = http.MultipartRequest('POST', uri)
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: 'image.jpg',
        contentType: MediaType('image', 'jpeg'),
      ));

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return json.decode(responseBody);
      } else {
        debugPrint('Error en predicción: ${response.statusCode} - $responseBody');
        return null;
      }
    } catch (e) {
      debugPrint('Excepción en predicción: $e');
      return null;
    }
  }
}
