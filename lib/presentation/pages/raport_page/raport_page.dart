import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projekt/presentation/pages/home_page/widgets/expense_card.dart';

class RaportPage extends StatelessWidget {
  const RaportPage({super.key});


  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
     String sign = '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Raport'),
        backgroundColor: Colors.cyan.shade700,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('money')
                  .where('userId', isEqualTo: currentUser!.uid)
                  .snapshots(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('0 :(('));
                }

                final loadedMoney = snapshot.data!.docs;
                int totalSum = 0;

                for (var i = 0; i < loadedMoney.length; i++) {
                  String individualSum = loadedMoney[i]['money'];
                  totalSum = totalSum + int.parse(individualSum);
                }

                return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('negativeMoney')
                      .where('userId', isEqualTo: currentUser.uid)
                      .snapshots(),
                  builder: (ctx, moneySnapshots) {
                    if (moneySnapshots.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!moneySnapshots.hasData ||
                        moneySnapshots.data!.docs.isEmpty) {
                      return const Center(child: Text('0 :))'));
                    }

                    final loadedNegativeMoney = moneySnapshots.data!.docs;
                    int totalNegativeSum = 0;

                    for (var i = 0; i < loadedNegativeMoney.length; i++) {
                      String individualSum = loadedNegativeMoney[i]['money'];
                      totalNegativeSum =
                          totalNegativeSum + int.parse(individualSum);
                    }

                    int balance = totalSum - totalNegativeSum;
                    if(balance > 0){
                      sign = '+';
                    }

                    return Column(
                      children: [
                        const Text(
                          'Balans wydatków i zarobków',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 20, right: 20),
                          height: 80,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.6),
                                spreadRadius: 5, 
                                blurRadius: 5, 
                                offset: const Offset(0, 5), 
                              ),
                            ],
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(colors: [
                              Colors.teal,
                              Colors.deepPurple,
                            ]),
                          ),
                          child: Center(
                            child: Text('$sign${balance.toString()} zł',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                );
              }),
              //--------------------------MaxIncome
          const Divider(color: Colors.black),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('money')
                  .where('userId', isEqualTo: currentUser.uid)
                  .snapshots(),
              builder: (contex, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Brak zarobków'));
                }

                final loadedMoney = snapshot.data!.docs;
                int maxSum = 0;
                QueryDocumentSnapshot<Map<String, dynamic>> max =
                    loadedMoney[0];

                for (var i = 0; i < loadedMoney.length; i++) {
                  String individualSum = loadedMoney[i]['money'];
                  int parsedIndividualSum = int.parse(individualSum);
                  //totalSum = totalSum + int.parse(individualSum);
                  if (parsedIndividualSum >= maxSum) {
                    maxSum = parsedIndividualSum;
                    max = loadedMoney[i];
                  } else {
                    continue;
                  }
                }
                return Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        'Najwyższy zarobek',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      ExpenseCard(
                          '${max['title']}', '${max['money']}', max['time']),
                    ],
                  ),
                );
              }),
              //--------------------MaxExpense
          const Divider(color: Colors.black),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('negativeMoney')
                  .where('userId', isEqualTo: currentUser.uid)
                  .snapshots(),
              builder: (contex, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Brak wydatków'));
                }

                final loadedMoney = snapshot.data!.docs;
                int maxSum = 0;
                QueryDocumentSnapshot<Map<String, dynamic>> max =
                    loadedMoney[0];

                for (var i = 0; i < loadedMoney.length; i++) {
                  String individualSum = loadedMoney[i]['money'];
                  int parsedIndividualSum = int.parse(individualSum);
                  //totalSum = totalSum + int.parse(individualSum);
                  if (parsedIndividualSum >= maxSum) {
                    maxSum = parsedIndividualSum;
                    max = loadedMoney[i];
                  } else {
                    continue;
                  }
                }
                return Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        'Najwyższy wydatek',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      ExpenseCard(
                          '${max['title']}', '${max['money']}', max['time']),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
