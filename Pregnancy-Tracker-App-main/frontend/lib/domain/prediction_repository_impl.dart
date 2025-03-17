// lib/infrastructure/prediction/prediction_repository_impl.dart
import 'prediction_repository.dart';
import 'package:frontend/infrastructure/prediction_service.dart';

class PredictionRepositoryImpl implements PredictionRepository {
  final PredictionService _predictionService;

  PredictionRepositoryImpl(this._predictionService);

   @override
  Future<String> predict(int gestation, int parity, int age, double height, double weight, int smoke) async {
    try {
      return await _predictionService.predict(gestation, parity, age, height, weight, smoke);
    } catch (e) {
      throw Exception("Failed to fetch prediction: $e");
    }
  }
}