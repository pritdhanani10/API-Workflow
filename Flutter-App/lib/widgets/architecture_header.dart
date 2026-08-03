import 'package:flutter/material.dart';

class ArchitectureHeader extends StatelessWidget {
  const ArchitectureHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1E293B),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNodeCard('Flutter App', Icons.phone_android, const Color(0xFF02569B)),
            _buildConnector('HTTP Request'),
            _buildNodeCard('Internet (REST API)', Icons.language, const Color(0xFF0284C7)),
            _buildConnector('JSON'),
            _buildNodeCard('.NET Web API', Icons.code, const Color(0xFF512BD4)),
            _buildConnector('Repository/EF Core'),
            _buildNodeCard('MySQL Database', Icons.storage, const Color(0xFF00758F)),
          ],
        ),
      ),
    );
  }

  Widget _buildNodeCard(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnector(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        children: [
          const Icon(Icons.arrow_forward, size: 14, color: Color(0xFF94A3B8)),
          Text(
            label,
            style: const TextStyle(fontSize: 9, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}
