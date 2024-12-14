import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeleteTaskPage extends StatefulWidget {
  @override
  _DeleteTaskPageState createState() => _DeleteTaskPageState();
}

class _DeleteTaskPageState extends State<DeleteTaskPage> {
  final TextEditingController _taskIdController = TextEditingController();
  bool _isTaskDeleted = false;

  Future<void> _deleteTask() async {
    final taskId = _taskIdController.text;

    if (taskId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a Task ID')),
      );
      return;
    }

    final String apiUrl = 'http://206.189.138.45:7152/delete-task/$taskId';

    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          _isTaskDeleted = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task Deleted Successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete task')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void dispose() {
    _taskIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Task',
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
              'Enter Task ID to Delete:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _taskIdController,
              decoration: InputDecoration(
                labelText: 'Task ID',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _deleteTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFC75B7A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Delete Task',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            if (_isTaskDeleted)
              Text(
                'The task has been successfully deleted.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
