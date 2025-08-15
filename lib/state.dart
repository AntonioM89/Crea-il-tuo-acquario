import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';

enum AccentTheme { lagoon, reef, forest }

class ThemeState {
  final bool isDark;
  final AccentTheme accent;
  const ThemeState({this.isDark=false, this.accent=AccentTheme.lagoon});

  ThemeState copyWith({bool? isDark, AccentTheme? accent}) =>
      ThemeState(isDark: isDark ?? this.isDark, accent: accent ?? this.accent);
}

class TankSetup {
  final String tankName;
  final int volumeLiters;
  final String waterType; // "Rubinetto" | "Osmosi"
  final String substrate;
  final String lighting;
  final DateTime startDate;

  const TankSetup({
    required this.tankName,
    required this.volumeLiters,
    required this.waterType,
    required this.substrate,
    required this.lighting,
    required this.startDate,
  });
}

class TankSetupNotifier extends StateNotifier<TankSetup?> {
  TankSetupNotifier(): super(null);

  void set(TankSetup s){ state = s; }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) => ThemeNotifier());
final setupProvider = StateNotifierProvider<TankSetupNotifier, TankSetup?>((ref) => TankSetupNotifier());

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier(): super(const ThemeState());

  void toggleDark() => state = state.copyWith(isDark: !state.isDark);

  void setAccent(AccentTheme accent) => state = state.copyWith(accent: accent);
}