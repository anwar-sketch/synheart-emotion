# Synheart Emotion Flutter Example

Example Flutter application demonstrating how to use the `synheart_emotion` package for on-device emotion inference from biosignals.

## Overview

This example app demonstrates:
- Loading and using ONNX-based emotion models
- Real-time emotion inference from heart rate and RR interval data
- Integration with wearable SDKs (synheart_wear)
- Streaming emotion results

## Examples Included

### 1. Main Demo (`lib/main.dart`)
A complete demo app showing:
- ONNX model loading from assets
- Simulated real-time biosignal data
- Emotion inference with a 60-second sliding window
- Real-time emotion probability visualization
- Buffer management and logging

### 2. Integration Example (`lib/integration_example.dart`)
Shows how to integrate `synheart_emotion` with `synheart_wear`:
- Initializing both SDKs
- Streaming wearable data to the emotion engine
- Using `EmotionStream` helper for simplified integration

### 3. ONNX Model Example (`lib/json_model_example.dart`)
**Note:** This file was renamed from `json_model_example.dart` but demonstrates ONNX model usage.

Shows how to:
- Load ONNX models from assets
- Perform async emotion predictions
- Access model metadata

## Migration from LinearSVM to ONNX

This package has migrated from JSON-based LinearSVM models to ONNX models (v0.2.0+). The ONNX format provides:
- Better performance
- Cross-platform compatibility
- Support for more complex models (e.g., ExtraTrees)

**Old approach (deprecated):**
```dart
final model = await JsonLinearModel.loadFromAsset('assets/ml/wesad_emotion_v1_0.json');
final prediction = model.predict(features);
```

**New approach:**
```dart
final model = await OnnxEmotionModel.loadFromAsset(
  modelAssetPath: 'assets/ml/extratrees_wrist_all_v1_0.onnx',
  metaAssetPath: 'assets/ml/extratrees_wrist_all_v1_0.meta.json',
);
final prediction = await model.predictAsync(features);
```

## Getting Started

1. Ensure you have the ONNX model files in `assets/ml/`:
   - `extratrees_wrist_all_v1_0.onnx`
   - `extratrees_wrist_all_v1_0.meta.json`

2. Run the app:
   ```bash
   flutter run
   ```

3. Tap "Start" to begin simulating biosignal data and see real-time emotion inference.

## Model Information

- **Model:** ExtraTrees ONNX (trained on WESAD wrist data)
- **Features:** HR mean, SDNN, RMSSD, pNN50, Mean RR
- **Emotions:** Amused, Calm, Stressed
- **Window:** 60 seconds (configurable)
- **Step:** 2-5 seconds (configurable)

## Resources

- [Package Documentation](https://pub.dev/packages/synheart_emotion)
- [GitHub Repository](https://github.com/synheart-ai/synheart-emotion)
- [CHANGELOG](../CHANGELOG.md) - See v0.2.0 for migration guide
