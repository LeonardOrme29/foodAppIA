import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';
import '../widgets/success_dialog.dart';
import '../services/user_preferences.dart'; // 👈 Asegúrate de que esté bien la ruta
import '../models/user_model.dart'; // 👈 Si no lo tienes ya

class LoginMailView extends StatelessWidget {
  const LoginMailView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LoginViewModel>(context);
    final inputDecoration = (String label) => InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: const Color(0xFF015C41),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white38),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF01402E),
      appBar: AppBar(
        title: const Text('Login', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF01402E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Column(
                children: [
                  Image.asset('lib/assets/logo.png', height: 200),
                  const SizedBox(height: 20),
                ],
              ),
              TextFormField(
                decoration: inputDecoration('Correo'),
                style: const TextStyle(color: Colors.white),
                onChanged: vm.setEmail,
              ),
              const SizedBox(height: 15),
              TextFormField(
                decoration: inputDecoration('Contraseña'),
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                onChanged: vm.setPassword,
              ),
              const SizedBox(height: 20),

              // Mostrar errores si hay
              if (vm.errorMessage.isNotEmpty)
                Text(
                  vm.errorMessage,
                  style: const TextStyle(color: Colors.redAccent),
                ),

              const SizedBox(height: 10),

              // Botón de login
              vm.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : ElevatedButton(
                onPressed: () async {
                  final success = await vm.loginUser();
                  if (success && vm.user != null) {
                    // 👇 Guardar el usuario antes de ir al home
                    await saveUser(vm.user!);

                    // Mostrar diálogo de bienvenida
                    showDialog(
                      context: context,
                      builder: (context) => SuccessDialog(
                        message: '¡Bienvenido ${vm.user!.firstname}!',
                        onConfirm: () {
                          Navigator.of(context).pop();
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                ),
                child: const Text('Iniciar sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
