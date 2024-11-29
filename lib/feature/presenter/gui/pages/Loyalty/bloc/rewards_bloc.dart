import 'package:flutter_bloc/flutter_bloc.dart';
import 'rewards_event.dart';
import 'rewards_state.dart';

class RewardsBloc extends Bloc<RewardsEvent, RewardsState> {
  int currentPoints = 0; // Store the current progress points locally

  RewardsBloc() : super(RewardsLoading()) {
    on<LoadRewardsEvent>(_onLoadRewards);
    on<UpdateRewardsEvent>(_onUpdateRewards);
  }

  /// Handles the [LoadRewardsEvent] to initialize rewards points
  Future<void> _onLoadRewards(
      LoadRewardsEvent event, Emitter<RewardsState> emit) async {
    emit(RewardsLoading()); // Emit loading state
    try {
      // Simulate a delay (e.g., fetching data from an API or database)
      await Future.delayed(Duration(seconds: 1));
      currentPoints = 65; // Example initial points
      emit(RewardsLoaded(currentPoints)); // Emit loaded state with points
    } catch (error) {
      emit(RewardsError("Failed to load rewards")); // Emit error state
    }
  }

  /// Handles the [UpdateRewardsEvent] to modify the rewards progress points
  Future<void> _onUpdateRewards(
      UpdateRewardsEvent event, Emitter<RewardsState> emit) async {
    try {
      currentPoints += event.points; // Update points
      currentPoints =
          currentPoints.clamp(0, 100); // Ensure points stay in range
      emit(RewardsLoaded(currentPoints)); // Emit updated state
    } catch (error) {
      emit(RewardsError("Failed to update rewards")); // Emit error state
    }
  }
}
