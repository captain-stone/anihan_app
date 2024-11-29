abstract class RewardsState {}

/// State while the rewards progress is being loaded
class RewardsLoading extends RewardsState {}

/// State when the rewards progress data has been successfully loaded
class RewardsLoaded extends RewardsState {
  final int points; // The current progress points

  RewardsLoaded(this.points);
}

/// State when there is an error loading or updating rewards
class RewardsError extends RewardsState {
  final String message;

  RewardsError(this.message);
}
