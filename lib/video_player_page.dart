import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'dart:io';

class VideoPlayerPage extends StatefulWidget {
  final String deviceName;
  final String streamUrl;

  const VideoPlayerPage({
    super.key,
    required this.deviceName,
    required this.streamUrl,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late final Player player;
  late final VideoController controller;

  @override
  void initState() {
    super.initState();
    player = Player();
    controller = VideoController(player);
    player.open(Media(widget.streamUrl));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.deviceName),
        ),
        body: Video(
          controller: controller,
        ),
      );
    } else {
      // Web or other platforms
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.deviceName),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Streaming RTSP direto requer suporte nativo ou proxy WebRTC.\n\nDetalhes da câmera:\n- Nome: [deviceName]\n- URL: [streamUrl]',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      );
    }
  }
}