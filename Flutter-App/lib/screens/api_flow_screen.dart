import 'package:flutter/material.dart';
import '../models/api_log.dart';
import '../services/api_service.dart';

class ApiFlowScreen extends StatelessWidget {
  final ApiService apiService;
  final VoidCallback onClearLogs;

  const ApiFlowScreen({
    super.key,
    required this.apiService,
    required this.onClearLogs,
  });

  @override
  Widget build(BuildContext context) {
    final logs = apiService.logs;

    if (logs.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.compare_arrows, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No API telemetry captured yet.\nPerform CRUD operations (GET, POST, PUT, DELETE) on Students to visualize the live request/response flow.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: const Color(0xFF0F172A),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Live Network Telemetry (${logs.length} Requests)',
                style: const TextStyle(
                    color: Colors.white70, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: onClearLogs,
                icon: const Icon(Icons.delete_sweep, size: 18, color: Colors.grey),
                label: const Text('Clear Logs', style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              return _buildLogCard(context, log);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLogCard(BuildContext context, ApiLog log) {
    Color methodColor;
    switch (log.method) {
      case 'GET':
        methodColor = const Color(0xFF3B82F6);
        break;
      case 'POST':
        methodColor = const Color(0xFF10B981);
        break;
      case 'PUT':
        methodColor = const Color(0xFFF59E0B);
        break;
      case 'DELETE':
        methodColor = const Color(0xFFEF4444);
        break;
      default:
        methodColor = Colors.purple;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: methodColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: methodColor),
          ),
          child: Text(
            log.method,
            style: TextStyle(
              color: methodColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        title: Text(
          log.url,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: log.isSuccess
                    ? Colors.green.withValues(alpha: 0.2)
                    : Colors.red.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Status: ${log.statusCode}',
                style: TextStyle(
                  color: log.isSuccess ? Colors.greenAccent : Colors.redAccent,
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Latency: ${log.durationMs}ms',
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF0F172A),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLogSectionHeader('1. Flutter Mobile App Request'),
                _buildCodeSnippet('Headers', log.requestHeaders.toString()),
                if (log.requestBody != null)
                  _buildCodeSnippet('JSON Body Payload', log.requestBody!),
                const SizedBox(height: 8),
                _buildLogSectionHeader('2. ASP.NET Core & MySQL Backend Flow'),
                if (log.sqlExecuted != null)
                  _buildCodeSnippet(
                      'SQL Executed in MySQL', log.sqlExecuted!,
                      highlightColor: const Color(0xFF38BDF8))
                else
                  const Text('Database Operation: EF Core DbContext query',
                      style: TextStyle(color: Colors.grey, fontSize: 11)),
                const SizedBox(height: 8),
                _buildLogSectionHeader('3. HTTP Response Received by Flutter'),
                _buildCodeSnippet('Response Headers', log.responseHeaders.toString()),
                _buildCodeSnippet('Response Body (JSON)', log.responseBody),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF06B6D4),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildCodeSnippet(String label, String content, {Color? highlightColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label:',
              style: const TextStyle(color: Colors.grey, fontSize: 11)),
          const SizedBox(height: 2),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: SelectableText(
              content,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: highlightColor ?? const Color(0xFFE2E8F0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
