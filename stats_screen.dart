import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  Map<String, int> moodCounts = {
    '😊': 0,
    '😐': 0,
    '😢': 0,
    '😂': 0,
    '😡': 0,
    '🥳': 0,
  };

  @override
  void initState() {
    super.initState();
    _calculateStats();
  }

  Future<void> _calculateStats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEntries = prefs.getString('entries');

    if (savedEntries != null) {
      List<Map<String, String>> entries = List<Map<String, String>>.from(
        jsonDecode(savedEntries).map((entry) => Map<String, String>.from(entry)),
      );

      Map<String, int> counts = {
        '😊': 0,
        '😐': 0,
        '😢': 0,
        '😂': 0,
        '😡': 0,
        '🥳': 0,
      };

      for (var entry in entries) {
        counts[entry['mood']!] = (counts[entry['mood']!] ?? 0) + 1;
      }

      setState(() {
        moodCounts = counts;
      });
    }
  }

  Color _getColorForMood(String mood) {
    switch (mood) {
      case '😊':
        return Colors.green;
      case '😐':
        return Colors.yellow;
      case '😢':
        return Colors.blue;
      case '😂':
        return Colors.purple;
      case '😡':
        return Colors.red;
      case '🥳':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  List<PieChartSectionData> _generateChartData() {
    final List<PieChartSectionData> sections = [];
    moodCounts.forEach((mood, count) {
      if (count > 0) {
        sections.add(
          PieChartSectionData(
            color: _getColorForMood(mood),
            value: count.toDouble(),
            title: '$mood\n$count',
            radius: 50,
            titleStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
      }
    });
    return sections;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Статистика'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Диаграмма настроений',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: _generateChartData(),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
