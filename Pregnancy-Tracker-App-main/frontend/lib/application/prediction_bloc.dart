import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/prediction_repository_impl.dart';

abstract class PredictionEvent {}

class PredictEvent extends PredictionEvent {
  final int gestation; // 200-310
  final int parity;    // 0-10
  final int age;       // 16-49
  final double height; // 120-200 cm
  final double weight; // 35-150 kg
  final int smoke;     // 0 or 1

  PredictEvent({
    required this.gestation,
    required this.parity,
    required this.age,
    required this.height,
    required this.weight,
    required this.smoke,
  });
}

abstract class PredictionState {}

class PredictionInitial extends PredictionState {}

class PredictionLoading extends PredictionState {}

class PredictionSuccess extends PredictionState {
  final String result;
  PredictionSuccess(this.result);
}

class PredictionError extends PredictionState {
  final String message;
  PredictionError(this.message);
}

class PredictionBloc extends Bloc<PredictEvent, PredictionState> {
  final PredictionRepositoryImpl repository;

  PredictionBloc(this.repository) : super(PredictionInitial()) {
    on<PredictEvent>((event, emit) async {
      emit(PredictionLoading());
      try {
        final result = await repository.predict(
          event.gestation,
          event.parity,
          event.age,
          event.height,
          event.weight,
          event.smoke,
        );
        emit(PredictionSuccess(result));
      } catch (e) {
        emit(PredictionError("Failed to fetch prediction"));
      }
    });
  }
}
