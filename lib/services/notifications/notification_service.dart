import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;
import '../../core/config/app_config.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    tz_data.initializeTimeZones();
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        // Navigate to journal - handled via go_router deep link
      },
    );
    _initialized = true;

    // Request permission Android 13+
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
  }

  Future<void> scheduleDailyReminder({
    required String userName,
    int hour = AppConfig.defaultReminderHour,
    int minute = AppConfig.defaultReminderMinute,
    List<int> weekdays = const [1, 2, 3, 4, 5], // Mon-Fri
  }) async {
    if (!_initialized) await initialize();
    await cancelDailyReminder();

    final title = AppConfig.defaultNotificationTitle.replaceAll('{name}', userName.isEmpty ? 'toi' : userName);
    const androidDetails = AndroidNotificationDetails(
      AppConfig.notificationChannelId,
      AppConfig.notificationChannelName,
      channelDescription: AppConfig.notificationChannelDesc,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const details = NotificationDetails(android: androidDetails);

    for (final weekday in weekdays) {
      await _plugin.zonedSchedule(
        100 + weekday, // unique id per weekday
        'Rapport+',
        title,
        _nextInstanceOfWeekday(hour, minute, weekday),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  tz.TZDateTime _nextInstanceOfWeekday(int hour, int minute, int weekday) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    while (scheduled.weekday != weekday || scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  Future<void> cancelDailyReminder() async {
    for (int i = 101; i <= 107; i++) {
      await _plugin.cancel(i);
    }
  }

  Future<void> showInstantTestNotification(String userName) async {
    if (!_initialized) await initialize();
    const androidDetails = AndroidNotificationDetails(
      AppConfig.notificationChannelId,
      AppConfig.notificationChannelName,
      importance: Importance.high,
      priority: Priority.high,
    );
    await _plugin.show(
      999,
      'Rapport+',
      AppConfig.defaultNotificationTitle.replaceAll('{name}', userName.isEmpty ? 'toi' : userName),
      const NotificationDetails(android: androidDetails),
    );
  }

  Future<bool> areNotificationsEnabled() async {
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    return await android?.areNotificationsEnabled() ?? false;
  }
}
