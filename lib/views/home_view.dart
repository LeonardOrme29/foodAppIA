import 'package:flutter/material.dart';
import 'package:food_app/widgets/custom_drawer.dart';
import '../models/user_model.dart';
import '../services/user_preferences.dart';
import '../viewmodels/home_viewmodel.dart';
import '../widgets/food_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<UserModel?> _userFuture;
  late HomeViewModel _homeViewModel;
  late Future<void> _searchesFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = loadUser();
    _homeViewModel = HomeViewModel();
    _searchesFuture = _homeViewModel.loadSearches(); // ⚠️ se ejecuta de una vez
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (user == null) {
          return const Scaffold(
            body: Center(child: Text("No hay usuario logueado")),
          );
        }

        return FutureBuilder(
          future: _searchesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            return Scaffold(
              appBar: AppBar(
                title: Row(
                  children: [
                    const SizedBox(width: 10),
                    const Text("NutriScan"),
                    const Spacer(),
                    const CircleAvatar(
                      backgroundImage: AssetImage('lib/assets/user.jpg'),
                    ),
                  ],
                ),
                backgroundColor: const Color(0xFF004D3D),
              ),
              drawer: const CustomDrawer(),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'lib/assets/home-banner.png',
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/scan');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF004D3D),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 5,
                          ),
                          icon: const Icon(Icons.restaurant, color: Colors.white, size: 24),
                          label: Text(
                            'Identificar Plato para ${user.firstname}',
                            style: const TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text("Búsquedas Destacadas", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 160,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemCount: _homeViewModel.featuredSearches.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: 120,
                              child: FoodCard(item: _homeViewModel.featuredSearches[index]),
                            );
                          },
                          separatorBuilder: (_, __) => const SizedBox(width: 10),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text("Mis Búsquedas", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _homeViewModel.mySearches.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemBuilder: (context, index) {
                          return FoodCard(item: _homeViewModel.mySearches[index]);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
