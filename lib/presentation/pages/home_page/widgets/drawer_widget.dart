import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projekt/presentation/pages/extracted_history_page/extracted_history_page.dart';
import 'package:projekt/presentation/pages/income_history_page/income_history_page.dart';
import 'package:projekt/presentation/pages/raport_page/raport_page.dart';
// import 'package:get/get.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(child: 
      Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.cyan.shade700,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              bottom: 10,
            ),
            // TODO : child: Text(getUserEmail()),
          ),
            Expanded(
              child: Container(
                color: Theme.of(context).primaryColorLight,
                padding: const EdgeInsets.only(top: 10),
                child: Wrap(runSpacing: 16, children: [
                  ListTile(
                    leading: const Icon(Icons.analytics_sharp),
                    title: const Text('Raport'),
                    onTap: () {
                      Get.to(() => const RaportPage());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text('Pełna historia zarobków'),
                    onTap: () {
                      //Navigator.pushNamed(context, '/extractedHistoryPage');
                      Get.to(() => const IncomeHistoryPage());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.history_edu),
                    title: const Text('Pełna historia wydatków'),
                    onTap: () {
                      Get.to(() => const ExtractedHistoryPage());
                    },
                  ),
                  const Divider(color: Colors.black),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Wyloguj się'),
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                    },
                  ),
                ]),
              ),
            ),
        ],
      )
    );
  }
}
