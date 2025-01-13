import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedMood; // Выбранное настроение
  TextEditingController noteController = TextEditingController(); // Контроллер для заметок

  // Метод для сохранения настроения и заметки
  Future<void> saveMood() async {
    if (selectedMood == null || noteController.text.isEmpty) {
      // Сообщение об ошибке
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пожалуйста, выберите настроение и введите заметку')),
      );
      return;
    }

    // Создаём новую запись
    Map<String, String> newEntry = {
      'mood': selectedMood!,
      'note': noteController.text,
      'date': DateTime.now().toString(),
    };

    // Сохраняем записи в SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEntries = prefs.getString('entries');
    List<Map<String, String>> entries = savedEntries != null
        ? List<Map<String, String>>.from(
            jsonDecode(savedEntries).map((entry) => Map<String, String>.from(entry)),
          )
        : [];
    entries.add(newEntry);

    prefs.setString('entries', jsonEncode(entries));

    // Очищаем ввод и сбрасываем выбранное настроение
    setState(() {
      selectedMood = null;
      noteController.clear();
    });

    // Сообщение об успешном сохранении
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Настроение и заметка сохранены!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Главная'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок
            Text(
              'Как вы себя чувствуете?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            // Смайлики выбора настроения
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              runSpacing: 10,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedMood = '😊';
                    });
                  },
                  child: Text(
                    '😊',
                    style: TextStyle(
                      fontSize: 48,
                      color: selectedMood == '😊' ? Colors.blue : Colors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedMood = '😐';
                    });
                  },
                  child: Text(
                    '😐',
                    style: TextStyle(
                      fontSize: 48,
                      color: selectedMood == '😐' ? Colors.blue : Colors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedMood = '😢';
                    });
                  },
                  child: Text(
                    '😢',
                    style: TextStyle(
                      fontSize: 48,
                      color: selectedMood == '😢' ? Colors.blue : Colors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedMood = '😂';
                    });
                  },
                  child: Text(
                    '😂',
                    style: TextStyle(
                      fontSize: 48,
                      color: selectedMood == '😂' ? Colors.blue : Colors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedMood = '😡';
                    });
                  },
                  child: Text(
                    '😡',
                    style: TextStyle(
                      fontSize: 48,
                      color: selectedMood == '😡' ? Colors.blue : Colors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedMood = '🥳';
                    });
                  },
                  child: Text(
                    '🥳',
                    style: TextStyle(
                      fontSize: 48,
                      color: selectedMood == '🥳' ? Colors.blue : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Поле ввода заметки
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Добавьте заметку',
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),

            // Кнопка для сохранения
            ElevatedButton(
              onPressed: saveMood,
              child: Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }
}
