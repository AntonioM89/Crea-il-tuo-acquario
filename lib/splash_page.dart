import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  VideoPlayerController? _ctrl;

  @override
  void initState() {
    super.initState();
    // Placeholder: plays the bundled sample if present, else shows logo text.
    _ctrl = VideoPlayerController.asset('assets/video/splash.mp4')
      ..initialize().then((_) {
        setState(() {});
        _ctrl!.play();
      }).catchError((_){ /* no bundled video yet */ });
  }

  @override
  void dispose() {
    _ctrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoTheme.of(context).scaffoldBackgroundColor,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushReplacementNamed('/wizard'),
        child: Stack(
          children: [
            if (_ctrl != null && _ctrl!.value.isInitialized)
              Center(child: AspectRatio(aspectRatio: _ctrl!.value.aspectRatio, child: VideoPlayer(_ctrl!)))
            else
              Center(child: Text("A C Q U A K I T", style: CupertinoTheme.of(context).textTheme.navTitleTextStyle.copyWith(fontSize: 28))),
            Positioned(
              bottom: 40, left: 0, right: 0,
              child: Center(child: Text("Tocca per iniziare", style: CupertinoTheme.of(context).textTheme.textStyle)),
            )
          ],
        ),
      ),
    );
  }
}