import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class StatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final box = Hive.box('player_stats');
    final entries = box.keys.map((key) => MapEntry(key, box.get(key))).toList();

    return Scaffold(
      appBar: AppBar(title: Text("All Player Stats")),
      body: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          return ListTile(
            title: Text(entry.key),
            subtitle: Text("Runs: \${entry.value['runs']}, Balls: \${entry.value['balls']}, Outs: \${entry.value['outs']}"),
          );
        },
      ),
    );
  }
}