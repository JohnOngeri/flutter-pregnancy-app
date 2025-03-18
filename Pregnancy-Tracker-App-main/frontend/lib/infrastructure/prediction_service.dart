// lib/infrastructure/prediction/prediction_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class PredictionService {
  static const String apiUrl = 'https://flutter-pregnancy-app-4.onrender.com/predict';

  Future<String> predict(int gestation, int parity, int age, double height, double weight, int smoke) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "Gestation": gestation,
          "parity": parity,
          "age": age,
          "height": height,
          "weight": weight,
          "smoke": smoke,
        }),
      );

       print("Response Code: ${response.statusCode}");
       print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['predicted_birthweight']?.toString() ?? "No predicted_birthweight found!"; // Ensure the API returns a 'prediction' field
      } else {
        throw Exception("Failed to fetch prediction: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("Failed to connect to API: $e");
    }
  }
}