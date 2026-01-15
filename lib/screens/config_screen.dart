import 'package:flutter/material.dart';
import '../services/ahp_service.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({Key? key}) : super(key: key);

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  final TextEditingController _urlController = TextEditingController();
  final AhpService _service = AhpService();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUrl();
  }

  void _loadCurrentUrl() async {
    // Load current Gist URL if available
    setState(() {
      _urlController.text = _service.currentGistUrl;
    });
  }

  void _saveConfig() {
    setState(() {
      _isSaving = true;
    });

    // Update the service with the new URL
    _service.setGistUrl(_urlController.text.trim());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Gist URL Saved!")),
    );

    setState(() {
      _isSaving = false;
    });
    
    // Go back
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Konfigurasi Server")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Masukkan URL Raw Gist GitHub yang berisi konfigurasi 'base_url'.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: "GitHub Gist Raw URL",
                border: OutlineInputBorder(),
                hintText: "https://gist.githubusercontent.com/...",
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: _isSaving ? const Text("Menyimpan...") : const Text("SIMPAN KONFIGURASI"),
                onPressed: _isSaving ? null : _saveConfig,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
