import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../features/HomeScreen/model/product_details/product_details.dart';
import '../../routes/routes.dart';

class FireStoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> addProduct(ProductDetails product) async {
    try {
      await _db
          .collection('users')
          .doc(user!.uid)
          .collection('products')
          .add(product.toJson());
    } catch (e) {
      debugPrint('Error adding product: $e');
    }
  }

  Future<List<ProductDetails>> fetchProducts() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('users')
          .doc(user!.uid)
          .collection('products').get();
      return querySnapshot.docs
          .map((doc) =>
              ProductDetails.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error fetching products: $e');
      return [];
    }
  }

  Future<int> countProducts() async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('users')
          .doc(user!.uid)
          .collection('products')
          .get();
      debugPrint('Count: ${querySnapshot.docs.length}');
      return querySnapshot.docs.length;
    } catch (e) {
      debugPrint('Error counting products: $e');
      return 0;
    }
  }

  Future<bool> doesProductExist(ProductDetails product) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('users')
          .doc(user!.uid)
          .collection('products')
          .where('id', isEqualTo: product.id)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking product existence: $e');
      return false;
    }
  }
}
