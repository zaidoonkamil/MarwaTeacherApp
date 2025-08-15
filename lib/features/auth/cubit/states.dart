abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class ValidationState extends LoginStates {}
class PasswordVisibilityChanged extends LoginStates {}

class LoginLoadingState extends LoginStates {}
class LoginSuccessState extends LoginStates {}
class LoginErrorState extends LoginStates {}

class SignUpLoadingState extends LoginStates {}
class SignUpSuccessState extends LoginStates {}
class SignUpErrorState extends LoginStates {}


