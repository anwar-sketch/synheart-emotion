import 'package:flutter/material.dart';
import 'package:synheart_emotion/synheart_emotion.dart';

/// Example showing how to load and use ONNX-based models
/// 
/// Note: This package has migrated from JSON-based LinearSVM models to ONNX models.
/// The ONNX format provides better performance and cross-platform compatibility.
class OnnxModelExample extends StatefulWidget {
  const OnnxModelExample({super.key});

  @override
  State<OnnxModelExample> createState() => _OnnxModelExampleState();
}

class _OnnxModelExampleState extends State<OnnxModelExample> {
  OnnxEmotionModel? _model;
  String _status = 'Loading model...';
  Map<String, double>? _lastPrediction;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      // Load the ONNX model from assets
      _model = await OnnxEmotionModel.loadFromAsset(
        modelAssetPath: 'assets/ml/extratrees_wrist_all_v1_0.onnx',
        metaAssetPath: 'assets/ml/extratrees_wrist_all_v1_0.meta.json',
      );
      
      setState(() {
        _status = 'Model loaded successfully!';
      });
      
      // Test with sample data
      _testPrediction();
    } catch (e) {
      setState(() {
        _status = 'Failed to load model: $e';
      });
    }
  }

  Future<void> _testPrediction() async {
    if (_model == null) return;
    
    // Test with sample features (must include all required features)
    final features = {
      'hr_mean': 75.0,
      'sdnn': 50.0,
      'rmssd': 35.0,
      'pnn50': 12.5,
      'mean_rr': 800.0,
    };
    
    try {
      // ONNX models use async prediction
      final prediction = await _model!.predictAsync(features);
      setState(() {
        _lastPrediction = prediction;
      });
    } catch (e) {
      setState(() {
        _status = 'Prediction failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ONNX Model Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Model Status',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(_status),
                    if (_model != null) ...[
                      Builder(
                        builder: (context) {
                          final metadata = _model!.getMetadata();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              Text(
                                'Model Info',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text('ID: ${metadata['id']}'),
                              Text('Type: ${metadata['type']}'),
                              Text('Classes: ${(metadata['labels'] as List).join(', ')}'),
                              Text('Features: ${(metadata['feature_names'] as List).join(', ')}'),
                              Text('Format: ${metadata['format'] ?? 'ONNX'}'),
                            ],
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            if (_lastPrediction != null) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sample Prediction',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text('Features: HR=75, SDNN=50, RMSSD=35, pNN50=12.5, Mean_RR=800'),
                      const SizedBox(height: 8),
                      ..._lastPrediction!.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 80,
                                child: Text(entry.key),
                              ),
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: entry.value,
                                  backgroundColor: Colors.grey[300],
                                ),
                              ),
                              Text('${(entry.value * 100).toStringAsFixed(1)}%'),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
            
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _testPrediction,
              child: const Text('Test Prediction'),
            ),
          ],
        ),
      ),
    );
  }
}
