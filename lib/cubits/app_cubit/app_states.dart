abstract class AppStates {}

class InitialAppState extends AppStates {}

class LoadingState extends AppStates {}

class LoadingAppState extends AppStates {}

class SuccessfulSetPlaceLocationState extends AppStates {}

class SuccessfulSetCategoryState extends AppStates {}

class NoImageSelectedStates extends AppStates {}

class SuccessfulAddPlaceState extends AppStates {}

class ErrorAddPlaceState extends AppStates {
  final String? error;

  ErrorAddPlaceState(this.error);
}

class SwitchingState extends AppStates {}

class SwitchTimingsState extends AppStates {}

class SetTimeState extends AppStates {}

class TimeSelectedState extends AppStates {}

class SuccessfulFetchPlaceState extends AppStates {}

class ErrorFetchPlaceState extends AppStates {
  final String? error;

  ErrorFetchPlaceState(this.error);
}

class SuccessfulFetchPlaceDetailsState extends AppStates {
  SuccessfulFetchPlaceDetailsState();
}

class SuccessfulFetchBannersState extends AppStates {
  SuccessfulFetchBannersState();
}

class ErrorFetchBannersState extends AppStates {
  final String? error;

  ErrorFetchBannersState(this.error);
}

class SuccessfulFetchPlaceWithCategoryState extends AppStates {}

class ErrorFetchPlaceWithCategoryState extends AppStates {
  final String? error;

  ErrorFetchPlaceWithCategoryState(this.error);
}
