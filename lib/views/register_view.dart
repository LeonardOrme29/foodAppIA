import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/register_viewmodel.dart';
import '../widgets/success_dialog.dart';

class RegisterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RegisterViewmodel>(context);

    final inputDecoration = (String label) => InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Color(0xFF015C41), // verde más claro
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white38),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF01402E),
      appBar: AppBar(
        title: Text('Crear cuenta', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF01402E),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: vm.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Column(
                children: [
                  Image.asset('lib/assets/logo.png', height: 200),
                  SizedBox(height: 20),
                ],
              ),
              TextFormField(
                decoration: inputDecoration('Nombres'),
                style: TextStyle(color: Colors.white),
                onChanged: vm.setFirstName,
                validator: (value) =>
                value!.isEmpty ? 'Ingrese su Nombre' : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: inputDecoration('Apellidos'),
                style: TextStyle(color: Colors.white),
                onChanged: vm.setLastName,
                validator: (value) =>
                value!.isEmpty ? 'Ingrese sus Apellidos' : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: inputDecoration('Correo'),
                style: TextStyle(color: Colors.white),
                onChanged: vm.setEmail,
                validator: (value) =>
                value!.contains('@') ? null : 'Correo inválido',
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: inputDecoration('Contraseña'),
                obscureText: true,
                style: TextStyle(color: Colors.white),
                onChanged: vm.setPassword,
                validator: (value) =>
                value!.length < 6 ? 'Mínimo 6 caracteres' : null,
              ),
              SizedBox(height: 20),
              if (vm.errorMessage.isNotEmpty)
                Text(
                  vm.errorMessage,
                  style: TextStyle(color: Colors.redAccent),
                ),
              SizedBox(height: 10),
              vm.isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : ElevatedButton(
                onPressed: () async {
                  final success = await vm.registerUser();
                  if (success) {
                    showDialog(
                      context: context,
                      builder: (context) => SuccessDialog(
                        message: 'Usuario registrado con éxito',
                        onConfirm: () {
                          Navigator.of(context).pop(); // Cierra el diálogo
                          Navigator.pushReplacementNamed(context, '/login'); // Va a login
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
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                ),
                child: Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
