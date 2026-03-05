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


  //Fetch userid token & email
  Future<int?> getUserId() async {
    final id = await _storage.read(key: 'userid');
    if (id ==  null) return null;
    return int.tryParse(id);
  }

  Future<String?> getUserEmail() async {
    return await _storage.read(key: 'email');
  }



  Future<void> _submitEula() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
  
  try {
     
     final userId = await AuthService.getUserId();
      if (userId == null) {
        throw Exception("User not logged in");
      }

      final now = DateTime.now().toIso8601String();
    
     final response = await http.post(
      Uri.parse("$baseURL/eula-version"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "version_code": _versionController.text.trim(),
        "content": _contentController.text.trim(),
        "is_active": _isActive,
        "insertdt": now,
        "insertedby": userId,
        "deletedt": null,
        "deletedby": null,
        "updatedt": null,
        "updatedby": null,
        "row_delete_flag": false,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("EULA Version Published Successfully")),
      );

      _versionController.clear();
      _contentController.clear();
      setState(() => _isActive = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${response.body}")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Connection Error: $e")),
    );
  }

  setState(() => _isLoading = false);
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