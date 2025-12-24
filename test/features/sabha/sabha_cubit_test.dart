import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ramadan_app/core/local_storage/shared_preferences_manager.dart';
import 'package:ramadan_app/features/sabha/data/models/dhikr_model.dart';
import 'package:ramadan_app/features/sabha/presentation/view_model/sabha_cubit.dart';
import 'package:ramadan_app/features/sabha/presentation/view_model/sabha_state.dart';
import 'package:ramadan_app/features/statistics/data/statistics_local_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockStatisticsLocalDatasource extends Mock
    implements IStatisticsLocalDatasource {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SabhaCubit sabhaCubit;
  late MockStatisticsLocalDatasource mockStatsDataSource;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SharedPreferencesManager.sharedPreferencesInitialize();
    mockStatsDataSource = MockStatisticsLocalDatasource();
    when(() => mockStatsDataSource.incrementSabhaCount())
        .thenAnswer((_) async {});
    sabhaCubit = SabhaCubit(
      statsDataSource: mockStatsDataSource,
      enableHaptics: false,
    );
  });

  tearDown(() {
    sabhaCubit.close();
  });

  group('SabhaCubit', () {
    test('initial state is correct', () {
      expect(sabhaCubit.state.counter, 0);
      expect(sabhaCubit.state.isAnimating, false);
      expect(sabhaCubit.state.showCelebration, false);
      expect(sabhaCubit.state.target, SabhaTarget.target33);
    });

    blocTest<SabhaCubit, SabhaState>(
      'increment increases counter by 1',
      setUp: () async {
        SharedPreferences.setMockInitialValues({});
        await SharedPreferencesManager.sharedPreferencesInitialize();
      },
      build: () => SabhaCubit(
        statsDataSource: mockStatsDataSource,
        enableHaptics: false,
      ),
      act: (cubit) => cubit.increment(),
      expect: () => [
        isA<SabhaState>()
            .having((s) => s.counter, 'counter', 1)
            .having((s) => s.isAnimating, 'isAnimating', true),
      ],
      verify: (_) {
        verify(() => mockStatsDataSource.incrementSabhaCount()).called(1);
      },
    );

    blocTest<SabhaCubit, SabhaState>(
      'selectDhikr changes selected dhikr and resets counter',
      setUp: () async {
        SharedPreferences.setMockInitialValues({});
        await SharedPreferencesManager.sharedPreferencesInitialize();
      },
      build: () => SabhaCubit(
        statsDataSource: mockStatsDataSource,
        enableHaptics: false,
      ),
      seed: () => const SabhaState(counter: 10),
      act: (cubit) => cubit.selectDhikr(DhikrModel.defaultDhikrList[1]),
      expect: () => [
        isA<SabhaState>()
            .having((s) => s.counter, 'counter', 0)
            .having(
                (s) => s.selectedDhikr.id, 'selectedDhikr.id', 'alhamdulillah'),
      ],
    );

    blocTest<SabhaCubit, SabhaState>(
      'setTarget changes target',
      setUp: () async {
        SharedPreferences.setMockInitialValues({});
        await SharedPreferencesManager.sharedPreferencesInitialize();
      },
      build: () => SabhaCubit(
        statsDataSource: mockStatsDataSource,
        enableHaptics: false,
      ),
      act: (cubit) => cubit.setTarget(SabhaTarget.target99),
      expect: () => [
        isA<SabhaState>().having((s) => s.target, 'target', SabhaTarget.target99),
      ],
    );

    blocTest<SabhaCubit, SabhaState>(
      'reset sets counter to 0',
      setUp: () async {
        SharedPreferences.setMockInitialValues({});
        await SharedPreferencesManager.sharedPreferencesInitialize();
      },
      build: () => SabhaCubit(
        statsDataSource: mockStatsDataSource,
        enableHaptics: false,
      ),
      seed: () => const SabhaState(counter: 50),
      act: (cubit) => cubit.reset(),
      expect: () => [
        isA<SabhaState>().having((s) => s.counter, 'counter', 0),
      ],
    );

    blocTest<SabhaCubit, SabhaState>(
      'toggleSound toggles sound enabled',
      setUp: () async {
        SharedPreferences.setMockInitialValues({});
        await SharedPreferencesManager.sharedPreferencesInitialize();
      },
      build: () => SabhaCubit(
        statsDataSource: mockStatsDataSource,
        enableHaptics: false,
      ),
      act: (cubit) => cubit.toggleSound(),
      expect: () => [
        isA<SabhaState>().having((s) => s.soundEnabled, 'soundEnabled', false),
      ],
    );

    blocTest<SabhaCubit, SabhaState>(
      'dismissCelebration hides celebration',
      setUp: () async {
        SharedPreferences.setMockInitialValues({});
        await SharedPreferencesManager.sharedPreferencesInitialize();
      },
      build: () => SabhaCubit(
        statsDataSource: mockStatsDataSource,
        enableHaptics: false,
      ),
      seed: () => const SabhaState(showCelebration: true),
      act: (cubit) => cubit.dismissCelebration(),
      expect: () => [
        isA<SabhaState>().having((s) => s.showCelebration, 'showCelebration', false),
      ],
    );

    test('progress calculation is correct', () {
      // 0 out of 33
      var state = const SabhaState(counter: 0, target: SabhaTarget.target33);
      expect(state.progress, 0.0);

      // 16 out of 33 ≈ 0.48
      state = const SabhaState(counter: 16, target: SabhaTarget.target33);
      expect(state.progress, closeTo(0.48, 0.01));

      // 33 out of 33 = 1.0
      state = const SabhaState(counter: 33, target: SabhaTarget.target33);
      expect(state.progress, 1.0);

      // 50 out of 33 = 1.0 (clamped)
      state = const SabhaState(counter: 50, target: SabhaTarget.target33);
      expect(state.progress, 1.0);

      // Infinite target
      state = const SabhaState(counter: 100, target: SabhaTarget.infinite);
      expect(state.progress, 0.0);
    });

    test('hasReachedTarget returns correct value', () {
      var state = const SabhaState(counter: 32, target: SabhaTarget.target33);
      expect(state.hasReachedTarget, false);

      state = const SabhaState(counter: 33, target: SabhaTarget.target33);
      expect(state.hasReachedTarget, true);

      state = const SabhaState(counter: 100, target: SabhaTarget.infinite);
      expect(state.hasReachedTarget, false);
    });
  });
}
