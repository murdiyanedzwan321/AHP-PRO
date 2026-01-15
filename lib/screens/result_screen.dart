import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const ResultScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final List<dynamic> ranking = data['final_ranking'];
    final Map<String, dynamic> criteriaAnalysis = data['criteria_analysis'];
    final bool isConsistent = criteriaAnalysis['consistency']['is_consistent'];

    return Scaffold(
      appBar: AppBar(title: const Text('Hasil Analisis')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Konsistensi
            Card(
              color: isConsistent ? Colors.green[100] : Colors.red[100],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      isConsistent ? Icons.check_circle : Icons.warning,
                      color: isConsistent ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isConsistent 
                        ? 'Konsisten (CR: ${criteriaAnalysis['consistency']['cr'].toStringAsFixed(3)})'
                        : 'TIDAK KONSISTEN (CR: ${criteriaAnalysis['consistency']['cr'].toStringAsFixed(3)})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Ranking
            const Text('Ranking Prioritas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...ranking.map((item) {
              return Card(
                elevation: 3,
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${ranking.indexOf(item) + 1}'),
                  ),
                  title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Skor: ${(item['score'] * 100).toStringAsFixed(2)}%'),
                  trailing: SizedBox(
                    width: 100,
                    child: LinearProgressIndicator(
                      value: item['score'],
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
