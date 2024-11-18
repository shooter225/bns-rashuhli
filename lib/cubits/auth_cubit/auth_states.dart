abstract class AuthStates {}

class InitialAuthState extends AuthStates {}

class ChangeVisabilityPasswordState extends AuthStates {}

class ChangeRememberMeState extends AuthStates {}

class ChangeVisabilityConfirmPasswordState extends AuthStates {}

class LoadingAuthState extends AuthStates {}

class LoadingGoogleAuthState extends AuthStates {}

class LoadingAppleAuthState extends AuthStates {}

class SuccessfulAuthState extends AuthStates {}

class FailureAuthState extends AuthStates {
  final String error;

  FailureAuthState({required this.error});
}

class SuccessfulSignAuthState extends AuthStates {}

class FailureSignAuthState extends AuthStates {
  final String error;

  FailureSignAuthState({required this.error});
}

class WaitingSignInGoogleState extends AuthStates {}

class SuccessfulLoginAuthState extends AuthStates {}

class FailureLoginAuthState extends AuthStates {
  final String error;

  FailureLoginAuthState({required this.error});
}

class SuccessfulPhoneAuthState extends AuthStates {}

class FailurePhoneAuthState extends AuthStates {
  final String error;

  FailurePhoneAuthState({required this.error});
}

class SendVerificationAuthState extends AuthStates {}

class SuccessfulVerificationAuthState extends AuthStates {}

class FailureVerificationAuthState extends AuthStates {
  final String error;

  FailureVerificationAuthState({required this.error});
}

class SuccessfulLogOutAuthState extends AuthStates {}

class FailureLogOutAuthState extends AuthStates {
  final String error;
  FailureLogOutAuthState({required this.error});
}

class SuccessfulStoreUserDataAuthState extends AuthStates {}

class FailureStoreUserDataAuthState extends AuthStates {
  final String error;

  FailureStoreUserDataAuthState({required this.error});
}

class SuccessfulPasswordResetState extends AuthStates {}

class FailurePasswordResetState extends AuthStates {
  final String error;

  FailurePasswordResetState({required this.error});
}

class LoadingUserDataState extends AuthStates {}

class SuccessfulGetUserDataState extends AuthStates {}

class FailureGetUserDataState extends AuthStates {
  final String error;

  FailureGetUserDataState({required this.error});
}

class SuccessfulUpdateUserDataState extends AuthStates {}

class FailureUpdateUserDataState extends AuthStates {
  final String error;

  FailureUpdateUserDataState({required this.error});
}

class DeleteAccountSuccessState extends AuthStates {}

class DeleteAccountFailureState extends AuthStates {
  final String? error;

  DeleteAccountFailureState(this.error);
}
