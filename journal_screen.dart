import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class JournalScreen extends StatefulWidget {
  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  List<Map<String, String>> entries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEntries = prefs.getString('entries');

    if (savedEntries != null) {
      setState(() {
        entries = List<Map<String, String>>.from(
          jsonDecode(savedEntries).map((entry) => Map<String, String>.from(entry)),
        );
      });
    }
  }

  Future<void> _deleteEntry(int index) async {
    setState(() {
      entries.removeAt(index);
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('entries', jsonEncode(entries));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Запись удалена')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Журнал'),
      ),
      body: entries.isEmpty
          ? Center(
              child: Text(
                'Журнал пока пуст.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return Card(
                  child: ListTile(
                    leading: Text(
                      entry['mood']!,
                      style: TextStyle(fontSize: 32),
                    ),
                    title: Text(entry['note']!),
                    subtitle: Text(entry['date']!),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteEntry(index);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
