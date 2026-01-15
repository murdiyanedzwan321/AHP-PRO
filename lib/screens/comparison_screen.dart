import 'package:flutter/material.dart';
import '../services/ahp_service.dart';
import 'result_screen.dart';

class ComparisonScreen extends StatefulWidget {
  final List<String> criteria;
  final List<String> alternatives;

  const ComparisonScreen({Key? key, required this.criteria, required this.alternatives}) : super(key: key);

  @override
  _ComparisonScreenState createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen> {
  final AhpService _service = AhpService();
  bool _isLoading = false;

  // Data structure to store comparison values
  // Key: "IndexA-IndexB", Value: 1-9 (positive favors A, negative favors B logic handled internally)
  // Here we simplify: Store raw slider value. 
  // Slider range: 1 to 17. 
  // 1 = B mutlak, 9 = Equal, 17 = A mutlak. 
  // Mapping logic will be needed.
  Map<String, double> criteriaComparisons = {};
  Map<String, Map<String, double>> alternativesComparisons = {};

  @override
  void initState() {
    super.initState();
    // Initialize storage for alternatives comparisons
    for (var c in widget.criteria) {
      alternativesComparisons[c] = {};
    }
  }

  // Helper to convert Slider value (1-17) to Saaty value (1/9 to 9)
  double _sliderToSaaty(double sliderVal) {
    // Slider: 1..9..17
    // 9 => 1 (Equal)
    // 10..17 => 2..9 (Favor Left)
    // 1..8 => 9..2 (Favor Right) inverted i.e. 1/2 .. 1/9
    
    if (sliderVal == 9.0) return 1.0;
    if (sliderVal > 9.0) return sliderVal - 8.0; // 10->2, 17->9
    return 1.0 / (10.0 - sliderVal); // 8->1/2, 1->1/9
  }
  
  // Build Matrix from stored comparisons
  List<List<double>> _buildMatrix(List<String> items, Map<String, double> comparisons) {
    int n = items.length;
    List<List<double>> matrix = List.generate(n, (_) => List.filled(n, 1.0));

    for (int i = 0; i < n; i++) {
      for (int j = i + 1; j < n; j++) {
        String key = "$i-$j";
        double sliderVal = comparisons[key] ?? 9.0;
        double saatyVal = _sliderToSaaty(sliderVal);
        
        matrix[i][j] = saatyVal;
        matrix[j][i] = 1.0 / saatyVal;
      }
    }
    return matrix;
  }

  void _submit() async {
    setState(() => _isLoading = true);

    try {
      // 1. Build Criteria Matrix
      List<List<double>> criteriaMatrix = _buildMatrix(widget.criteria, criteriaComparisons);
      
      // 2. Build Alternatives Matrices
      Map<String, List<List<double>>> altMatrices = {};
      for (var c in widget.criteria) {
        altMatrices[c] = _buildMatrix(widget.alternatives, alternativesComparisons[c] ?? {});
      }

      // 3. Prepare Payload
      Map<String, dynamic> payload = {
        "criteria_names": widget.criteria,
        "alternative_names": widget.alternatives,
        "criteria_matrix": criteriaMatrix,
        "alternatives_matrices": altMatrices
      };

      // 4. Send to Backend
      final result = await _service.calculateAhp(payload);
      
      // 5. Build Result Graph
      if (!mounted) return;
      Navigator.push(
        context, 
        MaterialPageRoute(builder: (_) => ResultScreen(data: result))
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildComparisonSection(
    String title, 
    List<String> items, 
    Map<String, double> storage
  ) {
    List<Widget> rows = [];
    for (int i = 0; i < items.length; i++) {
      for (int j = i + 1; j < items.length; j++) {
        String key = "$i-$j";
        double currentVal = storage[key] ?? 9.0; // Default 9 (Equal)

        rows.add(Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(items[i], textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold))),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("vs"),
                    ),
                    Expanded(child: Text(items[j], style: const TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
                Slider(
                  value: currentVal,
                  min: 1,
                  max: 17,
                  divisions: 16,
                  label: _getLabel(currentVal),
                  onChanged: (val) {
                    setState(() {
                      storage[key] = val;
                    });
                  },
                ),
                Text(
                  _getDescription(currentVal, items[i], items[j]),
                  style: TextStyle(color: Colors.grey[700], fontSize: 12),
                )
              ],
            ),
          ),
        ));
      }
    }
    return ExpansionTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      initiallyExpanded: title.contains("Kriteria"), // Expand only Criteria by default
      children: rows,
    );
  }

  String _getLabel(double val) {
    if (val == 9) return "Sama Penting";
    if (val > 9) return "Kiri +${(val-8).toInt()}";
    return "Kanan +${(10-val).toInt()}";
  }

  String _getDescription(double val, String left, String right) {
    if (val == 9) return "$left sama penting dengan $right";
    if (val > 9) return "$left lebih penting dari $right";
    return "$right lebih penting dari $left";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Input Perbandingan")),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text("Geser slider untuk menentukan prioritas.", style: TextStyle(fontStyle: FontStyle.italic)),
            const SizedBox(height: 10),
            
            _buildComparisonSection("Perbandingan Kriteria", widget.criteria, criteriaComparisons),
            const Divider(thickness: 2),
            
            ...widget.criteria.map((c) {
              return _buildComparisonSection(
                "Alternatif berdasarkan $c", 
                widget.alternatives, 
                alternativesComparisons[c]!
              );
            }).toList(),
            
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18)
              ),
              child: const Text("PROSES HITUNG (AHP)"),
            ),
            const SizedBox(height: 40),
          ],
        ),
    );
  }
}
