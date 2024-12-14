import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://206.189.138.45:7152';

  // Example: GET request to fetch all tasks
  Future<List<dynamic>> getAllTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/get_all_task'));

    if (response.statusCode == 200) {
      // Parse the JSON data
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  // POST request to register a user
  Future<void> registerUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register_user'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to register user');
    }
  }

  // POST request to activate a user
  Future<void> activateUser(Map<String, dynamic> activationData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/activate_user'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(activationData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to activate user');
    }
  }

  // POST request to login a user (added method)
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      // Assuming the response body contains a token or user data
      return json.decode(response.body); // Return user details or token
    } else {
      throw Exception('Failed to login');
    }
  }

  // POST request to create a task
  Future<void> createTask(Map<String, dynamic> taskData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create_task'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(taskData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create task');
    }
  }

  // PUT request to update a task
  Future<void> updateTask(int taskId, Map<String, dynamic> taskData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/edit_profile/$taskId'),  // Correct endpoint for updating task
      headers: {'Content-Type': 'application/json'},
      body: json.encode(taskData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update task');
    }
  }

  // DELETE request to delete a task
  Future<void> deleteTask(int taskId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete_task/$taskId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }

  // GET request to fetch user details (added method)
  Future<Map<String, dynamic>> getUserDetails(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/get_user_details'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Return user details as a map
    } else {
      throw Exception('Failed to load user details');
    }
  }
}
