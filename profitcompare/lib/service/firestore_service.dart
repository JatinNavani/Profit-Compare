import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String get uid {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'NO_USER',
        message: 'No user is currently logged in.',
      );
    }
    return user.uid;
  }

  /// Saves an investment under a specific asset class for the current user.
  Future<void> saveInvestment({
    required String assetClass, // e.g., "fixed_income", "equity", "alternate"
    required String name,       // e.g., "FD in SBI"
    required double amount,
    required String date,       // e.g., "2024-12-01"
    required String notes,
  }) async {
    try {
      await _db
          .collection('users')
          .doc(uid)
          .collection(assetClass)
          .add({
            'name': name,
            'amount': amount,
            'date': date,
            'notes': notes,
            'timestamp': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      print('🔥 Firestore Save Error: $e');
      rethrow;
    }
  }
}
