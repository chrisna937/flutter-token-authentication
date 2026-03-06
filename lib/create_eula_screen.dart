import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:login_with_code_frontend/services/auth_service.dart';

class CreateEulaScreen extends StatefulWidget {
  const CreateEulaScreen({super.key});

  @override
  State<CreateEulaScreen> createState() => _CreateEulaScreenState();
}

class _CreateEulaScreenState extends State<CreateEulaScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _versionController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  bool _isActive = true;
  bool _isLoading = false;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  final String baseURL = "http://192.168.100.77:3000"; 


  //Fetch userid & email
  Future<int?> getUserId() async {
    final id = await _storage.read(key: 'userid');
    if (id ==  null) return null;
    return int.tryParse(id);
  }

  Future<String?> getUserEmail() async {
    return await _storage.read(key: 'email');
  }



  Future<void> _submitEula() async {
    debugPrint("=== _submitEula() called ===");

    if (!_formKey.currentState!.validate()) {
      debugPrint("Form validation failed. Aborting submission.");
    return;
    }
    
    // debugPrint("Form validation passed.");
    setState(() => _isLoading = true);
  
  try {
    //  debugPrint("Fetching userId from AuthService...");
     final userId = await AuthService.getUserId();
     final token = await AuthService.getToken();
    //  debugPrint("userId retrieved: $userId");

      if (userId == null || token == null) {
        throw Exception("User not logged in");
      }

    final now = DateTime.now().toIso8601String();
    // debugPrint("Timestamp (now): $now");
    
     final response = await http.post(
      Uri.parse("$baseURL/api/eula-version"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"    
        },
      body: jsonEncode({
        "version_code": _versionController.text.trim(),
        "content": _contentController.text.trim(),
        "is_active": _isActive,
        "released_at": now,
        "insertedby": userId,
        "deletedt": null,
        "deletedby": null,
        "updatedt": null,
        "updatedby": null,
        "row_delete_flag": false,
      }),
    );
    debugPrint("Request URL: $baseURL/eula-version");
    debugPrint("Request body: $response");

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint("EULA submitted successfully.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("EULA Version Published Successfully")),
      );

      _versionController.clear();
      _contentController.clear();
      setState(() => _isActive = true);
      debugPrint("Form cleared and _isActive reset to true");
    } else {
         debugPrint("Server returned an error. Status: ${response.statusCode}, Body: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${response.body}")),
      );
    }
  } catch (e, stackTrace) {
    debugPrint("EXCEPTION caught in _submitEula: $e");
    debugPrint("StackTrace: $stackTrace");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Connection Error: $e")),
    );
  } finally {
    debugPrint("Setting _isLoading to false.");

  setState(() => _isLoading = false);
  }
  }
  // Future<void> _submitEula() async {
  //   if (!_formKey.currentState!.validate()) return;

  //   setState(() => _isLoading = true);
  
  // try {
  //     final now = DateTime.now().toIso8601String();
  //     final userId =1; // Replace later with actual userid

  //   final response = await http.post(
  //     Uri.parse("$baseURL/eula-version").replace(
  //       queryParameters: {'user': userId.toString()},
  //     ),
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode({
  //       "version_code": _versionController.text.trim(),
  //       "content": _contentController.text.trim(),
  //       "is_active": _isActive,
  //       "insertdt": now,
  //       "insertedby": userId,
  //       "deletedt": null,
  //       "deletedby": null,
  //       "updatedt": null,
  //       "updatedby": null,
  //       "row_delete_flag": false,
  //     }),
  //   );

  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("EULA Version Published Successfully")),
  //     );

  //     _versionController.clear();
  //     _contentController.clear();
  //     setState(() => _isActive = true);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Error: ${response.body}")),
  //     );
  //   }
  // } catch (e) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text("Connection Error: $e")),
  //   );
  // }

  // setState(() => _isLoading = false);
  // }


  @override
  void dispose() {
    _versionController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create EULA Version"
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsGeometry.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              //Version Code
              TextFormField(
                controller: _versionController,
                decoration: const InputDecoration(
                  labelText: "Version Code",
                  hintText: "e.g. v1.0 or 2026.03",
                  border: OutlineInputBorder(),
               ),
               validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Version code is required";
                }
                return null;
               },
              ),

              const SizedBox(height: 16),

              //Content
              Expanded(
                child: TextFormField(
                  controller: _contentController,
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    labelText: "EULA Content",
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Content is required";
                    }
                    return null;
                  },
                ),
                ),

                const SizedBox(height: 16),

                //Active Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Make Active", 
                    style: TextStyle(fontSize: 16),
                    ),
                   Switch(
                    value: _isActive, 
                    onChanged: (value) {
                      setState(() => _isActive = value);
                    },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                //Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitEula, 
                    child: _isLoading
                    ? const CircularProgressIndicator(
                      color: Colors.white,
                    ) 
                    : const Text("Publish Version"),
                    ),
                ),
            ],
          ),
          ),
        ),
    );
  }
}