import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



 Future<String> getUserEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final email = userDoc.data()?['email'];
        return email;
      }
    }
    return 'Nie można pobrać id';
}