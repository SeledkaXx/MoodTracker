import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Map<String, String>> entries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  // Загрузка записей из SharedPreferences
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

  // Сохранение записей в SharedPreferences
  Future<void> _saveEntries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('entries', jsonEncode(entries));
  }

  // Открытие модального окна для редактирования записи
  void _editEntry(BuildContext context, String dateKey) {
    // Найти запись по дате или создать новую
    Map<String, String> entryToEdit = entries.firstWhere(
      (entry) => entry['date']?.split('T')[0] == dateKey,
      orElse: () => {'mood': '😊', 'note': '', 'date': dateKey},
    );

    String initialMood = entryToEdit['mood']!;
    TextEditingController noteController = TextEditingController(
      text: entryToEdit['note'] ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter modalSetState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Редактировать запись',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                // Выбор смайлика
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  children: [
                    GestureDetector(
                      onTap: () {
                        modalSetState(() {
                          initialMood = '😊';
                        });
                      },
                      child: Text(
                        '😊',
                        style: TextStyle(
                          fontSize: 32,
                          color: initialMood == '😊' ? Colors.blue : Colors.black,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        modalSetState(() {
                          initialMood = '😐';
                        });
                      },
                      child: Text(
                        '😐',
                        style: TextStyle(
                          fontSize: 32,
                          color: initialMood == '😐' ? Colors.blue : Colors.black,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        modalSetState(() {
                          initialMood = '😢';
                        });
                      },
                      child: Text(
                        '😢',
                        style: TextStyle(
                          fontSize: 32,
                          color: initialMood == '😢' ? Colors.blue : Colors.black,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        modalSetState(() {
                          initialMood = '😂';
                        });
                      },
                      child: Text(
                        '😂',
                        style: TextStyle(
                          fontSize: 32,
                          color: initialMood == '😂' ? Colors.blue : Colors.black,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        modalSetState(() {
                          initialMood = '😡';
                        });
                      },
                      child: Text(
                        '😡',
                        style: TextStyle(
                          fontSize: 32,
                          color: initialMood == '😡' ? Colors.blue : Colors.black,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        modalSetState(() {
                          initialMood = '🥳';
                        });
                      },
                      child: Text(
                        '🥳',
                        style: TextStyle(
                          fontSize: 32,
                          color: initialMood == '🥳' ? Colors.blue : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // Поле для заметки
                TextField(
                  controller: noteController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Заметка',
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // Обновить запись или добавить новую
                      if (entries.contains(entryToEdit)) {
                        entryToEdit['mood'] = initialMood;
                        entryToEdit['note'] = noteController.text;
                      } else {
                        entries.add({
                          'mood': initialMood,
                          'note': noteController.text,
                          'date': dateKey,
                        });
                      }
                    });
                    _saveEntries();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Запись обновлена!')),
                    );
                  },
                  child: Text('Сохранить'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Календарь'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });

              String dateKey = selectedDay.toIso8601String().split('T')[0];
              _editEntry(context, dateKey);
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(height: 20),
          _selectedDay != null
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Выбрана дата: ${_selectedDay!.toIso8601String().split('T')[0]}',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Выберите дату, чтобы добавить или редактировать запись.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
        ],
      ),
    );
  }
}
