import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:bs_rashhuli/cache/cache_helper.dart';
import 'package:bs_rashhuli/views/auth/login_view.dart';
import 'package:bs_rashhuli/views/main_home_view.dart';
import '../../constants/constants.dart';
import '../../helper/helper.dart';
import '../../models/user_model.dart';
import '../../views/auth/user_role_view.dart';
import '../../views/auth/verification_email_auth_view.dart';
import '../timer_cubit/timer_cubit.dart';
import 'auth_states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(InitialAuthState());
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  UserModel? userModel;
  // List<UserModel>? userModelList;
  // List<QueryDocumentSnapshot> userData = [];
  // List<UserModel> data = [];
  // UserCredential? credential;
  // late UserModel UserModel;
  // bool isLoading = false;
  bool showPassword = true;
  bool rememberMe = false;

////////////////// change visibility to password ////////////////////////
  void changeVisibilityPassword() {
    showPassword = !showPassword;
    emit(ChangeRememberMeState());
  }

////////////////// reset visibility ////////////////////////
  void resetVisibility() {
    showPassword = true;
    emit(InitialAuthState());
  }

  ////////////////// change remember me  ////////////////////////
  void changeRememberMe() {
    rememberMe = !rememberMe;
    rememberMeSave = rememberMe;
    // CacheHelper.saveData(key: "rememberMe", value: rememberMe);
    emit(ChangeRememberMeState());
  }

  ////////////////// remember me method ////////////////////////
  void rememberMeMethod(
      {required bool rememberMe, String? email, String? password}) {
    CacheHelper.saveData(key: "rememberMe", value: rememberMe);
    if (rememberMe) {
      CacheHelper.saveData(key: "emailSave", value: email);
      CacheHelper.saveData(key: "passwordSave", value: password);
    } else {
      CacheHelper.removeData(
        key: "emailSave",
      );
      // print(emailSave);
      CacheHelper.removeData(
        key: "passwordSave",
      );
    }
  }

  void loadRememberMe() async {
    rememberMeSave = CacheHelper.getData(key: "rememberMe") ?? false;
    emailSave = CacheHelper.getData(key: "emailSave");
    passwordSave = CacheHelper.getData(key: "passwordSave");

    // if (rememberMeSave != null && rememberMeSave == true) {
    //   _isRememberMeChecked = true;
    //   _emailController.text = email ?? "";
    //   _passwordController.text = password ?? "";
    // }
  }

////////////////// sign in ////////////////////////
  Future<void> signUpSubmit(
    context, {
    required String name,
    required String email,
    required String password,
  }) async {
    emit(LoadingAuthState());
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      await sendVerification(context);

      if (firebaseAuth.currentUser != null &&
          !firebaseAuth.currentUser!.emailVerified) {
        await storeUserData(context, name: name, email: email);

        naviPush(
          context,
          widgetName: VerficationEmailAuthView(
            email: firebaseAuth.currentUser!.email!,
          ),
        );
      }
    } on FirebaseException catch (e) {
      // print(e.message);

      String messageError = handleFirebaseException(e);
      if (messageError.isNotEmpty) {
        showSnakBar(context, message: messageError);
      }

      emit(FailureSignAuthState(error: e.message.toString()));
    } catch (e) {
      showSnakBar(context, message: "Oops there was an error, try later");
      // print(e);
      emit(FailureSignAuthState(error: e.toString()));
    }
  }

////////////////// store the data of the user ////////////////////////
  Future<void> storeUserData(
    context, {
    required String name,
    required String email,
    String? imageUrl,
  }) async {
    emit(LoadingAuthState());
    try {
      await firebaseAuth.currentUser!.reload();
      await users.doc(firebaseAuth.currentUser!.uid).set(
        {
          'id': firebaseAuth.currentUser!.uid,
          'name': name,
          'user_role': 'guest',
          'email': email,
          'location': '',
          'create_at': DateTime.now().toString(),
        },
      );

      emit(SuccessfulStoreUserDataAuthState());
    } on FirebaseException catch (e) {
      showSnakBar(context, message: e.code);
    } catch (e) {
      // print(e);
      emit(FailureStoreUserDataAuthState(error: e.toString()));
    }
  }

  Future<void> updateUserRole(
    context, {
    required String userRole,
  }) async {
    await firebaseAuth.currentUser!.reload();
    await users.doc(firebaseAuth.currentUser!.uid).set(
      {
        'user_role': userRole,
      },
      SetOptions(merge: true),
    );
    naviPushAndRemoveUntil(context, widgetName: const MainHomeView());
  }

////////////////// get the data of the user ////////////////////////
  Future<void> getUserData() async {
    emit(LoadingAuthState());
    try {
      User? currentUser = firebaseAuth.currentUser;

      if (currentUser != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get();
        var doc = querySnapshot.docs.first;
        userModel = UserModel.fromJson(doc.data(), doc['create_at']);
        // print("Login with ===> ${userModel!.email}");
        // print("name ===> ${userModel!.name}");
        emit(SuccessfulGetUserDataState());
      } else {
        // Handle user not authenticated scenario
        print('User not authenticated');
      }
    } on FirebaseException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }

////////////////// update user data ////////////////////////
  Future updateUserData(
    context, {
    required String uid,
    String? location,
    String? name,
    String? email,
  }) async {
    emit(LoadingAuthState());
    try {
      await users.doc(uid).set({
        'name': name,
        'location': location,
        'email': email,
      }, SetOptions(merge: true));
      showSnakBar(context, message: "Your data has been updated successfully");
      await getUserData();
      // for save and go to more view
      Navigator.of(context).popUntil((route) => route.isFirst);
      // for save and go to profile view
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => ProfileView(userID: uid),
      //   ),
      // );
      emit(SuccessfulUpdateUserDataState());
    } catch (e) {
      emit(FailureUpdateUserDataState(error: e.toString()));
    }
  }

////////////////// send verify ////////////////////////
  Future<void> sendVerification(context) async {
    try {
      await firebaseAuth.currentUser!.sendEmailVerification();
      showSnakBar(context, message: "Please check your email to verify");
      emit(SendVerificationAuthState());
    } on FirebaseAuthException catch (e) {
      if (e.message != null) {
        showSnakBar(context, message: e.message!);
      }
      emit(FailureVerificationAuthState(error: e.code));
    } catch (e) {
      showSnakBar(context, message: e.toString());
      // print(e);
      emit(FailureVerificationAuthState(error: e.toString()));
    }
  }

////////////////// after verify successful ////////////////////////
  Future<void> afterVerifySuccessful(context) async {
    await firebaseAuth.currentUser!.reload();
    try {
      if (firebaseAuth.currentUser!.emailVerified) {
        BlocProvider.of<TimerCubit>(context).cancelTimer();
        // naviPushAndRemoveUntil(context, widgetName: const MainHomeView());
        naviPushAndRemoveUntil(context, widgetName: UserRoleView());
        emit(SuccessfulVerificationAuthState());
      } else {
        return;
      }
    } catch (e) {
      emit(FailureVerificationAuthState(error: e.toString()));
    }
  }

////////////////// Login ////////////////////////
  Future<void> submitLogin(
    context, {
    required String email,
    required String password,
  }) async {
    emit(LoadingAuthState());
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // print("Email: $email, Password: $password");
      if (!FirebaseAuth.instance.currentUser!.emailVerified) {
        naviPush(
          context,
          widgetName: VerficationEmailAuthView(
            email: firebaseAuth.currentUser!.email.toString(),
          ),
        );
        sendVerification(context);
      } else {
        firebaseAuth.currentUser!.reload();
        if (firebaseAuth.currentUser!.emailVerified) {
          naviPushAndRemoveUntil(context, widgetName: const MainHomeView());
          emit(SuccessfulLoginAuthState());
        }
      }
    } on FirebaseAuthException catch (e) {
      String? messageError = handleFirebaseException(e);
      showSnakBar(context, message: messageError);
      // log(e.code);

      emit(FailureLoginAuthState(error: e.code));
    } catch (e) {
      log(e.toString());
      showSnakBar(context, message: "Oops there was an error, try later");
      emit(FailureLoginAuthState(error: e.toString()));
    }
  }

////////////////// sign in with google ////////////////////////
  Future<void> signInWithGoogle(context) async {
    // Trigger the authentication flow
    emit(LoadingGoogleAuthState());
    try {
      // final GoogleSignIn googleSignIn = GoogleSignIn(
      //   clientId:
      //       '395126819495-51a14l6tgtud5183e11jpq9kqqivrq99.apps.googleusercontent.com',
      // );
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        emit(FailureLoginAuthState(error: "Email not specified"));
        return;
      }
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      // Check if both accessToken and idToken are available
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        emit(FailureLoginAuthState(
            error:
                "Failed to retrieve access or ID token from Google Sign-In"));
        return;
      }
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      emit(WaitingSignInGoogleState());
      // Once signed in, return the UserCredential

      await FirebaseAuth.instance.signInWithCredential(credential);

      final userQuerySnapshot =
          await users.where('email', isEqualTo: googleUser.email).get();
      await firebaseAuth.currentUser!.reload();

      if (userQuerySnapshot.docs.isEmpty) {
        storeUserData(
          context,
          email: googleUser.email,
          name: googleUser.displayName.toString(),
          imageUrl: googleUser.photoUrl.toString(),
        );
      } else {}

      // naviPushAndRemoveUntil(context, widgetName: const MainHomeView());
      naviPushAndRemoveUntil(context, widgetName: UserRoleView());
      emit(SuccessfulLoginAuthState());
    } on FirebaseAuthException catch (e) {
      // print(e);
      String messageError = handleFirebaseException(e);
      showSnakBar(context, message: messageError);
      emit(FailureLoginAuthState(error: e.toString()));
    } catch (e) {
      // print(e);
      showSnakBar(context, message: "Oops there was an error, try later");
      emit(FailureLoginAuthState(error: e.toString()));
    }
  }

////////////////// password reset ////////////////////////
  Future<void> passwordReset(context, {required String email}) async {
    if (email.isNotEmpty) {
      try {
        if (firebaseAuth.currentUser!.emailVerified) {
          await firebaseAuth.sendPasswordResetEmail(email: email);
          showSnakBar(context,
              message: "Please, check your email to reset your password.");
          emit(SuccessfulPasswordResetState());
        } else {
          showSnakBar(context, message: "Please, verify your email first");
        }
      } on FirebaseAuthException catch (e) {
        String messageError = handleFirebaseException(e);
        showSnakBar(context, message: messageError);
      } catch (e) {
        showSnakBar(context, message: "Please, enter your email first");
        emit(FailurePasswordResetState(error: e.toString()));
      }
    } else {
      showSnakBar(context, message: "Please, enter your email first");
    }
  }

////////////////// log out ////////////////////////
  Future<void> logOut(context) async {
    GoogleSignIn user = GoogleSignIn();
    try {
      if (firebaseAuth.currentUser != null) {
        await firebaseAuth.signOut();
        await user.signOut();
        naviPushAndRemoveUntil(context, widgetName: const LoginView());

        emit(SuccessfulLogOutAuthState());
      } else {
        return;
      }

      await user.signOut();

      // naviPushAndRemoveUntil(context, widgetName: const SelectionStorageView());
      emit(SuccessfulLogOutAuthState());
    } on FirebaseException catch (e) {
      // print(e.code);
      String? errorMesage = handleFirebaseException(e);
      showSnakBar(context, message: errorMesage);
      emit(FailureLogOutAuthState(error: e.code));
    } catch (e) {
      // print(e);
      showSnakBar(context, message: "Oops there was an error, try later");
      emit(FailureLogOutAuthState(error: e.toString()));
    }
  }

////////////////// log out ////////////////////////
  Future<void> deleteUserAccount(context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        emit(DeleteAccountFailureState("No user is currently signed in."));
        return;
      }
      await users.doc(firebaseAuth.currentUser!.uid).delete();
      await user.delete();
      await logOut(context);
      emit(DeleteAccountSuccessState());
    } on FirebaseAuthException catch (e) {
      String? messageError = handleFirebaseException(e);
      showSnakBar(context, message: messageError);
      emit(DeleteAccountFailureState(e.message ?? "An error occurred"));
      // if (e.code == "requires-recent-login") {
      //   showSnakBar(context,
      //       message: "You need to log in again to perform this action.");

      //   // await _reauthenticateAndDelete();
      // } else {
      //   emit(DeleteAccountFailureState(e.message ?? "An error occurred"));
      // }
    } catch (e) {
      log(e.toString());
      emit(DeleteAccountFailureState("An unexpected error occurred: $e"));
    }
  }

  // Future<void> _reauthenticateAndDelete() async {
  //   try {
  //     final user = FirebaseAuth.instance.currentUser;

  //     if (user == null) {
  //       emit(DeleteAccountFailureState("No user is currently signed in."));
  //       return;
  //     }

  //     final providerData = user.providerData.first;

  //     if (providerData.providerId == AppleAuthProvider.PROVIDER_ID) {
  //     } else if (providerData.providerId == GoogleAuthProvider.PROVIDER_ID) {
  //       final googleUser = await GoogleSignIn().signIn();
  //       final googleAuth = await googleUser!.authentication;
  //       final credential = GoogleAuthProvider.credential(
  //         accessToken: googleAuth.accessToken,
  //         idToken: googleAuth.idToken,
  //       );
  //       await user.reauthenticateWithCredential(credential);
  //       await users.doc(firebaseAuth.currentUser!.uid).delete();
  //     } else {
  //       emit(DeleteAccountFailureState(
  //           "Unsupported provider for re-authentication."));
  //       return;
  //     }

  //     await user.delete();
  //     emit(DeleteAccountSuccessState());
  //   } catch (e) {
  //     log(e.toString());
  //     emit(DeleteAccountFailureState(
  //         "An error occurred during re-authentication: $e"));
  //   }
  // }
}
