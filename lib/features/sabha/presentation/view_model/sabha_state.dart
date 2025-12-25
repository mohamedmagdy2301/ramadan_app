import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ramadan_app/features/sabha/data/models/dhikr_model.dart';

class SabhaState extends Equatable {
  final int counter;
  final DhikrModel selectedDhikr;
  final SabhaTarget target;
  final bool isAnimating;
  final bool showCelebration;
  final int todayTotal;
  final bool soundEnabled;

  const SabhaState({
    this.counter = 0,
    this.selectedDhikr = const DhikrModel(
      id: 'subhanallah',
      text: 'سبحان الله',
      subtitle: 'Glory be to Allah',
      defaultTarget: 33,
      color: Color(0xFF4CAF50),
      icon: Icons.spa,
    ),
    this.target = SabhaTarget.target33,
    this.isAnimating = false,
    this.showCelebration = false,
    this.todayTotal = 0,
    this.soundEnabled = true,
  });

  bool get hasReachedTarget =>
      target != SabhaTarget.infinite && counter >= target.value;

  double get progress {
    if (target == SabhaTarget.infinite || target.value == 0) {
      return 0.0;
    }
    return (counter / target.value).clamp(0.0, 1.0);
  }

  SabhaState copyWith({
    int? counter,
    DhikrModel? selectedDhikr,
    SabhaTarget? target,
    bool? isAnimating,
    bool? showCelebration,
    int? todayTotal,
    bool? soundEnabled,
  }) {
    return SabhaState(
      counter: counter ?? this.counter,
      selectedDhikr: selectedDhikr ?? this.selectedDhikr,
      target: target ?? this.target,
      isAnimating: isAnimating ?? this.isAnimating,
      showCelebration: showCelebration ?? this.showCelebration,
      todayTotal: todayTotal ?? this.todayTotal,
      soundEnabled: soundEnabled ?? this.soundEnabled,
    );
  }

  @override
  List<Object?> get props => [
        counter,
        selectedDhikr.id,
        target,
        isAnimating,
        showCelebration,
        todayTotal,
        soundEnabled,
      ];
}
