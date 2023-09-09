// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projekt/presentation/pages/home_page/widgets/extracted_history.dart';
import 'package:projekt/presentation/pages/home_page/home_page_controller.dart';
import 'package:projekt/presentation/pages/home_page/widgets/income_history.dart';
import 'package:projekt/presentation/pages/home_page/widgets/drawer_widget.dart';
// import 'package:projekt/presentation/widgets/expense_card.dart';
import 'package:projekt/presentation/pages/home_page/widgets/extracted_money.dart';
import 'package:projekt/presentation/pages/home_page/widgets/total_money.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  final HomePageController homePageController = Get.put(HomePageController());

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  var newMoneyKey = GlobalKey<FormState>();
  var extractMoneyKey = GlobalKey<FormState>();

  String newMoneyTitle = '';
  String newMoneyValue = '';

  String extractMoneyTitle = '';
  String extractMoneyValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Master of Coin'),
        backgroundColor: Colors.cyan.shade700,
        actions: [
          IconButton(onPressed: () {
          }, icon: const Icon(Icons.add)),
        ],
      ),
      drawer: const MyDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                'Suma wszystkich dochodów',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: 150.0, // Set the width of the square card
                        height: 100, // Set the height of the square card
                        child: Card(
                          elevation: 5, // Add elevation (shadow) if desired
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Adjust the radius as needed
                          ),
                          color: Colors.blue.shade100,
                          child: const Center(
                            child: TotalMoney(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 30,
                        width: 120,
                        child: FloatingActionButton.small(
                          heroTag: 'income',
                          onPressed: () {
                            if (newMoneyKey.currentState!.validate()) {
                              newMoneyKey.currentState!.save();
                              widget.homePageController
                                  .newMoneyData(newMoneyValue, newMoneyTitle);
                              widget.homePageController.submitMoney(context);
                              newMoneyKey.currentState!.reset();
                            }
                          },
                          child: const Text('Dodaj pieniądze'),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Card(
                          margin: const EdgeInsets.all(16),
                          //child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Form(
                              key: newMoneyKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    //controller: homePageController.newMoneyController,
                                    decoration: const InputDecoration(
                                      label: Text('Tytuł zarobku'),
                                    ),
                                    //autovalidateMode: AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Pole nie może być puste';
                                      }
                                      return null;
                                    },
                                    onSaved: (newValue) {
                                      newMoneyTitle = newValue!;
                                    },
                                  ),
                                  TextFormField(
                                    //controller: homePageController.newMoneyController,
                                    decoration: const InputDecoration(
                                      label: Text('Ilość pieniędzy'),
                                      suffixText: 'zł ',
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Pole nie może być puste';
                                      }
                                      return null;
                                    },
                                    onSaved: (newValue) {
                                      newMoneyValue = newValue!;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 150, child: IncomeHistoryWidget()),
              const SizedBox(height: 20),
              const Divider(color: Colors.black),
              const SizedBox(height: 10),
              const Text(
                'Suma wszystkich wydatków',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: 150.0,
                        height: 100,
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Colors.blue.shade100,
                          child: const Center(
                            child: ExtractedMoney(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 30,
                        width: 120,
                        child: FloatingActionButton.small(
                          heroTag: 'extract',
                          onPressed: () {
                            if (extractMoneyKey.currentState!.validate()) {
                              extractMoneyKey.currentState!.save();
                              widget.homePageController.extractMoneyData(
                                  extractMoneyValue, extractMoneyTitle);
                              widget.homePageController.extractMoney(context);
                              extractMoneyKey.currentState!.reset();
                            }
                          },
                          child: const Text('Dodaj wydatek'),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Card(
                          margin: const EdgeInsets.all(16),
                          //child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Form(
                              key: extractMoneyKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      label: Text('Tytuł wydatku'),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Pole nie może być puste';
                                      }
                                      return null;
                                    },
                                    onSaved: (newValue) {
                                      extractMoneyTitle = newValue!;
                                    },
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      label: Text('Ilość pieniędzy'),
                                      suffixText: 'zł ',
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Pole nie może być puste';
                                      }
                                      return null;
                                    },
                                    onSaved: (newValue) {
                                      extractMoneyValue = newValue!;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 150,child: ExtractHistoryWidget()),
            ],
          ),
        ),
      ),
    );
  }
}
