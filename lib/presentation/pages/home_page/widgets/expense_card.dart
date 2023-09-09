import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExpenseCard extends StatelessWidget{
  const ExpenseCard(this.text,this.amount,this.time,{super.key});

  final String text;
  final String amount;
  final Timestamp time;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
          margin: const EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 20),
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Adjust the radius to match the container
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Add padding inside the card
            child:Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(text, style: const TextStyle(fontSize: 16)),
                    Text('${time.toDate().year.toString()}-${time.toDate().month.toString()}-${time.toDate().day.toString()}',
                     style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              const Spacer(),
              Text('$amount zł', style: const TextStyle(fontSize: 16)),
            ],),
            ),
          ),
    );
  }
}