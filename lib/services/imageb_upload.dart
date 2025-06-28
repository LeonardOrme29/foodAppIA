import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:food_app/models/app_Enviroment.dart';
import 'dart:typed_data';

class ImageUploadService {
  static const String _apiKey = AppEnvironment.apiImgBB;
  static const String _uploadUrl = 'https://api.imgbb.com/1/upload';

  // Para plataformas móviles
  Future<String?> uploadImageToImgBB(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    return _uploadBytes(bytes);
  }

  // Para Web (Uint8List)
  Future<String?> uploadImageBytesToImgBB(Uint8List imageBytes) async {
    return _uploadBytes(imageBytes);
  }

  Future<String?> _uploadBytes(Uint8List bytes) async {
    final base64Image = base64Encode(bytes);
    final url = Uri.parse('https://api.imgbb.com/1/upload?key=$_apiKey');

    try {
      final response = await http.post(url, body: {
        'image': base64Image,
      });

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['data']['url']; // o 'display_url' si prefieres
      } else {
        print('Error al subir la imagen: ${response.body}');
      }
    } catch (e) {
      print('Excepción al subir la imagen: $e');
    }

    return null;
  }
}
