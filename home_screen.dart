import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdf_text/pdf_text.dart';
import 'package:hive/hive.dart';
import 'stats_screen.dart';
import 'h2h_screen.dart';

class HomeScreen extends StatelessWidget {
  Future<void> _pickAndParsePDF(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      final doc = await PDFDocument.fromFile(File(path));
      final text = await doc.text;
      _parsePDFContent(text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("PDF parsed and data stored successfully!")),
      );
    }
  }

  void _parsePDFContent(String text) {
    final lines = text.split('\n');
    final box = Hive.box('player_stats');

    for (var line in lines) {
      final match = RegExp(r"(\w+)\s+(\d+)\((\d+)\).*b\.\s*(\w+)").firstMatch(line);
      if (match != null) {
        final batsman = match.group(1)!;
        final runs = int.parse(match.group(2)!);
        final balls = int.parse(match.group(3)!);
        final bowler = match.group(4)!;

        final key = '\$batsman-vs-\$bowler';
        final existing = box.get(key, defaultValue: {'runs': 0, 'balls': 0, 'outs': 0});
        existing['runs'] += runs;
        existing['balls'] += balls;
        existing['outs'] += 1;
        box.put(key, existing);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gully Cricket Stats')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _pickAndParsePDF(context),
              child: Text("Upload Scorecard PDF"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => StatsScreen()),
              ),
              child: Text("Show All Player Stats"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => H2HScreen()),
              ),
              child: Text("Head-to-Head Comparison"),
            ),
          ],
        ),
      ),
    );
  }
}