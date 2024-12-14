import 'package:flutter/material.dart';
import 'api_service.dart';

class GetAllTaskPage extends StatefulWidget {
  @override
  _GetAllTaskPageState createState() => _GetAllTaskPageState();
}

class _GetAllTaskPageState extends State<GetAllTaskPage> {
  List<String> tasks = [];

  Future<void> _fetchTasks() async {
    try {
      final response = await ApiService().getAllTasks();

      setState(() {
        tasks = response.map<String>((task) {
          if (task is Map<String, dynamic>) {
            return task['taskTitle'] ?? task['title'] ?? 'No Title';
          } else {
            return 'No Title';
          }
        }).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching tasks: $e')),
      );
    }
  }

  void _deleteTask(int taskId, int index) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Keep'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await ApiService().deleteTask(taskId);
                  setState(() {
                    tasks.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Task deleted successfully!')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting task: $e')),
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Get All Tasks',
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
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        tasks[index],
                        style: TextStyle(fontSize: 16),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () => _deleteTask(index, index),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFC75B7A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          'Delete',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
