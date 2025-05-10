import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/register_viewmodel.dart';

class RegisterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RegisterViewmodel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Crear cuenta')),
      body: Form(
        key: vm.formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre'),
                onChanged: vm.setName,
                validator: (value) => value!.isEmpty ? 'Ingrese su nombre' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Correo'),
                onChanged: vm.setEmail,
                validator: (value) =>
                value!.contains('@') ? null : 'Correo inválido',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                onChanged: vm.setPassword,
                validator: (value) =>
                value!.length < 6 ? 'Mínimo 6 caracteres' : null,
              ),
              SizedBox(height: 20),
              vm.isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: vm.registerUser,
                child: Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
