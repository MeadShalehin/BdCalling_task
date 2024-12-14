import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;  // Import HTTP package (version 1.2.2)
import 'dart:convert';  // For encoding the data to JSON

class CreateTaskPage extends StatefulWidget {
  @override
  _CreateTaskPageState createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskDescriptionController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();

  // This will be triggered when the "Create Task" button is pressed
  Future<void> _createTask() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Prepare the data to send to the API
      final taskData = {
        'title': _taskTitleController.text,
        'description': _taskDescriptionController.text,
        'due_date': _dueDateController.text,
      };

      final String apiUrl = 'http://206.189.138.45:7152/create-task';  // Replace with your API URL

      try {
        // Make the API request
        final response = await http.post(
          Uri.parse(apiUrl),  // Correct usage with Uri.parse()
          headers: {'Content-Type': 'application/json'},
          body: json.encode(taskData),  // Encode the task data as JSON
        );

        if (response.statusCode == 200) {
          // If the request is successful, show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Task Created Successfully')),
          );
          // Optionally, you can navigate to another page or reset the form
        } else {
          // If the request failed, show an error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create task')),
          );
        }
      } catch (e) {
        // Handle any errors that occur during the API request
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _taskTitleController.dispose();
    _taskDescriptionController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Task',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Make the text bold
          ),
        ),
        backgroundColor: Color(0xFF608BC1),
        centerTitle: true, // Use the same color as Dashboard button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Task Title Field
              TextFormField(
                controller: _taskTitleController,
                decoration: InputDecoration(
                  labelText: 'Task Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Task Description Field
              TextFormField(
                controller: _taskDescriptionController,
                decoration: InputDecoration(
                  labelText: 'Task Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4, // Allow multiple lines for description
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Due Date Field
              TextFormField(
                controller: _dueDateController,
                decoration: InputDecoration(
                  labelText: 'Due Date',
                  hintText: 'Enter date (MM/DD/YYYY)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a due date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),

              // Create Task Button
              ElevatedButton(
                onPressed: _createTask, // Trigger the API call to create task
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE5E3D4), // Button color same as Dashboard
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Create Task',
                  style: TextStyle(
                    color: Colors.black, // Button text color
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
