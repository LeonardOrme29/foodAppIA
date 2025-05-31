import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/scan_food_viewmodel.dart';

class ScanFoodView extends StatelessWidget {
  const ScanFoodView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ScanFoodViewModel>(context);

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
              child: Container(color: primaryColor),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    Image.asset('lib/assets/logo.png', height: 180),
                    const SizedBox(height: 16),
                    const Text(
                      'Captura o Sube una foto del plato',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 32),
                    GestureDetector(
                      onTap: () => _showImageSourceOptions(context, vm),
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: frameColor,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: Colors.grey.shade400, width: 1.5),
                        ),
                        child: vm.imagePreviewWidget(),
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 45, 
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20), // Mayor padding
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: vm.isLoading
                            ? null
                            : () => vm.uploadImage(context),
                        child: vm.isLoading
                            ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                            : const Text('Subir', style: TextStyle(color: Colors.white)),
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

  void _showImageSourceOptions(BuildContext context, ScanFoodViewModel vm) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text("Galería"),
              onTap: () {
                Navigator.pop(context);
                vm.pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Cámara"),
              onTap: () {
                Navigator.pop(context);
                vm.pickImageFromCamera();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OvalBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height * 0.75);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
