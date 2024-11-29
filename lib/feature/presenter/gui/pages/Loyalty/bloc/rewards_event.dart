abstract class RewardsEvent {}

/// Event to load the rewards progress data
class LoadRewardsEvent extends RewardsEvent {}

/// Event to update the rewards progress points (e.g., after a user redeems or earns points)
class UpdateRewardsEvent extends RewardsEvent {
  final int points;

  UpdateRewardsEvent(this.points);
}
