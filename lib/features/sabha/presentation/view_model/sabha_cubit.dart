import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_app/core/constants/storage_keys.dart';
import 'package:ramadan_app/core/di/injection_container.dart';
import 'package:ramadan_app/core/local_storage/shared_preferences_manager.dart';
import 'package:ramadan_app/features/sabha/data/models/dhikr_model.dart';
import 'package:ramadan_app/features/sabha/presentation/view_model/sabha_state.dart';
import 'package:ramadan_app/features/statistics/data/statistics_local_datasource.dart';

class SabhaCubit extends Cubit<SabhaState> {
  final IStatisticsLocalDatasource _statsDataSource;
  final bool _enableHaptics;

  SabhaCubit({
    IStatisticsLocalDatasource? statsDataSource,
    bool enableHaptics = true,
  })  : _statsDataSource = statsDataSource ?? sl<IStatisticsLocalDatasource>(),
        _enableHaptics = enableHaptics,
        super(const SabhaState());

  void _hapticLight() {
    if (_enableHaptics && !kIsWeb) {
      try {
        HapticFeedback.lightImpact();
      } catch (_) {}
    }
  }

  void _hapticMedium() {
    if (_enableHaptics && !kIsWeb) {
      try {
        HapticFeedback.mediumImpact();
      } catch (_) {}
    }
  }

  void _hapticHeavy() {
    if (_enableHaptics && !kIsWeb) {
      try {
        HapticFeedback.heavyImpact();
      } catch (_) {}
    }
  }

  void _hapticSelection() {
    if (_enableHaptics && !kIsWeb) {
      try {
        HapticFeedback.selectionClick();
      } catch (_) {}
    }
  }

  void initialize() {
    final savedCounter =
        SharedPreferencesManager.getData(key: StorageKeys.sabhaCounter) ?? 0;
    final savedDhikrId =
        SharedPreferencesManager.getData(key: 'sabha_dhikr_id') ?? 'subhanallah';
    final savedTargetIndex =
        SharedPreferencesManager.getData(key: 'sabha_target_index') ?? 0;
    final savedSoundEnabled =
        SharedPreferencesManager.getData(key: 'sabha_sound_enabled') ?? true;

    final selectedDhikr = DhikrModel.defaultDhikrList.firstWhere(
      (d) => d.id == savedDhikrId,
      orElse: () => DhikrModel.defaultDhikrList.first,
    );

    final target = SabhaTarget.values[savedTargetIndex.clamp(0, SabhaTarget.values.length - 1)];

    emit(state.copyWith(
      counter: savedCounter,
      selectedDhikr: selectedDhikr,
      target: target,
      soundEnabled: savedSoundEnabled,
    ));
  }

  void increment() {
    // Haptic feedback
    _hapticLight();

    final newCounter = state.counter + 1;
    final hasReachedTarget = state.target != SabhaTarget.infinite &&
        newCounter == state.target.value;

    // Save counter
    SharedPreferencesManager.setData(
      key: StorageKeys.sabhaCounter,
      value: newCounter,
    );

    // Update statistics
    _statsDataSource.incrementSabhaCount();

    emit(state.copyWith(
      counter: newCounter,
      isAnimating: true,
      showCelebration: hasReachedTarget,
      todayTotal: state.todayTotal + 1,
    ));

    // Reset animation state after delay
    Future.delayed(const Duration(milliseconds: 150), () {
      if (!isClosed) {
        emit(state.copyWith(isAnimating: false));
      }
    });

    // Hide celebration after delay
    if (hasReachedTarget) {
      _hapticHeavy();
      Future.delayed(const Duration(seconds: 3), () {
        if (!isClosed) {
          emit(state.copyWith(showCelebration: false));
        }
      });
    }
  }

  void selectDhikr(DhikrModel dhikr) {
    _hapticSelection();

    SharedPreferencesManager.setData(key: 'sabha_dhikr_id', value: dhikr.id);

    // Set target based on dhikr default
    final newTarget = dhikr.defaultTarget == 33
        ? SabhaTarget.target33
        : dhikr.defaultTarget == 99
            ? SabhaTarget.target99
            : SabhaTarget.target100;

    emit(state.copyWith(
      selectedDhikr: dhikr,
      counter: 0,
      target: newTarget,
      showCelebration: false,
    ));

    SharedPreferencesManager.setData(
      key: StorageKeys.sabhaCounter,
      value: 0,
    );
    SharedPreferencesManager.setData(
      key: 'sabha_target_index',
      value: SabhaTarget.values.indexOf(newTarget),
    );
  }

  void setTarget(SabhaTarget target) {
    _hapticSelection();

    SharedPreferencesManager.setData(
      key: 'sabha_target_index',
      value: SabhaTarget.values.indexOf(target),
    );

    emit(state.copyWith(
      target: target,
      showCelebration: false,
    ));
  }

  void reset() {
    _hapticMedium();

    SharedPreferencesManager.setData(
      key: StorageKeys.sabhaCounter,
      value: 0,
    );

    emit(state.copyWith(
      counter: 0,
      showCelebration: false,
    ));
  }

  void toggleSound() {
    final newSoundEnabled = !state.soundEnabled;
    SharedPreferencesManager.setData(
      key: 'sabha_sound_enabled',
      value: newSoundEnabled,
    );
    emit(state.copyWith(soundEnabled: newSoundEnabled));
  }

  void dismissCelebration() {
    emit(state.copyWith(showCelebration: false));
  }
}
