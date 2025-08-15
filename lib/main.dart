import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_theme.dart';
import 'state.dart';
import 'splash_page.dart';
import 'wizard_flow.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: AcquaKitApp()));
}

class AcquaKitApp extends ConsumerWidget {
  const AcquaKitApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);

    Color accent;
    switch(theme.accent){
      case AccentTheme.lagoon: accent = AppThemes.lagoon; break;
      case AccentTheme.reef: accent = AppThemes.reef; break;
      case AccentTheme.forest: accent = AppThemes.forest; break;
    }

    final cupertinoTheme = theme.isDark
        ? AppThemes.cupertinoDark(accent)
        : AppThemes.cupertinoLight(accent);

    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: cupertinoTheme,
      onGenerateRoute: (settings) {
        switch(settings.name){
          case '/': return CupertinoPageRoute(builder: (_)=> const SplashPage());
          case '/wizard': return CupertinoPageRoute(builder: (_)=> const WizardFlow());
          case '/home': return CupertinoPageRoute(builder: (_)=> const HomePage());
          default: return CupertinoPageRoute(builder: (_)=> const SplashPage());
        }
      },
    );
  }
}