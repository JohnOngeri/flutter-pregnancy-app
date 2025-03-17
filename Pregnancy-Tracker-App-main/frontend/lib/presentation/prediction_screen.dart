import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/prediction_bloc.dart';

class PredictionScreen extends StatefulWidget {
  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final TextEditingController gestationController = TextEditingController();
  final TextEditingController parityController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  String smokingStatus = '0'; // Default: Non-smoker

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Birthweight Prediction')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildNumberInput(gestationController, 'Gestation (200-310 days)', 200, 310),
            _buildNumberInput(parityController, 'Parity (0-10)', 0, 10),
            _buildNumberInput(ageController, 'Mother\'s Age (16-49 years)', 16, 49),
            _buildNumberInput(heightController, 'Height (120-200 cm)', 120, 200),
            _buildNumberInput(weightController, 'Weight (35-150 kg)', 35, 150),

            // Smoking Status Dropdown
            DropdownButtonFormField<String>(
              value: smokingStatus,
              items: [
                DropdownMenuItem(value: '0', child: Text('No')),
                DropdownMenuItem(value: '1', child: Text('Yes')),
              ],
              onChanged: (value) {
                setState(() {
                  smokingStatus = value!;
                });
              },
              decoration: InputDecoration(labelText: 'Smoking Status'),
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Validate inputs before sending
                context.read<PredictionBloc>().add(
                  PredictEvent(
                    gestation: int.parse(gestationController.text),
                    parity: int.parse(parityController.text),
                    age: int.parse(ageController.text),
                    height: double.parse(heightController.text),
                    weight: double.parse(weightController.text),
                    smoke: int.parse(smokingStatus),
                  ),
                );
              },
              child: Text('Predict'),
            ),

            BlocBuilder<PredictionBloc, PredictionState>(
              builder: (context, state) {
                if (state is PredictionLoading) return CircularProgressIndicator();
                if (state is PredictionSuccess) return Text("Prediction: ${state.result}");
                if (state is PredictionError) return Text("Error: ${state.message}");
                return SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to create input fields with validation
  Widget _buildNumberInput(TextEditingController controller, String label, num min, num max) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }
}
