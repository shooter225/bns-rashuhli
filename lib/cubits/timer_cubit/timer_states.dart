abstract class TimerStates {}

class TimerInitialState extends TimerStates {}

class TimerTickingState extends TimerStates {
  // final int timeRemaining;

  // TimerTickingState(this.timeRemaining);
}

class TimerFinishedState extends TimerStates {}

class TimerStoppedState extends TimerStates {}

class TimerCanceledState extends TimerStates {}
