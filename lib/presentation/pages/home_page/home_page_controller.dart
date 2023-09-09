import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePageController extends GetxController {
  String extractMoneyTitle = '';
  String extractMoneyValue = '';

  String newMoneyTitle = '';
  String newMoneyValue = '';
  //final newMoneyController = TextEditingController();

  void newMoneyData(String money, String title) {
    newMoneyTitle = title;
    newMoneyValue = money;
  }

  void submitMoney(BuildContext context) async {
    if (newMoneyValue.trim().isEmpty) {
      return;
    }
    //zamkniecie klawiatury po wpisaniu wartosci i jej sprawdzeniu
    FocusScope.of(context).unfocus();
    //newMoneyController.clear();

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    FirebaseFirestore.instance.collection('money').add({
      'money': newMoneyValue,
      'title': newMoneyTitle,
      'userId': user.uid,
      'time': Timestamp.now(),
      'userEmail': userData.data()!['email'],
    });
    Get.snackbar('Sukces: ', 'Dodano pieniądze',
        duration: const Duration(seconds: 2),
        messageText: const Text(
          'Dodano pieniądze',
          style: TextStyle(color: Colors.white),
        ));
  }

  void extractMoneyData(String money, String title) {
    extractMoneyTitle = title;
    extractMoneyValue = money;
  }

  void extractMoney(BuildContext context) async {
    if (extractMoneyValue.trim().isEmpty) {
      return;
    }
    //zamkniecie klawiatury po wpisaniu wartosci i jej sprawdzeniu
    FocusScope.of(context).unfocus();

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    FirebaseFirestore.instance.collection('negativeMoney').add({
      'money': extractMoneyValue,
      'title': extractMoneyTitle,
      'userId': user.uid,
      'time': Timestamp.now(),
      'userEmail': userData.data()!['email'],
    });
    Get.snackbar('Sukces: ', 'Dodano wydatek',
        duration: const Duration(seconds: 2),
        messageText: const Text(
          'Dodano wydatek',
          style: TextStyle(color: Colors.white),
        ));
  }
}
