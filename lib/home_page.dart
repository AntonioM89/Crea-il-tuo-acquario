import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'state.dart';
import 'app_theme.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(items: const [
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.square_grid_2x2), label: "Riepilogo"),
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.thermometer), label: "Parametri"),
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.check_mark), label: "Attività"),
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.photo_on_rectangle), label: "Media"),
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.gear), label: "Impostazioni"),
      ]),
      tabBuilder: (context, index) {
        switch(index){
          case 0: return const _Dashboard();
          case 1: return const _Parameters();
          case 2: return const _Tasks();
          case 3: return const _Media();
          case 4: return const _Settings();
          default: return const _Dashboard();
        }
      },
    );
  }
}

class _Dashboard extends ConsumerWidget {
  const _Dashboard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(setupProvider);
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text("Riepilogo")),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Glass(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(setup?.tankName ?? "La mia vasca", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text("${setup?.volumeLiters ?? 60} L • ${setup?.waterType ?? 'Rubinetto'} • ${setup?.lighting ?? 'LED'}"),
                  const SizedBox(height: 10),
                  const Text("Prossimi step"),
                  const SizedBox(height: 8),
                  const Text("• Introdurre pulitori: ≥21 giorni dall’avvio + 48h NO₂/NH₃=0\n• Pesci principali: ≥7 giorni dopo i pulitori + 48h NO₂/NH₃=0"),
                ],
              )),
              const SizedBox(height: 16),
              Glass(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Note rapide"),
                  SizedBox(height: 8),
                  Text("Aggiungi osservazioni, fertilizzante, cambi d’acqua… (placeholder)."),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class _Parameters extends ConsumerWidget {
  const _Parameters();

  LineChartData _chartData(){
    final spots = List.generate(7, (i) => FlSpot(i.toDouble(), (i==2||i==3)?0.2:0.05));
    return LineChartData(
      titlesData: FlTitlesData(show: true),
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(spots: spots, isCurved: true, barWidth: 3),
      ],
      minY: 0, maxY: 0.5,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text("Parametri")),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Glass(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Andamento NO₂ (mg/L) — demo"),
                  const SizedBox(height: 12),
                  // Wrap chart in Material to satisfy fl_chart requirements
                  Material(
                    color: Colors.transparent,
                    child: SizedBox(height: 180, child: LineChart(_chartData())),
                  ),
                ],
              )),
              const SizedBox(height: 16),
              const Text("Qui potrai inserire i test e vedere grafici, bersagli e avvisi."),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tasks extends StatelessWidget {
  const _Tasks();
  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("Attività")),
      child: Center(child: Text("Planner manutenzione (placeholder)")),
    );
  }
}

class _Media extends StatelessWidget {
  const _Media();
  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("Media")),
      child: Center(child: Text("Prima/dopo, foto pesci/piante (placeholder)")),
    );
  }
}

class _Settings extends ConsumerWidget {
  const _Settings();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text("Impostazioni")),
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 8),
            CupertinoListSection.insetGrouped(
              header: const Text("Aspetto"),
              children: [
                CupertinoListTile.notched(
                  title: const Text("Tema scuro"),
                  trailing: CupertinoSwitch(
                    value: theme.isDark,
                    onChanged: (_)=> ref.read(themeProvider.notifier).toggleDark(),
                  ),
                ),
                CupertinoListTile.notched(
                  title: const Text("Colore accento"),
                  additionalInfo: Text(theme.accent.name),
                  trailing: CupertinoSlidingSegmentedControl(
                    groupValue: theme.accent,
                    children: const {
                      AccentTheme.lagoon: Padding(padding: EdgeInsets.all(6), child: Text("Lagoon")),
                      AccentTheme.reef: Padding(padding: EdgeInsets.all(6), child: Text("Reef")),
                      AccentTheme.forest: Padding(padding: EdgeInsets.all(6), child: Text("Forest")),
                    },
                    onValueChanged: (v){ if(v!=null) ref.read(themeProvider.notifier).setAccent(v); },
                  ),
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              header: const Text("Branding"),
              children: const [
                CupertinoListTile.notched(
                  title: Text("Video/logo splash"),
                  additionalInfo: Text("Sostituisci assets/video/splash.mp4"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}