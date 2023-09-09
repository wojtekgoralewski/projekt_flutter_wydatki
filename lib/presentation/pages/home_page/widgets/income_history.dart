import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projekt/presentation/pages/home_page/widgets/expense_card.dart';

// class IncomeHistoryPage extends StatefulWidget{
//   IncomeHistoryPage({super.key});

//   @override
//   State<IncomeHistoryPage> createState() {
//     return _IncomeHistoryPage();
//   }
// }

// class _IncomeHistoryPage extends State<IncomeHistoryPage>{
//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }

class IncomeHistoryWidget extends StatelessWidget {
  IncomeHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('money')
            .where('userId', isEqualTo: currentUser!.uid)
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (contex, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Brak histori'));
          }

          var data = snapshot.data!.docs;
          return ListView.builder(
              itemCount: data.length >= 4 ? 4 : data.length,
              itemBuilder: (contex, index) {
                return //SizedBox(height: 80, child:
                    ExpenseCard(data[index].data()['title'],
                        data[index].data()['money'],data[index].data()['time']);
                //);
              });
        });
  }
}
