import 'package:cloud_firestore/cloud_firestore.dart';
import '../features/builder/models/resume_data.dart';

/// Firestore service for data persistence
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference
  CollectionReference get _usersCollection => _firestore.collection('users');

  /// Save or update user's resume data
  Future<void> saveUserData(String userId, ResumeData resumeData) async {
    try {
      await _usersCollection.doc(userId).set({
        'userId': userId,
        'updatedAt': FieldValue.serverTimestamp(),
        'resumeData': resumeData.toJson(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving user data: $e');
      rethrow;
    }
  }

  /// Load user's resume data
  Future<ResumeData?> loadUserData(String userId) async {
    try {
      DocumentSnapshot doc = await _usersCollection.doc(userId).get();

      if (!doc.exists) {
        return null;
      }

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      if (data['resumeData'] != null) {
        return ResumeData.fromJson(data['resumeData']);
      }

      return null;
    } catch (e) {
      print('Error loading user data: $e');
      rethrow;
    }
  }

  /// Delete user's resume data (Reset Data feature)
  Future<void> deleteUserData(String userId) async {
    try {
      await _usersCollection.doc(userId).update({
        'resumeData': FieldValue.delete(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error deleting user data: $e');
      rethrow;
    }
  }

  /// Save user profile info (from Firebase Auth)
  Future<void> saveUserProfile(
    String userId, {
    required String email,
    String? displayName,
    String? photoURL,
  }) async {
    try {
      await _usersCollection.doc(userId).set({
        'userId': userId,
        'email': email,
        'displayName': displayName,
        'photoURL': photoURL,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving user profile: $e');
      rethrow;
    }
  }

  /// Check if user has existing data
  Future<bool> hasExistingData(String userId) async {
    try {
      DocumentSnapshot doc = await _usersCollection.doc(userId).get();

      if (!doc.exists) {
        return false;
      }

      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      return data?['resumeData'] != null;
    } catch (e) {
      print('Error checking existing data: $e');
      return false;
    }
  }
}
