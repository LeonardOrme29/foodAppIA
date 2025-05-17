import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ScanFoodView extends StatefulWidget {
  const ScanFoodView({super.key});

  @override
  State<ScanFoodView> createState() => _ScanFoodViewState();
}

class _ScanFoodViewState extends State<ScanFoodView> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error al seleccionar imagen: $e');
      if (mounted) { // Verificar si el widget está montado antes de mostrar el SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al seleccionar imagen: $e')),
        );
      }
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galería'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Cámara'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0A543D);
    const Color buttonColor = Color(0xFF4CAF50);
    const Color frameColor = Colors.white;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: ClipPath(
              clipper: OvalBottomClipper(),
              child: Container(
                color: primaryColor,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: 60),
                    Image.asset(
                      'lib/assets/logo.png',
                      height: 180,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Captura o Sube una foto del plato',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 32),
                    GestureDetector(
                      onTap: () {
                        _showImageSourceActionSheet(context);
                      },
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: frameColor,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: Colors.grey.shade400,
                            width: 1.5,
                          ),
                        ),
                        child: _selectedImage != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(10.5),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        )
                            : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo_outlined,
                                size: 50,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Toca para añadir una imagen',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (_selectedImage != null) {
                          print('Subiendo imagen: ${_selectedImage!.path}');
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Subiendo: ${_selectedImage!.path}')),
                            );
                          }
                        } else {
                          print('Por favor, selecciona una imagen primero.');
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Por favor, selecciona una imagen primero.')),
                            );
                          }
                        }
                      },
                      child: const Text(
                        'Subir',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OvalBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height * 0.75);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
