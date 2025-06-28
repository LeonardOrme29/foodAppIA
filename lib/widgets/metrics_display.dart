import 'package:flutter/material.dart';

class MetricsDisplay extends StatelessWidget {
  final String precision;
  final double carbs;
  final double proteins;
  final double fats;

  const MetricsDisplay({
    Key? key,
    required this.precision,
    required this.carbs,
    required this.proteins,
    required this.fats,
  }) : super(key: key);

  // Función para determinar el color de precisión
  Color _getPrecisionColor(double precision) {
    if (precision >= 67) {
      return Colors.lightGreen; // Verde para 67-100
    } else if (precision >= 34) {
      return Colors.amber; // Amarillo para 34-66
    } else {
      return Colors.red; // Rojo para 0-33
    }
  }

  // Función para determinar el color del texto de precisión
  Color _getPrecisionTextColor(double precision) {
    // Si el fondo es amarillo, el texto negro se ve mejor.
    // Para verde y rojo, el blanco es generalmente bueno.
    if (precision >= 34 && precision <= 66) { // Si es amarillo
      return Colors.black87;
    } else {
      return Colors.white;
    }
  }


  @override
  Widget build(BuildContext context) {
    double dpresicion = double.parse(precision);
    final Color precisionBackgroundColor = _getPrecisionColor(dpresicion);
    final Color precisionTextColor = _getPrecisionTextColor(dpresicion);


    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        StatCard(
          label: 'Precision',
          value: '${dpresicion.toStringAsFixed(0)}%',
          backgroundColor: precisionBackgroundColor, // Color dinámico
          textColor: precisionTextColor, // Color de texto dinámico
        ),
        StatCard(
          label: 'Carbohidratos',
          value: '${carbs.toStringAsFixed(0)}%',
          backgroundColor: Colors.grey[300]!,
          textColor: Colors.black87,
        ),
        StatCard(
          label: 'Proteinas',
          value: '${proteins.toStringAsFixed(0)}%',
          backgroundColor: Colors.grey[300]!,
          textColor: Colors.black87,
        ),
        StatCard(
          label: 'Grasas',
          value: '${fats.toStringAsFixed(0)}%',
          backgroundColor: Colors.grey[300]!,
          textColor: Colors.black87,
        ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color backgroundColor;
  final Color textColor;

  const StatCard({
    Key? key,
    required this.label,
    required this.value,
    required this.backgroundColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Hemos eliminado la lógica de color condicional de aquí,
    // ya que ahora se pasa directamente desde MetricsDisplay
    return Container(
      width: MediaQuery.of(context).size.width / 4 - 20,
      height: 90,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}