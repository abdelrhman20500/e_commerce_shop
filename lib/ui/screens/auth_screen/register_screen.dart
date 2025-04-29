import 'package:e_commerce_shop/widgets/text_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../widgets/alert_dialog.dart';
import '../../utils/app_color.dart';
import 'auth_cubit/auth_cubit.dart';
import 'auth_cubit/auth_state.dart';
import 'login_screen.dart';


class RegisterScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit,AuthStates>(
        listener: (context,state){
          if( state is RegisterLoadingState )
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
          else if( state is RegisterFailureState)
          {
            showAlertDialog(
                context: context,
                backgroundColor: Colors.red,
                content: Text(state.message,textDirection: TextDirection.rtl,)
            );
          }
          else if ( state is RegisterSuccessState )
          {
            Navigator.pop(context);   // عشان يخرج من alertDialog
            print("success");
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
          }
        },
        builder: (context,state){
          return Scaffold(
            appBar: AppBar(backgroundColor: Colors.transparent,elevation: 0,leading: const Text(""),),
            body: Center(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                        [
                          const Text("Sign Up",style: TextStyle(fontSize: 22.5,fontWeight: FontWeight.bold),),
                          const SizedBox(height: 30,),
                          CustomTextFormItem(hintTitle: "User Name", controller: nameController),
                          const SizedBox(height: 20,),
                          CustomTextFormItem(hintTitle: "Email", controller: emailController),
                          const SizedBox(height: 20,),
                          CustomTextFormItem(hintTitle: "Phone", controller: phoneController),
                          const SizedBox(height: 20,),
                          CustomTextFormItem(hintTitle: "Password", controller: passwordController),
                          const SizedBox(height: 20,),
                          MaterialButton(
                            minWidth: double.infinity,
                            elevation: 0,
                            height: 40,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)
                            ),
                            color: mainColor,
                            onPressed: ()
                            {
                              if( formKey.currentState!.validate() == true )
                              {
                                BlocProvider.of<AuthCubit>(context).register(
                                    email: emailController.text,
                                    name: nameController.text,
                                    phone: phoneController.text,
                                    password: passwordController.text
                                );
                              }
                            },
                            child: FittedBox(fit:BoxFit.scaleDown,child: Text(state is RegisterLoadingState ? "Loading..." : "Register",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16.5,color: Colors.white),)),
                          ),
                          const SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                            [
                              const Text('Already have an account? ',style: TextStyle(color: Colors.black)),
                              const SizedBox(width: 4,),
                              InkWell(
                                onTap: ()
                                {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                },
                                child: const Text('login in',style: TextStyle(color: mainColor,fontWeight: FontWeight.bold)),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
              ),
            ),
          );
        },
      ),
    );
  }
}