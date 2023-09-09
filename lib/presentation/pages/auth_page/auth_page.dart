import 'package:flutter/material.dart';
import 'package:projekt/presentation/pages/auth_page/auth_page_controller.dart';
import 'package:get/get.dart';

class AuthPage extends StatefulWidget {
  AuthPage({super.key});

  final AuthPageController authPageController = Get.put(AuthPageController());

  @override
  State<AuthPage> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  final authKey = GlobalKey<FormState>();

  String enteredEmail = '';
  String enteredPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [
              0.1,
              0.4,
              0.6,
              0.9,
            ],
            colors: [
              Colors.purple,
              Colors.deepPurple,
              Colors.indigo,
              Colors.teal,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text('MASTER OF COIN APP', style: TextStyle(
                  fontSize: 30,
                ),),
                Card(
                  margin: const EdgeInsets.all(16),
                  //child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: authKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                label: Text('Tutaj wpisz adres e-mail'),
                              ),
                              //autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || GetUtils.isEmail(value)) {
                                  return null;
                                }
                                return 'Podaj poprawny adres e-mail';
                              },
                              textCapitalization: TextCapitalization.none,
                              autocorrect: false,
                              keyboardType: TextInputType.emailAddress,
                              //controller: ,
                              onSaved:(newValue) {
                                enteredEmail = newValue!;
                              },

                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                label: Text('Tutaj wpisz hasło'),
                              ),
                              validator: (value) {
                                if (value == null || value.length < 6){
                                  return 'Hasło musi mieć przynajmiej 6 znaków';
                                }
                                return null;
                              },
                              obscureText: true,
                              onSaved: (newValue) {
                                enteredPassword = newValue!;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  //),
                ),
                Obx(
                  () => Column(
                    children: [
                      FloatingActionButton.extended(
                        onPressed: () {
                          if(authKey.currentState!.validate()){
                            authKey.currentState!.save();
                            widget.authPageController.setEnteredLoginData(enteredEmail, enteredPassword);
                            widget.authPageController.submitLogin();
                          }
                        },
                        label: Text(widget.authPageController.loginState.value
                            ? 'Zaloguj się'
                            : 'Zarejestruj się'),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 30,
                        width: 120,
                        child: FloatingActionButton.small(
                          onPressed: () {
                            widget.authPageController.setLoginState();
                          },
                          child: Text(widget.authPageController.loginState.value
                              ? 'Załóż konto'
                              : 'Już mam konto'),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
