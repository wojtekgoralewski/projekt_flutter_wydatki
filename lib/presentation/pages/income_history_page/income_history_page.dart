import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projekt/presentation/pages/home_page/widgets/expense_card.dart';

class IncomeHistoryPage extends StatelessWidget {
  const IncomeHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historia zarobków'),
        backgroundColor: Colors.cyan.shade700,
      ),
      body: StreamBuilder(
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

            var isUndoEnabled = true;
            var data = snapshot.data!.docs;

            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (contex, index) {
                  return Dismissible(
                    key: ValueKey(data[index].id),
                    onDismissed: (direction) {
                      try {
                        var backupData = data[index].data();
                        FirebaseFirestore.instance
                            .collection('money')
                            .doc(data[index].id)
                            .delete();
                        Get.snackbar('Sukces: ', 'Usunięcie powiodło się',
                            mainButton: TextButton(
                                onPressed:() {
                                  if(isUndoEnabled == true){
                                  FirebaseFirestore.instance
                                      .collection('money')
                                      .add(backupData);
                                  isUndoEnabled = false ;
                                  Get.closeCurrentSnackbar();
                                  } else {
                                    null;
                                  }
                                },
                                child: const Text(
                                  'Cofnij',
                                  style: TextStyle(color: Colors.black),
                                )),
                            duration: const Duration(seconds: 3),
                            messageText: const Text(
                              'Usunięcie powiodło się',
                              style: TextStyle(color: Colors.white),
                            ));
                      } catch (error) {
                        Get.snackbar('Error: ', 'Usunięcie nie powiodło się',
                            messageText: const Text(
                              'Usunięcie nie powiodło się',
                              style: TextStyle(color: Colors.white),
                            ));
                      }
                    },
                    child: ExpenseCard(
                        data[index].data()['title'],
                        data[index].data()['money'],
                        data[index].data()['time']),
                  );
                });
          }),
    );
  }
}
