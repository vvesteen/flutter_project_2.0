import 'package:flutter/material.dart';

class VerificationTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool verified;

  const VerificationTile({
    super.key,
    required this.icon,
    required this.label,
    required this.verified,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: verified ? Colors.green : Colors.grey.shade500,
      ),
      title: Text(label),
      trailing: Icon(
        verified ? Icons.check_circle_rounded : Icons.cancel_rounded,
        color: verified ? Colors.green : Colors.red.shade400,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }
}