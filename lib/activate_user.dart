import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the HTTP package
import 'dart:convert'; // For encoding the data to JSON
import 'login_screen.dart'; // Import LoginScreen

class ActivateUserPage extends StatefulWidget {
  final String email; // Email passed from RegisterPage

  ActivateUserPage({required this.email}); // Constructor to accept the email

  @override
  _ActivateUserPageState createState() => _ActivateUserPageState();
}

class _ActivateUserPageState extends State<ActivateUserPage> {
  final _codeController = TextEditingController(); // Controller for the verification code
  late OverlayEntry _overlayEntry; // Entry for the overlay popup

  @override
  void initState() {
    super.initState();
    // Show the popup message when the page is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showPopupMessage();
    });
  }

  // Function to show the popup message from the top
  void _showPopupMessage() {
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50, // Adjust the position from the top
        left: 10,
        right: 10,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'A verification code has been sent to your email.',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    // Insert the overlay entry
    Overlay.of(context)?.insert(_overlayEntry);

    // Remove the overlay after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      _overlayEntry.remove();
    });
  }

  // Function to handle the verification logic
  Future<void> _verifyCode() async {
    String enteredCode = _codeController.text;
    if (enteredCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the verification code')),
      );
    } else {
      // API URL for verifying the code
      final String apiUrl = 'http://206.189.138.45:7152/verify-code';  // Replace with your API URL

      try {
        // Prepare the payload for the API request
        final Map<String, String> payload = {
          'email': widget.email,  // Send the email with the entered code
          'code': enteredCode,
        };

        // Send a POST request to verify the code
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(payload),
        );

        if (response.statusCode == 200) {
          // If the response is successful, show a success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification Successful!')),
          );
          // Navigate to Login Screen after successful verification
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        } else {
          // If the response is not successful, show an error message
          throw Exception('Verification failed. Please check your code.');
        }
      } catch (e) {
        // Handle any errors during the API call
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the left back arrow
        title: Text(
          "Activate User",
          style: TextStyle(
            fontWeight: FontWeight.bold, // Make text bold
            color: Colors.blue, // Set text color to blue
          ),
        ),
        centerTitle: true, // Center the title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Email Text Field (Pre-filled with the email from RegisterPage)
            TextFormField(
              initialValue: widget.email, // Display the email passed from RegisterPage
              decoration: InputDecoration(
                labelText: 'Email',
                enabled: false, // Make this field non-editable
              ),
            ),
            SizedBox(height: 20),
            // Verification Code Text Field
            TextFormField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: 'Verification Code',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: _verifyCode, // Trigger verification logic
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF167BD0), // Button color (#167BD0)
                minimumSize: const Size(50, 50), // Button size
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
              ),
              child: const Text(
                'Verify',
                style: TextStyle(
                  fontWeight: FontWeight.bold, // Bold text
                  color: Colors.white, // White text color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
