import 'package:flutter/material.dart';
import '../viewmodels/history_viewmodel.dart';
import '../widgets/food_card.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  late HistoryViewModel _historyViewModel;
  late Future<void> _loadFuture;

  @override
  void initState() {
    super.initState();
    _historyViewModel = HistoryViewModel();
    _loadFuture = _historyViewModel.loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Predicciones'),
        backgroundColor: const Color(0xFF004D3D),
      ),
      body: FutureBuilder<void>(
        future: _loadFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_historyViewModel.history.isEmpty) {
            return const Center(
              child: Text(
                'No hay predicciones registradas.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              itemCount: _historyViewModel.history.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.8,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                return FoodCard(item: _historyViewModel.history[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
