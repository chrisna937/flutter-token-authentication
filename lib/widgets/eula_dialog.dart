import 'package:flutter/material.dart';

class EulaDialog extends StatefulWidget {
  final String versionCode;
  final String content;
  final int versionId;
  final int userId;
  final Future<bool> Function(int userId, int versionId) onAccept;

  const EulaDialog({
    Key? key,
    required this.versionCode,
    required this.content,
    required this.versionId,
    required this.userId,
    required this.onAccept,
 }) : super(key: key);

  @override
  State<EulaDialog> createState() => _EulaDialogState();
}

class _EulaDialogState extends State<EulaDialog> {
  bool _accepted = false;
  bool _isLoading = false;

  void _handleAccept() async {
    setState(() => _isLoading = true);

    bool success = await widget.onAccept(widget.userId, widget.versionId);

    setState(() => _isLoading = false);

    if (success) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to submit EULA Acceptance")),
      );
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("EULA ${widget.versionCode}"),
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
           Expanded(
            child: SingleChildScrollView(
              child: Text(widget.content),
            ),
            ),
            Row(
              children: [
                Checkbox(
                  value: _accepted, 
                  onChanged: (val) {
                    setState(() {
                      _accepted = val ?? false;
                    });
                  },
                  ),
                  const Expanded(child: Text("I have read and accept the EULA")),
              ],
              ),
        ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(false), 
          child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: _accepted && !_isLoading ? _handleAccept : null, 
            child: _isLoading
                ? const SizedBox(
                   width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2),
                )
                : const Text("Accept"),
                ),
      ],
    );
  }
}