import 'package:flutter/material.dart';
import 'package:food_app/widgets/custom_drawer.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home_viewmodel.dart';
import '../widgets/food_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const SizedBox(width: 10),
            const Text("NutriScan"),
            const Spacer(),
            CircleAvatar(
              backgroundImage: NetworkImage(
                'https://randomuser.me/api/portraits/women/44.jpg',
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF004D3D),
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Image.network(
                      'lib/assets/home-banner.png',
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Lógica aquí
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF004D3D),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(vertical: 16), // Sin padding horizontal fijo
                    elevation: 5,
                  ),
                  icon: const Icon(Icons.restaurant, color:Color(0xFFFFFFFF), size: 24,),
                  label: const Text("Identificar Plato", style: TextStyle(fontSize: 18, color:Color(0xFFFFFFFF))),
                ),
              ),

              const SizedBox(height: 24),

              const Text("Busquedas Destacadas", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SizedBox(
                height: 140,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: viewModel.featuredSearches.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 120,
                      child: FoodCard(item: viewModel.featuredSearches[index]),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                ),
              ),

              const SizedBox(height: 24),
              const Text("Mis Busquedas", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: viewModel.mySearches.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  return FoodCard(item: viewModel.mySearches[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
