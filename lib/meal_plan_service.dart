import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MealPlanService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveMealPlan(Map<String, dynamic> mealPlan) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('mealPlans')
          .add(mealPlan);
    }
  }

  Future<List<dynamic>> getMealPlans() async {
    final user = _auth.currentUser;
    if (user != null) {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('mealPlans')
          .get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } else {
      return [];
    }
  }

  Future<void> removeMealPlan(String mealPlanId) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('mealPlans')
          .doc(mealPlanId)
          .delete();
    }
  }
}
