import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_with_code_frontend/widgets/eula_dialog.dart';

  final String baseURL = "http://192.168.100.77:3000"; 

void _showEulaDialog(BuildContext context, int userId) async {
  try {
    //Fetch latest active version from your API
    final response = await http.get(Uri.parse("$baseURL/api/eula-active"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final int versionId = data['versionid'];
      final String versionCode = data['version_code'];
      final String content = data['content'];

      bool accepted = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => EulaDialog(
          versionCode: versionCode,
          content: content,
          versionId: versionId,
          userId: userId,
          onAccept: (userId, versionId) async {
            //Call EULA acceptance API
            final resp = await http.post(
              Uri.parse("$baseURL/api/eula-acceptance"),
              headers: {"Content-Type": "application/json"},
              body: jsonEncode({
                "userid": userId,
                "eula_version_id": versionId,
                "accepted_at": DateTime.now().toIso8601String(),
              }),
            );
            return resp.statusCode == 200 || resp.statusCode == 201;
          },
        ),
      );
      if (!accepted) {
        //User cancelled - logout or block further actions
      }
    }
  } catch (e) {
    print("Failed to fetch EULA: $e");
  }
}
