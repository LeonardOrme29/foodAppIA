import 'package:flutter/material.dart';
import '../services/user_preferences.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Encabezado del Drawer
          const DrawerHeader(
            decoration: BoxDecoration(color:Color(0xFF004D3D)),
            child: Text(
              'Menú Principal',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),

          // Items estáticos
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.pop(context); // Cierra el drawer
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.troubleshoot),
            title: const Text('Identificar'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/scan');
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Historial'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/history');
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Metricas'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/metrics');
            },
          ),
          const Divider(), // Separador
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar Sesión'),
            onTap: () async {
              Navigator.pop(context); // Cierra el drawer
              await clearUser(); // ✅ Limpia el SharedPreferences
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/', // Puedes redirigir a login si prefieres
                    (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}