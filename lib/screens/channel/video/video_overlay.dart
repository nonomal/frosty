import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:frosty/core/settings/settings.dart';
import 'package:frosty/core/settings/settings_store.dart';
import 'package:frosty/screens/channel/video/video_store.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class VideoOverlay extends StatelessWidget {
  final String title;
  final String userName;
  final VideoStore videoStore;

  const VideoOverlay({
    Key? key,
    required this.title,
    required this.userName,
    required this.videoStore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: videoStore.handleVideoTap,
      child: SizedBox.expand(
        child: Observer(
          builder: (_) {
            return AnimatedOpacity(
              opacity: videoStore.menuVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 100),
              child: ColoredBox(
                color: Colors.black.withOpacity(0.5),
                child: IgnorePointer(
                  ignoring: !videoStore.menuVisible,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.adaptive.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Settings(settingsStore: context.read<SettingsStore>());
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    if (videoStore.streamInfo != null) Text('${NumberFormat().format(videoStore.streamInfo?.viewerCount)} viewers'),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(
                                  Icons.picture_in_picture_alt_rounded,
                                  color: Colors.white,
                                ),
                                onPressed: videoStore.enterPictureInPicture,
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.fullscreen,
                                  color: Colors.white,
                                ),
                                onPressed: videoStore.requestFullscreen,
                              )
                            ],
                          )
                        ],
                      ),
                      Center(
                        child: IconButton(
                          icon: videoStore.paused
                              ? const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                )
                              : const Icon(
                                  Icons.pause,
                                  color: Colors.white,
                                ),
                          onPressed: videoStore.handlePausePlay,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}