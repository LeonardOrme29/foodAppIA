import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  final String message;
  final VoidCallback onConfirm;

  const SuccessDialog({
    required this.message,
    required this.onConfirm,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      title: Row(
        children: [
          Icon(Icons.check_circle, color: Color(0xFF01402E)),
          SizedBox(width: 10),
          Text('¡Éxito!', style: TextStyle(color: Color(0xFF01402E))),
        ],
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: onConfirm,
          child: Text('Aceptar', style: TextStyle(color: Color(0xFF01402E))),
        ),
      ],
    );
  }
}
