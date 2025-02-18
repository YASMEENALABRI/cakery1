import 'package:flutter/material.dart';

class ReportModulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Annual Report Button
            _buildReportButton(
              context,
              title: 'Annual Report',
              description: 'Summarizes financial performance, operations, and achievements over the past year.',
              onPressed: () {
                // Navigate to Annual Report page
              },
            ),
            SizedBox(height: 20.0),

            // Monthly Report Button
            _buildReportButton(
              context,
              title: 'Monthly Report',
              description: 'Summarizes financial performance, operations, and achievements over the past month.',
              onPressed: () {
                // Navigate to Monthly Report page
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportButton(BuildContext context, {required String title, required String description, required VoidCallback onPressed}) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                description,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}