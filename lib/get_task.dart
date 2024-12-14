import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetTaskPage extends StatefulWidget {
  @override
  _GetTaskPageState createState() => _GetTaskPageState();
}

class _GetTaskPageState extends State<GetTaskPage> {
  String taskTitle = 'Loading...';
  String taskDescription = 'Loading...';
  String dueDate = 'Loading...';

  Future<void> _fetchTaskData() async {
    final String apiUrl = 'http://206.189.138.45:7152/get-task';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          taskTitle = data['taskTitle'] ?? 'No Title';
          taskDescription = data['taskDescription'] ?? 'No Description';
          dueDate = data['dueDate'] ?? 'No Due Date';
        });
      } else {
        throw Exception('Failed to load task data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching task data: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTaskData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Get Task',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF608BC1),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Task Title:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              taskTitle,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Task Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              taskDescription,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Due Date:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              dueDate,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchTaskData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF608BC1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Fetch More Details',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
