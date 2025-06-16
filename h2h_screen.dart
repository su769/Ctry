import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class H2HScreen extends StatefulWidget {
  @override
  _H2HScreenState createState() => _H2HScreenState();
}

class _H2HScreenState extends State<H2HScreen> {
  String playerA = '';
  String playerB = '';
  Map<String, dynamic>? data;

  void _compare() {
    final box = Hive.box('player_stats');
    final key = '\$playerA-vs-\$playerB';
    setState(() {
      data = box.get(key);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Head-to-Head Comparison")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: "Player A"),
              onChanged: (val) => playerA = val,
            ),
            TextField(
              decoration: InputDecoration(labelText: "Player B"),
              onChanged: (val) => playerB = val,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _compare,
              child: Text("Compare"),
            ),
            SizedBox(height: 20),
            if (data != null)
              Text("Runs: \${data!['runs']}, Balls: \${data!['balls']}, Outs: \${data!['outs']}",
                  style: TextStyle(fontSize: 16)),
            if (data == null)
              Text("No data found", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}