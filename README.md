# AcquaKit (prototype)

App in stile iOS con:
- Splash video/logo (sostituisci `assets/video/splash.mp4`).
- Wizard iniziale per setup vasca.
- Home di monitoraggio con tab (Riepilogo, Parametri, Attività, Media, Impostazioni).
- Tema chiaro/scuro + 3 accenti colore (Lagoon/Reef/Forest).
- Effetto vetro (glassmorphism) con blur.

## Avvio
1) Installa Flutter 3.x
2) Apri la cartella e lancia:
   ```bash
   flutter pub get
   flutter run
   ```

## Note
- I dati persistenti (Hive) sono referenziati nei `pubspec`, ma non ancora inizializzati: da attivare in una prossima iterazione quando aggiungeremo salvataggio test/attività.
- Per il Play Store creeremo un AAB con `flutter build appbundle` quando pronto.