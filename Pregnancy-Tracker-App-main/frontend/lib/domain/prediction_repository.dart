abstract class PredictionRepository {
  Future<String> predict(int gestation, int parity, int age, double height, double weight, int smoke);
}
