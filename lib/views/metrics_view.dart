import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import '../viewmodels/metrics_viewmodel.dart';

class MetricsView extends StatefulWidget {
  const MetricsView({super.key});

  @override
  State<MetricsView> createState() => _MetricsViewState();
}

class _MetricsViewState extends State<MetricsView> {
  late MetricsViewModel _metricsViewModel;
  late Future<void> _fetchFuture;

  @override
  void initState() {
    super.initState();
    _metricsViewModel = MetricsViewModel();
    _fetchFuture = _metricsViewModel.fetchAverages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Métricas Promedio'),
        backgroundColor: const Color(0xFF004D3D),
      ),
      body: FutureBuilder<void>(
        future: _fetchFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_metricsViewModel.error != null) {
            return Center(child: Text(_metricsViewModel.error!));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: PieChart(
              dataMap: _metricsViewModel.dataMap,
              chartType: ChartType.disc,
              chartRadius: MediaQuery.of(context).size.width / 2.2,
              legendOptions: const LegendOptions(
                showLegendsInRow: false,
                legendPosition: LegendPosition.bottom,
              ),
              chartValuesOptions: const ChartValuesOptions(
                showChartValuesInPercentage: true,
                showChartValuesOutside: false,
              ),
            ),
          );
        },
      ),
    );
  }
}
