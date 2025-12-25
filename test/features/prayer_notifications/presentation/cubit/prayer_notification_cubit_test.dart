import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ramadan_app/features/home/domain/prayer_times_entity.dart';
import 'package:ramadan_app/features/prayer_notifications/data/datasources/prayer_notification_local_datasource.dart';
import 'package:ramadan_app/features/prayer_notifications/domain/entities/prayer_notification_settings.dart';
import 'package:ramadan_app/features/prayer_notifications/presentation/cubit/prayer_notification_cubit.dart';
import 'package:ramadan_app/features/prayer_notifications/presentation/cubit/prayer_notification_state.dart';
import 'package:ramadan_app/features/prayer_notifications/services/prayer_notification_service.dart';

class MockPrayerNotificationLocalDatasource extends Mock
    implements PrayerNotificationLocalDatasource {}

class MockPrayerNotificationService extends Mock
    implements IPrayerNotificationService {}

class FakePrayerTimesEntity extends Fake implements PrayerTimesEntity {}

void main() {
  late PrayerNotificationCubit cubit;
  late MockPrayerNotificationLocalDatasource mockDatasource;
  late MockPrayerNotificationService mockNotificationService;

  const defaultSettings = PrayerNotificationSettings();

  setUpAll(() {
    registerFallbackValue(PrayerType.fajr);
    registerFallbackValue(FakePrayerTimesEntity());
    registerFallbackValue(const PrayerNotificationSettings());
  });

  setUp(() {
    mockDatasource = MockPrayerNotificationLocalDatasource();
    mockNotificationService = MockPrayerNotificationService();
    cubit = PrayerNotificationCubit(
      localDatasource: mockDatasource,
      notificationService: mockNotificationService,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('PrayerNotificationCubit', () {
    test('initial state should be PrayerNotificationInitial', () {
      expect(cubit.state, const PrayerNotificationInitial());
    });

    group('loadSettings', () {
      blocTest<PrayerNotificationCubit, PrayerNotificationState>(
        'emits [Loading, Loaded] when settings are loaded successfully',
        build: () {
          when(() => mockDatasource.getSettings())
              .thenAnswer((_) async => defaultSettings);
          when(() => mockDatasource.areNotificationsScheduledForToday())
              .thenAnswer((_) async => false);
          return cubit;
        },
        act: (cubit) => cubit.loadSettings(),
        expect: () => [
          const PrayerNotificationLoading(),
          PrayerNotificationLoaded(
            settings: defaultSettings,
            notificationsScheduled: false,
          ),
        ],
      );

      blocTest<PrayerNotificationCubit, PrayerNotificationState>(
        'emits [Loading, Loaded] with notificationsScheduled=true when scheduled for today',
        build: () {
          when(() => mockDatasource.getSettings())
              .thenAnswer((_) async => defaultSettings);
          when(() => mockDatasource.areNotificationsScheduledForToday())
              .thenAnswer((_) async => true);
          return cubit;
        },
        act: (cubit) => cubit.loadSettings(),
        expect: () => [
          const PrayerNotificationLoading(),
          PrayerNotificationLoaded(
            settings: defaultSettings,
            notificationsScheduled: true,
          ),
        ],
      );

      blocTest<PrayerNotificationCubit, PrayerNotificationState>(
        'emits [Loading, Error] when loading fails',
        build: () {
          when(() => mockDatasource.getSettings())
              .thenThrow(Exception('Test error'));
          return cubit;
        },
        act: (cubit) => cubit.loadSettings(),
        expect: () => [
          const PrayerNotificationLoading(),
          isA<PrayerNotificationError>(),
        ],
      );
    });

    group('togglePrayerNotification', () {
      blocTest<PrayerNotificationCubit, PrayerNotificationState>(
        'does nothing when state is not Loaded',
        build: () => cubit,
        act: (cubit) =>
            cubit.togglePrayerNotification(PrayerType.fajr, false),
        expect: () => [],
      );

      blocTest<PrayerNotificationCubit, PrayerNotificationState>(
        'updates fajr setting and emits new state',
        build: () {
          when(() => mockDatasource.getSettings())
              .thenAnswer((_) async => defaultSettings);
          when(() => mockDatasource.areNotificationsScheduledForToday())
              .thenAnswer((_) async => false);
          when(() => mockDatasource.togglePrayerNotification(any(), any()))
              .thenAnswer((_) async {});
          when(() => mockNotificationService.cancelPrayerNotification(any()))
              .thenAnswer((_) async {});
          return cubit;
        },
        seed: () => PrayerNotificationLoaded(
          settings: defaultSettings,
          notificationsScheduled: true,
        ),
        act: (cubit) =>
            cubit.togglePrayerNotification(PrayerType.fajr, false),
        expect: () => [
          PrayerNotificationLoaded(
            settings: defaultSettings.copyWith(fajrEnabled: false),
            notificationsScheduled: false,
          ),
        ],
        verify: (_) {
          verify(() => mockDatasource.togglePrayerNotification(
              PrayerType.fajr, false)).called(1);
          verify(() => mockNotificationService.cancelPrayerNotification(
              PrayerType.fajr)).called(1);
        },
      );
    });

    group('setPreAlertMinutes', () {
      blocTest<PrayerNotificationCubit, PrayerNotificationState>(
        'does nothing when state is not Loaded',
        build: () => cubit,
        act: (cubit) => cubit.setPreAlertMinutes(10),
        expect: () => [],
      );

      blocTest<PrayerNotificationCubit, PrayerNotificationState>(
        'updates pre-alert minutes and emits new state',
        build: () {
          when(() => mockDatasource.setPreAlertMinutes(any()))
              .thenAnswer((_) async {});
          return cubit;
        },
        seed: () => PrayerNotificationLoaded(
          settings: defaultSettings,
          notificationsScheduled: true,
        ),
        act: (cubit) => cubit.setPreAlertMinutes(10),
        expect: () => [
          PrayerNotificationLoaded(
            settings: defaultSettings.copyWith(preAlertMinutes: 10),
            notificationsScheduled: false,
          ),
        ],
        verify: (_) {
          verify(() => mockDatasource.setPreAlertMinutes(10)).called(1);
        },
      );
    });

    group('toggleSound', () {
      blocTest<PrayerNotificationCubit, PrayerNotificationState>(
        'does nothing when state is not Loaded',
        build: () => cubit,
        act: (cubit) => cubit.toggleSound(false),
        expect: () => [],
      );

      blocTest<PrayerNotificationCubit, PrayerNotificationState>(
        'updates sound setting and emits new state',
        build: () {
          when(() => mockDatasource.toggleSound(any()))
              .thenAnswer((_) async {});
          return cubit;
        },
        seed: () => PrayerNotificationLoaded(
          settings: defaultSettings,
          notificationsScheduled: true,
        ),
        act: (cubit) => cubit.toggleSound(false),
        expect: () => [
          PrayerNotificationLoaded(
            settings: defaultSettings.copyWith(soundEnabled: false),
            notificationsScheduled: true,
          ),
        ],
        verify: (_) {
          verify(() => mockDatasource.toggleSound(false)).called(1);
        },
      );
    });

    group('setSelectedAdhan', () {
      blocTest<PrayerNotificationCubit, PrayerNotificationState>(
        'does nothing when state is not Loaded',
        build: () => cubit,
        act: (cubit) => cubit.setSelectedAdhan('makkah'),
        expect: () => [],
      );

      blocTest<PrayerNotificationCubit, PrayerNotificationState>(
        'updates selected adhan and emits new state',
        build: () {
          when(() => mockDatasource.setSelectedAdhan(any()))
              .thenAnswer((_) async {});
          return cubit;
        },
        seed: () => PrayerNotificationLoaded(
          settings: defaultSettings,
          notificationsScheduled: true,
        ),
        act: (cubit) => cubit.setSelectedAdhan('makkah'),
        expect: () => [
          PrayerNotificationLoaded(
            settings: defaultSettings.copyWith(selectedAdhan: 'makkah'),
            notificationsScheduled: true,
          ),
        ],
        verify: (_) {
          verify(() => mockDatasource.setSelectedAdhan('makkah')).called(1);
        },
      );
    });

    group('enableAllPrayers', () {
      blocTest<PrayerNotificationCubit, PrayerNotificationState>(
        'does nothing when state is not Loaded',
        build: () => cubit,
        act: (cubit) => cubit.enableAllPrayers(),
        expect: () => [],
      );

      blocTest<PrayerNotificationCubit, PrayerNotificationState>(
        'enables all prayers and emits new state',
        build: () {
          when(() => mockDatasource.togglePrayerNotification(any(), any()))
              .thenAnswer((_) async {});
          return cubit;
        },
        seed: () => PrayerNotificationLoaded(
          settings: const PrayerNotificationSettings(
            fajrEnabled: false,
            dhuhrEnabled: false,
            asrEnabled: false,
            maghribEnabled: false,
            ishaEnabled: false,
          ),
          notificationsScheduled: true,
        ),
        act: (cubit) => cubit.enableAllPrayers(),
        expect: () => [
          const PrayerNotificationLoaded(
            settings: PrayerNotificationSettings(
              fajrEnabled: true,
              dhuhrEnabled: true,
              asrEnabled: true,
              maghribEnabled: true,
              ishaEnabled: true,
            ),
            notificationsScheduled: false,
          ),
        ],
      );
    });

    group('disableAllPrayers', () {
      blocTest<PrayerNotificationCubit, PrayerNotificationState>(
        'does nothing when state is not Loaded',
        build: () => cubit,
        act: (cubit) => cubit.disableAllPrayers(),
        expect: () => [],
      );

      blocTest<PrayerNotificationCubit, PrayerNotificationState>(
        'disables all prayers and emits new state',
        build: () {
          when(() => mockDatasource.togglePrayerNotification(any(), any()))
              .thenAnswer((_) async {});
          when(() => mockDatasource.clearScheduledStatus())
              .thenAnswer((_) async {});
          when(() => mockNotificationService.cancelAllPrayerNotifications())
              .thenAnswer((_) async {});
          return cubit;
        },
        seed: () => const PrayerNotificationLoaded(
          settings: PrayerNotificationSettings(),
          notificationsScheduled: true,
        ),
        act: (cubit) => cubit.disableAllPrayers(),
        expect: () => [
          const PrayerNotificationLoaded(
            settings: PrayerNotificationSettings(
              fajrEnabled: false,
              dhuhrEnabled: false,
              asrEnabled: false,
              maghribEnabled: false,
              ishaEnabled: false,
            ),
            notificationsScheduled: false,
          ),
        ],
        verify: (_) {
          verify(() => mockNotificationService.cancelAllPrayerNotifications())
              .called(1);
        },
      );
    });
  });

  group('PrayerNotificationState', () {
    test('PrayerNotificationInitial props should be empty', () {
      const state = PrayerNotificationInitial();
      expect(state.props, isEmpty);
    });

    test('PrayerNotificationLoading props should be empty', () {
      const state = PrayerNotificationLoading();
      expect(state.props, isEmpty);
    });

    test('PrayerNotificationLoaded props should include settings and scheduled status', () {
      const state = PrayerNotificationLoaded(
        settings: PrayerNotificationSettings(),
        notificationsScheduled: true,
        message: 'Test',
      );
      expect(state.props, [
        const PrayerNotificationSettings(),
        true,
        'Test',
      ]);
    });

    test('PrayerNotificationError props should include message and settings', () {
      const state = PrayerNotificationError(
        message: 'Error',
        settings: PrayerNotificationSettings(),
      );
      expect(state.props, [
        'Error',
        const PrayerNotificationSettings(),
      ]);
    });

    test('PrayerNotificationLoaded copyWith should create new instance', () {
      const original = PrayerNotificationLoaded(
        settings: PrayerNotificationSettings(),
        notificationsScheduled: false,
      );

      final copied = original.copyWith(
        notificationsScheduled: true,
        message: 'Updated',
      );

      expect(copied.settings, original.settings);
      expect(copied.notificationsScheduled, true);
      expect(copied.message, 'Updated');
    });
  });
}
