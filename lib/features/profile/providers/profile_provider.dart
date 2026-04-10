// // ============================================================
// // File     : lib/features/profile/providers/profile_provider.dart
// // ============================================================
//
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:navaveda/models/dashboard_data.dart';
// import 'package:navaveda/models/DailyStat.dart';
// import 'package:navaveda/services/api_service.dart';
//
// class ProfileProvider extends ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final DatabaseReference _dbRef =
//       FirebaseDatabase.instance.ref().child('users');
//
//   // ── User Info ──────────────────────────────────────────────
//   String userName = '';
//   String userEmail = '';
//   String userRole = '';
//   String? profileImageUrl;
//   bool isLoadingUser = true;
//
//   // ── Dashboard ──────────────────────────────────────────────
//   DashboardData? dashboardData;
//   bool isLoadingDashboard = false;
//   String? dashboardError;
//
//   String? get firebaseUid => _auth.currentUser?.uid;
//
//   ProfileProvider() {
//     _listenToUserData();
//     loadDashboard();
//   }
//   // ProfileProvider() {
//   // _auth.authStateChanges().listen((user) {
//   // if (user != null) {
//   // _listenToUserData();
//   // loadDashboard();     // refresh dashboard
//   // } else {
//   // userName = '';
//   // profileImageUrl = null;
//   // isLoadingUser = false;
//   // notifyListeners();
//   // }
//   // });
//
//   void _listenToUserData() {
//     final user = _auth.currentUser;
//     if (user == null) return;
//     userEmail = user.email ?? '';
//
//     _dbRef.child(user.uid).onValue.listen((event) {
//       final snap = event.snapshot;
//       if (snap.exists) {
//         userName = snap.child('full_name').value?.toString() ?? '';
//         userRole = snap.child('role').value?.toString() ?? '';
//         profileImageUrl = snap.child('profile_image').value?.toString();
//         isLoadingUser = false;
//         notifyListeners();
//       }
//     });
//   }
//
//   Future<void> loadDashboard() async {
//     final uid = firebaseUid;
//     if (uid == null) return;
//     isLoadingDashboard = true;
//     dashboardError = null;
//     notifyListeners();
//     try {
//       dashboardData = await ApiService.fetchDashboard(uid);
//     } catch (e) {
//       dashboardError = e.toString();
//     } finally {
//       isLoadingDashboard = false;
//       notifyListeners();
//     }
//   }
//
//   Future<List<DailyStat>> fetchDailyStats(String range) async {
//     final uid = firebaseUid;
//     if (uid == null) return [];
//     return await ApiService.fetchDailyStats(uid, range: range);
//   }
//
//   void updateProfileImage(String url) {
//     profileImageUrl = url;
//     notifyListeners();
//   }
//
//   void updateName(String name) {
//     userName = name;
//     notifyListeners();
//   }
// }

// ============================================================
// File     : lib/features/profile/providers/profile_provider.dart
// ============================================================

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:navaveda/models/dashboard_data.dart';
import 'package:navaveda/models/DailyStat.dart';
import 'package:navaveda/services/api_service.dart';

class ProfileProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef =
  FirebaseDatabase.instance.ref().child('users');

  // ── User Info ──────────────────────────────────────────────
  String userName = '';
  String userEmail = '';
  String userRole = '';
  String? profileImageUrl;
  bool isLoadingUser = false;

  // ── Dashboard ──────────────────────────────────────────────
  DashboardData? dashboardData;
  bool isLoadingDashboard = false;
  String? dashboardError;

  String? get firebaseUid => _auth.currentUser?.uid;

  ProfileProvider() {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        // New user logged in — reload everything fresh
        _listenToUserData();
        loadDashboard();
      } else {
        // User logged out — clear all stale data
        userName = '';
        userEmail = '';
        userRole = '';
        profileImageUrl = null;
        dashboardData = null;
        dashboardError = null;
        isLoadingUser = false;
        isLoadingDashboard = false;
        notifyListeners();
      }
    });
  }


  Future<void> refreshUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;

    isLoadingUser = true;
    notifyListeners();

    try {
      // Force a fresh read from Firebase Database
      final snapshot = await _dbRef.child(user.uid).get();
      if (snapshot.exists) {
        userName = snapshot.child('full_name').value?.toString() ?? '';
        userRole = snapshot.child('role').value?.toString() ?? '';
        profileImageUrl = snapshot.child('profile_image').value?.toString();
      }
      await loadDashboard(); // also refresh dashboard
    } catch (e) {
      // handle error if needed
    } finally {
      isLoadingUser = false;
      notifyListeners();
    }
  }

  void _listenToUserData() {
    final user = _auth.currentUser;
    if (user == null) return;
    userEmail = user.email ?? '';
    isLoadingUser = true;
    notifyListeners();

    _dbRef.child(user.uid).onValue.listen((event) {
      final snap = event.snapshot;
      if (snap.exists) {
        userName = snap.child('full_name').value?.toString() ?? '';
        userRole = snap.child('role').value?.toString() ?? '';
        profileImageUrl = snap.child('profile_image').value?.toString();
        isLoadingUser = false;
        notifyListeners();
      }
    });
  }

  Future<void> loadDashboard() async {
    final uid = firebaseUid;
    if (uid == null) return;
    isLoadingDashboard = true;
    dashboardError = null;
    notifyListeners();
    try {
      dashboardData = await ApiService.fetchDashboard(uid);
    } catch (e) {
      dashboardError = e.toString();
    } finally {
      isLoadingDashboard = false;
      notifyListeners();
    }
  }

  Future<List<DailyStat>> fetchDailyStats(String range) async {
    final uid = firebaseUid;
    if (uid == null) return [];
    return await ApiService.fetchDailyStats(uid, range: range);
  }

  void updateProfileImage(String url) {
    profileImageUrl = url;
    notifyListeners();
  }

  void updateName(String name) {
    userName = name;
    notifyListeners();
  }
}
