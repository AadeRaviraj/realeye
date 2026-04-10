// ============================================================
// File     : lib/services/notification_service.dart
// Description: Handles local notifications — enable/disable toggle,
//              daily reminder scheduling, permission requests.
// pubspec dependency needed:
//   flutter_local_notifications: ^17.0.0
//   timezone: ^0.9.4
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'dart:io';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _prefKey = 'notifications_enabled';
  static const int _dailyReminderId = 1001;

  // ── Initialize ─────────────────────────────────────────────
  Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      const InitializationSettings(
          android: androidSettings, iOS: iosSettings),
    );
  }

  // ── Request Permission ─────────────────────────────────────
  Future<bool> requestPermission() async {
    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    final granted = await androidPlugin?.requestNotificationsPermission();
    return granted ?? false;
  }

  // ── Check if enabled (saved preference) ───────────────────
  Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefKey) ?? false;
  }

  // ── Enable Notifications ───────────────────────────────────
  Future<void> enable() async {
    final prefs = await SharedPreferences.getInstance();

    // Request permission first
    await requestPermission();

    // Schedule daily reminder at 9:00 AM
    await _scheduleDailyReminder();

    await prefs.setBool(_prefKey, true);
  }

  // ── Disable Notifications ──────────────────────────────────
  Future<void> disable() async {
    final prefs = await SharedPreferences.getInstance();
    await _plugin.cancel(_dailyReminderId);
    await prefs.setBool(_prefKey, false);
  }

  // ── Toggle ─────────────────────────────────────────────────
  Future<void> toggle(bool enable) async {
    if (enable) {
      await this.enable();
    } else {
      await disable();
    }
  }

  // ── Schedule Daily Reminder ────────────────────────────────

  Future<void> _scheduleDailyReminder() async {
    // Create channel once (preferably in initialize())
    await _createNotificationChannels();

    const androidDetails = AndroidNotificationDetails(
      'NavaVeda_daily',
      'Daily Reminders',
      channelDescription: 'Daily study reminders from NavaVeda',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    // For Android, use inexact mode (no exact alarm permission needed)
    final androidScheduleMode = Platform.isAndroid
        ? AndroidScheduleMode.inexact
        : AndroidScheduleMode.exactAllowWhileIdle;

    await _plugin.zonedSchedule(
      _dailyReminderId,
      '📚 Time to Study!',
      'Keep your streak alive — open NavaVeda and learn something new today!',
      _nextInstanceOfTime(9, 0),
      details,
      androidScheduleMode: androidScheduleMode,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

// Helper to create notification channels (optional but recommended)
  Future<void> _createNotificationChannels() async {
    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        'realeye_daily',
        'Daily Reminders',
        description: 'Daily study reminders from NavaVeda',
        importance: Importance.high,
      );
      await _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
    }
  }

// Modify test notification to use the same channel
  Future<void> showTestNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'realeye_daily',  // use the same channel
      'Daily Reminders',
      channelDescription: 'Daily study reminders from NavaVeda',
      importance: Importance.high,
      priority: Priority.high,
    );
    await _plugin.show(
      0,
      'NavaVeda Notifications',
      'Notifications are now enabled! 🎉',
      const NotificationDetails(android: androidDetails),
    );
  }
  // Helper: next 9:00 AM
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  // ── Show Immediate Notification (for testing) ──────────────
  // Future<void> showTestNotification() async {
  //   const androidDetails = AndroidNotificationDetails(
  //     'realeye_test',
  //     'Test',
  //     channelDescription: 'Test notification',
  //     importance: Importance.high,
  //     priority: Priority.high,
  //   );
  //   await _plugin.show(
  //     0,
  //     'Realeye Notifications',
  //     'Notifications are now enabled! 🎉',
  //     const NotificationDetails(android: androidDetails),
  //   );
  // }
}
