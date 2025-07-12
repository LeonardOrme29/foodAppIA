import 'package:flutter/material.dart';
import 'package:food_app/viewmodels/history_viewmodel.dart';
import 'package:food_app/viewmodels/home_viewmodel.dart';
import 'package:food_app/viewmodels/login_viewmodel.dart';
import 'package:food_app/viewmodels/metrics_viewmodel.dart';
import 'package:food_app/viewmodels/register_viewmodel.dart';
import 'package:food_app/viewmodels/scan_food_viewmodel.dart';
import 'package:food_app/views/dish_details_view.dart';
import 'package:food_app/views/history_view.dart';
import 'package:food_app/views/home_view.dart';
import 'package:food_app/views/login_mail_view.dart';
import 'package:food_app/views/login_view.dart';
import 'package:food_app/views/metrics_view.dart';
import 'package:food_app/views/register_view.dart';
import 'package:food_app/views/scan_food_view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(NutriScanApp());
}

class NutriScanApp extends StatelessWidget {
  const NutriScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginViewModel>(
          create: (context) {
            final vm = LoginViewModel();
            vm.loadUserFromPreferences(); // ✅ Se llama una vez al iniciar
            return vm;
          },
        ),
        ChangeNotifierProvider(create: (_) => RegisterViewmodel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => ScanFoodViewModel()),
        //ChangeNotifierProvider(create: (_) => HistoryViewModel()),
        //ChangeNotifierProvider(create: (_) => MetricsViewModel()),
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
          '/history': (context) => const HistoryView(),
          '/metrics': (context) => const MetricsView()
          //'/food': (context) => DishDetailsView(item: item),
        },
      ),
    );
  }
}
