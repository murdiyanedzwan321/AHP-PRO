import 'package:flutter/material.dart';
import 'screens/comparison_screen.dart';
import 'screens/config_screen.dart';

void main() {
  runApp(const AgroAhpApp());
}

class AgroAhpApp extends StatelessWidget {
  const AgroAhpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agro-AHP Pro',
      theme: ThemeData(
        primarySwatch: Colors.green, // Agro theme
        scaffoldBackgroundColor: Colors.grey[50], 
        useMaterial3: false,
      ),
      home: const MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  // Case Study Data: Pabrik Kopi Roastery
  final List<String> criteria = const [
    "Kestabilan Suhu",
    "Konsumsi Gas",
    "Presisi Grinding"
  ];

  final List<String> alternatives = const [
    "Mesin Roasting A (German)",
    "Mesin Roasting B (China)",
    "Mesin Roasting C (Lokal)",
    "Mesin Roasting D (Second)"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agro-AHP Pro: Maintenance Decision"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ConfigScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.analytics, size: 80, color: Colors.green),
              const SizedBox(height: 20),
              const Text(
                "Studi Kasus: Pabrik Kopi Roastery",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text("User: Murdiyan Edzwan Nazib"),
              const SizedBox(height: 30),
              
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text("Kriteria:", style: TextStyle(fontWeight: FontWeight.bold)),
                      ...criteria.map((e) => Text("- $e")),
                      const SizedBox(height: 10),
                      const Text("Alternatif:", style: TextStyle(fontWeight: FontWeight.bold)),
                      ...alternatives.map((e) => Text("- $e")),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: const Text("MULAI ANALISIS AHP"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (_) => ComparisonScreen(
                        criteria: criteria,
                        alternatives: alternatives,
                      )
                    )
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
