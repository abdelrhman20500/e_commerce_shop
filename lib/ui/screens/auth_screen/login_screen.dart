import 'package:e_commerce_shop/ui/screens/auth_screen/register_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../widgets/alert_dialog.dart';
import '../../../widgets/login_text_field.dart';
import '../../utils/app_color.dart';
import 'auth_cubit/auth_cubit.dart';
import 'auth_cubit/auth_state.dart';


class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height= MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: Scaffold(
        body: BlocConsumer<AuthCubit,AuthStates>(
          listener: (context,state)
          {
            if( state is LoginLoadingState )
            {
              showAlertDialog(
                  context: context,
                  backgroundColor: Colors.white,
                  content: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeIn,
                    child: const Row(
                      children:
                      [
                        CupertinoActivityIndicator(color: mainColor),
                        SizedBox(width: 12.5,),
                        Text("wait",style: TextStyle(fontWeight: FontWeight.w500),),
                      ],
                    ),
                  )
              );
            }
            else if( state is LoginFailureState )
            {
              showAlertDialog(
                  context: context,
                  backgroundColor: Colors.red,
                  content: Text(state.message,textDirection: TextDirection.rtl,)
              );
            }
            else if ( state is LoginSuccessState )
            {
              Navigator.pop(context);   // عشان يخرج من alertDialog
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LayoutScreen()));
            }
          },
          builder: (context,state){
            return Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children:
                  [
                    SizedBox(height: height*0.3,),
                    const Center(child: Text("Login",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19),)),
                    TextFieldWidget(
                      controller: emailController,
                      hint: "Email",
                    ),
                    const SizedBox(height: 15,),
                    TextFieldWidget(
                      controller: passwordController,
                      obscureText: false,
                      hint: "Password",
                    ),
                    const SizedBox(height: 15,),
                    const SizedBox(height: 25,),
                    MaterialButton(
                      height: 40,
                      elevation: 0,
                      onPressed: ()
                      {
                        if( formKey.currentState!.validate() == true )
                        {
                          BlocProvider.of<AuthCubit>(context).login(
                              email: emailController.text,
                              password: passwordController.text
                          );
                          // authCubit.login(email: emailController.text, password: passwordController.text,);
                        }
                      },
                      minWidth: double.infinity,
                      color: mainColor,
                      textColor: Colors.white,
                      child: FittedBox(fit:BoxFit.scaleDown,child: Text(state is LoginLoadingState ? "Loading..." : "Login",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16.5),)),
                    ),
                    const SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                      [
                        const Text('Don\'t have an account? ',style: TextStyle(color: Colors.black)),
                        const SizedBox(width: 4,),
                        InkWell(
                          onTap: ()
                          {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                          },
                          child: const Text('Create one',style: TextStyle(color: mainColor,fontWeight: FontWeight.bold)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}