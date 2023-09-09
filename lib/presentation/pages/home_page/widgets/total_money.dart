import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TotalMoney extends StatelessWidget {
  const TotalMoney({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      //snapshots da stream i ustawi listener do money w bazie danych
      // kiedy nowy dokument jest dodany flutter zostanie poinformowany
      // i znowu uruchomi sie builder
      stream: FirebaseFirestore.instance
      .collection('money')
      .where('userId', isEqualTo: currentUser!.uid)
      .snapshots(),
      builder: (ctx, moneySnapshots) {
        if (moneySnapshots.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!moneySnapshots.hasData || moneySnapshots.data!.docs.isEmpty) {
          return const Center(child: Text('0 :(('));
        }

        final loadedMoney = moneySnapshots.data!.docs;
        int totalSum = 0;

        for (var i = 0; i < loadedMoney.length; i++) {
          String individualSum = loadedMoney[i]['money'];
          totalSum = totalSum + int.parse(individualSum);
        }

        return Text(
          '${totalSum.toString()} zł',
          style: const TextStyle(
            color: Color.fromARGB(255, 3, 141, 8), // Set the text color
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }
}
