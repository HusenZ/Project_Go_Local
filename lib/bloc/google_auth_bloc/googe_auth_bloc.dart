import 'package:gozip/bloc/google_auth_bloc/google_auth_event.dart';
import 'package:gozip/bloc/google_auth_bloc/google_auth_state.dart';
import 'package:gozip/data/repository/phone_verfi_repo.dart';
import 'package:gozip/data/repository/sign_up_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSignInBloc extends Bloc<GoogleSignInEvent, GoogleSignInState> {
  final SharedPreferences _preferences;
  GoogleSignInBloc(this._preferences) : super(GoogleSignInInitial()) {
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
  }

  Future<void> _onGoogleSignInRequested(
      GoogleSignInRequested event, Emitter<GoogleSignInState> emit) async {
    emit(GoogleSignInLoading());

    try {
      final isSignInSuccessful = await SignUpApi.signInWithGoogle();
      if (isSignInSuccessful) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // Check for null user
          if (await VerificationApi.emailExists(user.email!) == true) {
            _preferences.setBool("isAuthenticated", true);
            emit(NavigateToHomeRoute());
          } else {
            emit(SetProfileState());
          }
          emit(GoogleSignInSuccess());
        } else {
          emit(const GoogleSignInFailure(
              'An error occurred. Please try again.'));
        }
      } else {
        emit(const GoogleSignInFailure('Error logging in with Google'));
      }
    } catch (error) {
      emit(GoogleSignInFailure(error.toString()));
    }
  }
}
