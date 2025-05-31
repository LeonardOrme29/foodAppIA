import 'package:flutter/material.dart';
import 'package:food_app/viewmodels/home_viewmodel.dart';
import 'package:food_app/views/dish_details_view.dart';
import 'package:food_app/views/home_view.dart';
import 'package:food_app/views/login_mail_view.dart';
import 'package:food_app/views/scan_food_view.dart';
import 'package:provider/provider.dart';
import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/register_viewmodel.dart';
import 'viewmodels/scan_food_viewmodel.dart';
import 'views/login_view.dart';
import 'views/register_view.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) {
        final vm = LoginViewModel();
        vm.loadUserFromPreferences();  // Carga usuario guardado al iniciar
        return vm;
      },
      child: NutriScanApp(),
    ),
  );
}

class NutriScanApp extends StatelessWidget {
  const NutriScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewmodel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => ScanFoodViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => LoginView(),
          '/login': (context) => LoginMailView(),
          '/register': (context) => RegisterView(),
          '/home': (context) => HomeView(),
          '/scan': (context) => ScanFoodView(),
          //'/food': (context) => DishDetailsView(item: item),
        },
      ),
    );
  }
}

