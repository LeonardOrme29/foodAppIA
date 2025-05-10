import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final String? iconAsset;
  final VoidCallback onPressed;

  const LoginButton({
    super.key,
    required this.text,
    this.icon,
    this.iconAsset,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: iconAsset != null
            ? Image.asset(iconAsset!, height: 24)
            : Icon(icon, color: Colors.black),
        label: Text(text, style: const TextStyle(color: Colors.black)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
