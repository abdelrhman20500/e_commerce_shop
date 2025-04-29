import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_shop/ui/screens/auth_screen/auth_cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState());

  /// login
  void login({required String email, required String password}) async {
    emit(LoginLoadingState()); // Emit loading state
    try {
      // Initialize Dio with default configuration
      Dio dio = Dio(
        BaseOptions(
          baseUrl: 'https://student.valuxapps.com/api', // Base URL
          receiveDataWhenStatusError: true, // Receive response even if status error occurs
          headers: {
            'Content-Type': 'application/json',
            'lang': 'en', // Set language for the request
          },
        ),
      );

      // Make a POST request to login endpoint
      final response = await dio.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final responseData = response.data;

        // Check if login was successful based on the response
        if (responseData['status'] == true) {
          print("User login success: ${responseData['data']}");

          // No token logic here - only emit success
          emit(LoginSuccessState()); // Emit success state
        } else {
          print("Failed to login, reason: ${responseData['message']}");
          emit(LoginFailureState(message: responseData['message'])); // Emit failure state
        }
      }
    } catch (e) {
      print("Login failed due to exception: $e");
      emit(LoginFailureState(message: e.toString())); // Emit failure state for exceptions
    }
  }
  /// Register
  void register({required String email, required String name, required String phone,
    required String password,}) async{
    emit(RegisterLoadingState());
    try {
      Dio dio = Dio(BaseOptions(
        baseUrl: 'https://student.valuxapps.com/api',
        receiveDataWhenStatusError: true,
        headers: {
          'Content-Type': 'application/json',
          'lang': 'en',
        },
      ));
      final response = await dio.post('/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          'image': "jdfjfj", // Value for image (required by API)
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          emit(RegisterSuccessState()); // Emit success state
        } else {
          emit(RegisterFailureState(message:data["message"])); // Emit failure state on exception
        }
      }
    } catch (e) {
      emit(RegisterFailureState(message: e.toString())); // Emit failure state on exception
    }
  }
  String? chosenValue;
  void changeDropDownValue({required String val})
  {
    chosenValue = val;
    emit(ChangeValueSuccessState());
  }
}
