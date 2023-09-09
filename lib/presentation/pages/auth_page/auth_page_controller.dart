import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Daje dostęp do firebase
final firebase = FirebaseAuth.instance;


class AuthPageController extends GetxController{
  var email = ''.obs;
  RxBool loginState = true.obs;

  String enteredEmail = '';
  String enteredPassword = '';


  void setLoginState(){
    loginState.value = !loginState.value;
  }

  void setEnteredLoginData(String email, String password){
    enteredEmail = email;
    enteredPassword = password;
  }
  
  void submitLogin() async {
    if (loginState.value){
      // logowanie
      try{
        
        await firebase.signInWithEmailAndPassword(email: enteredEmail, password: enteredPassword);
      } on FirebaseAuthException{
        Get.snackbar('Error: ', 'Nie udało się zalogować. Sprawdź czy podałeś poprawne dane',
        messageText: const Text('Nie udało się zalogować. Sprawdź czy podałeś poprawne dane',
        style: TextStyle(color: Colors.white),)
        );
      }
      // rejestracja
    } else {
      try {
        await firebase.createUserWithEmailAndPassword(
        email: enteredEmail, 
        password: enteredPassword);
        Get.snackbar('Sukces', 'Konto zostało założone poprawnie',
        messageText: const Text('Konto zostało założone poprawnie',
        style: TextStyle(color: Colors.white),),);
        //firestore pracuje z 'kolekcjami danych' do
        //ktorych mozemy sie odwolywac
        
        await FirebaseFirestore.instance
        .collection('users') // kolekcji users
        .doc(FirebaseAuth.instance.currentUser!.uid) // nazwa pliku
        .set({
          'email' : enteredEmail,
        }); // dane pliku

      } on FirebaseAuthException{
        Get.snackbar('Error: ', 'Adres e-mail jest zajęty',
        messageText: const Text('Adres e-mail jest zajęty',
        style: TextStyle(color: Colors.white),)
        );
      }
    }


  }

}