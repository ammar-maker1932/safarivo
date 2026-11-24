
import 'package:flutter_litert/flutter_litert.dart';

// Holds all four AI expense predictions
class TripBudgetPrediction {
  final double transportation;
  final double accommodation;
  final double food;
  final double otherExpenses;

  const TripBudgetPrediction({
    required this.transportation,
    required this.accommodation,
    required this.food,
    required this.otherExpenses,
  });

  // Calculate total from all four expenses
  double get total =>
      transportation + accommodation + food + otherExpenses;

  // Calculate cost per traveller
  double perPerson(int travellers) {
    if (travellers <= 0) {
      throw ArgumentError('Travellers must be greater than zero.');
    }

    return total / travellers;
  }
}

class BudgetPredictionService {
  Interpreter? _interpreter;

  // Load the trained TFLite model
  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset(
      'assets/models/trip_budget.tflite',
    );

    _interpreter!.allocateTensors();

    print('Safarivo AI Budget Model Loaded Successfully');
  }

  // Predict individual trip expenses
  TripBudgetPrediction predictBudget({
    required String destination,
    required int days,
    required int travellers,
    required String accommodation,
  }) {
    if (_interpreter == null) {
      throw StateError('AI model has not been loaded yet.');
    }

    // Destination one-hot encoding
    final destinationValues = [
      destination == 'Hunza' ? 1.0 : 0.0,
      destination == 'Skardu' ? 1.0 : 0.0,
      destination == 'Naran' ? 1.0 : 0.0,
      destination == 'Murree' ? 1.0 : 0.0,
      destination == 'Swat' ? 1.0 : 0.0,
    ];

    // Accommodation one-hot encoding
    final accommodationValues = [
      accommodation == 'Budget' ? 1.0 : 0.0,
      accommodation == 'Standard' ? 1.0 : 0.0,
      accommodation == 'Luxury' ? 1.0 : 0.0,
    ];

    // Keep the exact feature order used during training
    final input = [
      [
        ...destinationValues,
        days.toDouble(),
        travellers.toDouble(),
        ...accommodationValues,
      ]
    ];

    // Model produces four expense predictions
    final output = [
      List<double>.filled(4, 0.0)
    ];

    _interpreter!.run(input, output);

    // Extract predictions in training target order
    return TripBudgetPrediction(
      transportation: output[0][0].clamp(0.0, double.infinity),
      accommodation: output[0][1].clamp(0.0, double.infinity),
      food: output[0][2].clamp(0.0, double.infinity),
      otherExpenses: output[0][3].clamp(0.0, double.infinity),
    );
  }

  // Close model when no longer needed
  void dispose() {
    _interpreter?.close();
    _interpreter = null;
  }
}
