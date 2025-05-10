import 'package:flutter/material.dart';
import 'package:food_app/viewmodels/home_viewmodel.dart';
import 'package:food_app/viewmodels/register_viewmodel.dart';
import 'package:food_app/views/home_view.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';
import '../widgets/login_button.dart';
import '../views/register_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LoginViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF01402E),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo y título
            Column(
              children: [
                Image.asset('lib/assets/logo.png', height: 120),
                const SizedBox(height: 10),
                const Text('NutriScan', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
            const SizedBox(height: 40),

            // Botones de login
            LoginButton(
              text: 'Conectar con facebook',
              icon: Icons.facebook,
              onPressed: vm.loginWithFacebook,
            ),
            const SizedBox(height: 10),
            LoginButton(
              text: 'Conectar con Google',
              iconAsset: 'lib/assets/google-icon.png',
              onPressed: vm.loginWithGoogle,
            ),
            const SizedBox(height: 10),
            LoginButton(
              text: 'Conectar con correo',
              icon: Icons.email,
              //onPressed: vm.loginWithEmail,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (_) => HomeViewModel(),
                      child: HomeView(),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Expanded(child: Divider(color: Colors.white60, thickness: 1, indent: 20, endIndent: 10)),
                Text("o", style: TextStyle(color: Colors.white)),
                Expanded(child: Divider(color: Colors.white60, thickness: 1, indent: 10, endIndent: 20)),
              ],
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (_) => RegisterViewmodel(),
                      child: RegisterView(),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Crear cuenta', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),

            if (vm.user != null)
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  'Sesión iniciada como: ${vm.user!.name}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
