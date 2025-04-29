abstract class AuthStates{}

class AuthInitialState extends AuthStates{}

class RegisterLoadingState extends AuthStates{}
class RegisterSuccessState extends AuthStates{}
class RegisterFailureState extends AuthStates{
  final String message;
  RegisterFailureState({required this.message});
}

class ChangeValueSuccessState extends AuthStates{}
class LoginLoadingState extends AuthStates{}
class LoginSuccessState extends AuthStates{}
class LoginFailureState extends AuthStates{
  final String message;
  LoginFailureState({required this.message});
}