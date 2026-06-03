/*
 *     Copyright (C) 2026 Valeri Gokadze
 *
 *     Musify is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 *
 *     Musify is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 *
 *     You should have received a copy of the GNU General Public License
 *     along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 *
 *     For more information about Musify, including how to contribute,
 *     please visit: https://github.com/gokadzev/Musify
 */

// Package imports:
import 'package:audio_service/audio_service.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:flutter_lyric/lyrics_reader.dart';
// Project imports:
import 'package:musify/API/musify.dart';
import 'package:musify/extensions/l10n.dart';
import 'package:musify/main.dart';
import 'package:musify/widgets/now_playing/bottom_actions_row.dart';
import 'package:musify/widgets/now_playing/now_playing_artwork.dart';
import 'package:musify/widgets/now_playing/now_playing_controls.dart';
import 'package:musify/widgets/queue_list_view.dart';

class NowPlayingPage extends StatefulWidget {
  const NowPlayingPage({super.key});

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage> {
  final _lyricsController = FlipCardController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isLargeScreen = size.width > 800 && size.height > 600;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = size.width;
    final baseIconSize = screenWidth < 360
        ? 36.0
        : screenWidth < 400
        ? 40.0
        : 44.0;
    final miniIconSize = screenWidth < 360 ? 18.0 : 22.0;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: StreamBuilder<MediaItem?>(
          stream: audioHandler.mediaItem,
          builder: (context, snapshot) {
            if (snapshot.data == null || !snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final metadata = snapshot.data!;
            return Column(
              children: [
                _buildAppBar(context, colorScheme),
                Expanded(
                  child: isLargeScreen
                      ? _DesktopLayout(
                          metadata: metadata,
                          size: size,
                          adjustedIconSize: baseIconSize,
                          adjustedMiniIconSize: miniIconSize,
                          lyricsController: _lyricsController,
                        )
                      : _MobileLayout(
                          metadata: metadata,
                          size: size,
                          adjustedIconSize: baseIconSize,
                          adjustedMiniIconSize: miniIconSize,
                          isLargeScreen: isLargeScreen,
                          lyricsController: _lyricsController,
                        ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget buildArtwork(BuildContext context, Size size, MediaItem metadata) {
    const _padding = 70;
    const _radius = 17.0;
    final screen = size.height / 2;
    final imageSize = screen - _padding;
    const lyricsTextStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w500,
    );

    return FlipCard(
      rotateSide: RotateSide.right,
      onTapFlipping: !offlineMode.value,
      controller: _lyricsController,
      frontWidget: SongArtworkWidget(
        metadata: metadata,
        size: imageSize,
        errorWidgetIconSize: size.width / 8,
        borderRadius: _radius,
      ),
      backWidget: Container(
        width: imageSize,
        height: imageSize,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(_radius),
        ),
        child: FutureBuilder<String?>(
          future: getSongLyrics(metadata.artist ?? '', metadata.title),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Spinner();
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  context.l10n!.lyricsNotAvailable,
                  style: lyricsTextStyle.copyWith(
                    color: Theme.of(context).cardColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            } else if (snapshot.hasData && snapshot.data != 'not found') {
              final lyricUI = UINetease();
              final lyricModel = LyricsModelBuilder.create()
                  .bindLyricToMain(snapshot.data!)
                  .bindLyricToExt(snapshot.data!)
                  .getModel();
              return StreamBuilder<PositionData>(
                stream: audioHandler.positionDataStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox.shrink();
                  return LyricsReader(
                    lyricUi: lyricUI,
                    model: lyricModel,
                    playing: true,
                    position: snapshot.data!.position.inMilliseconds,
                    onTap: _lyricsController.flipcard,
                    emptyBuilder: () => Center(
                      child: Text(
                        context.l10n!.lyricsNotAvailable,
                        style: lyricUI.getOtherMainTextStyle().copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  context.l10n!.lyricsNotAvailable,
                  style: lyricsTextStyle.copyWith(
                    color: Theme.of(context).cardColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            iconSize: 26,
            icon: const Icon(FluentIcons.chevron_down_24_regular),
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.surfaceContainerHighest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.01),
          buildPositionSlider(),
          buildPlayerControls(context, size, mediaItem, iconSize),
          SizedBox(height: size.height * 0.055),
          buildBottomActions(context, audioId, mediaItem, iconSize),
        ],
      ),
    );
  }

  Widget buildPositionSlider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: StreamBuilder<PositionData>(
        stream: audioHandler.positionDataStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox.shrink();
          }
          final positionData = snapshot.data!;
          final primaryColor = Theme.of(context).colorScheme.primary;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildSlider(
                positionData,
              ),
              buildPositionRow(
                primaryColor,
                positionData,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildSlider(
    PositionData positionData,
  ) {
    return CustomSlider(
      isSquiglySliderEnabled: useSquigglySlider.value,
      value: positionData.position.inSeconds.toDouble(),
      onChanged: (value) {
        audioHandler.seek(Duration(seconds: value.toInt()));
      },
      max: positionData.duration.inSeconds.toDouble(),
      squiggleAmplitude: 3,
      squiggleWavelength: 5,
      squiggleSpeed: 0.1,
    );
  }

  Widget buildPositionRow(Color fontColor, PositionData positionData) {
    final positionText = formatDuration(positionData.position.inSeconds);
    final durationText = formatDuration(positionData.duration.inSeconds);
    final textStyle = TextStyle(fontSize: 15, color: fontColor);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(positionText, style: textStyle),
          Text(durationText, style: textStyle),
        ],
      ),
    );
  }

  Widget buildPlayerControls(
    BuildContext context,
    Size size,
    MediaItem mediaItem,
    double iconSize,
  ) {
    final theme = Theme.of(context);
    final _primaryColor = theme.colorScheme.primary;
    final _secondaryColor = theme.colorScheme.secondaryContainer;

    // final screen = ((size.height) / 2) - 10;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ValueListenableBuilder<bool>(
            valueListenable: shuffleNotifier,
            builder: (_, value, __) {
              return value
                  ? IconButton.filled(
                      icon: Icon(
                        FluentIcons.arrow_shuffle_24_filled,
                        color: _secondaryColor,
                      ),
                      iconSize: iconSize,
                      onPressed: () {
                        audioHandler.setShuffleMode(
                          AudioServiceShuffleMode.none,
                        );
                      },
                    )
                  : IconButton.filledTonal(
                      icon: Icon(
                        FluentIcons.arrow_shuffle_off_24_filled,
                        color: _primaryColor,
                      ),
                      iconSize: iconSize,
                      onPressed: () {
                        audioHandler.setShuffleMode(
                          AudioServiceShuffleMode.all,
                        );
                      },
                    );
            },
          ),
          Row(
            children: [
              ValueListenableBuilder<AudioServiceRepeatMode>(
                valueListenable: repeatNotifier,
                builder: (_, repeatMode, __) {
                  return IconButton(
                    icon: Icon(
                      FluentIcons.previous_24_filled,
                      color: audioHandler.hasPrevious
                          ? _primaryColor
                          : _secondaryColor,
                    ),
                    iconSize: 28,
                    onPressed: () =>
                        repeatNotifier.value == AudioServiceRepeatMode.one
                            ? audioHandler.playAgain()
                            : audioHandler.skipToPrevious(),
                    splashColor: Colors.transparent,
                  );
                },
              ),
              const SizedBox(width: 10),
              StreamBuilder<PlaybackState>(
                stream: audioHandler.playbackState,
                builder: (context, snapshot) {
                  return buildPlaybackIconButton(
                    snapshot.data,
                    32,
                    _primaryColor,
                    _secondaryColor,
                    elevation: 0,
                    padding: const EdgeInsets.all(12),
                  );
                },
              ),
              const SizedBox(width: 10),
              ValueListenableBuilder<AudioServiceRepeatMode>(
                valueListenable: repeatNotifier,
                builder: (_, repeatMode, __) {
                  return IconButton(
                    icon: Icon(
                      FluentIcons.next_24_filled,
                      color: audioHandler.hasNext
                          ? _primaryColor
                          : _secondaryColor,
                    ),
                    iconSize: 28,
                    onPressed: () =>
                        repeatNotifier.value == AudioServiceRepeatMode.one
                            ? audioHandler.playAgain()
                            : audioHandler.skipToNext(),
                    splashColor: Colors.transparent,
                  );
                },
              ),
            ],
          ),
          ValueListenableBuilder<AudioServiceRepeatMode>(
            valueListenable: repeatNotifier,
            builder: (_, repeatMode, __) {
              return repeatMode != AudioServiceRepeatMode.none
                  ? IconButton.filled(
                      icon: Icon(
                        repeatMode == AudioServiceRepeatMode.all
                            ? FluentIcons.arrow_repeat_all_24_filled
                            : FluentIcons.arrow_repeat_1_24_filled,
                        color: _secondaryColor,
                      ),
                      iconSize: iconSize,
                      onPressed: () {
                        repeatNotifier.value =
                            repeatMode == AudioServiceRepeatMode.all
                                ? AudioServiceRepeatMode.one
                                : AudioServiceRepeatMode.none;

                        audioHandler.setRepeatMode(repeatMode);
                      },
                    )
                  : IconButton.filledTonal(
                      icon: Icon(
                        FluentIcons.arrow_repeat_all_off_24_filled,
                        color: _primaryColor,
                      ),
                      iconSize: iconSize,
                      onPressed: () {
                        final _isSingleSongPlaying =
                            activePlaylist['list'].isEmpty;
                        repeatNotifier.value = _isSingleSongPlaying
                            ? AudioServiceRepeatMode.one
                            : AudioServiceRepeatMode.all;

                        if (repeatNotifier.value == AudioServiceRepeatMode.one)
                          audioHandler.setRepeatMode(repeatNotifier.value);
                      },
                    );
            },
          ),
        ],
      ),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    required this.metadata,
    required this.size,
    required this.adjustedIconSize,
    required this.adjustedMiniIconSize,
    required this.lyricsController,
  });
  final MediaItem metadata;
  final Size size;
  final double adjustedIconSize;
  final double adjustedMiniIconSize;
  final FlipCardController lyricsController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Expanded(
                  flex: 5,
                  child: Center(
                    child: NowPlayingArtwork(
                      size: size,
                      metadata: metadata,
                      lyricsController: lyricsController,
                    ),
                  ),
                ),
                if (!(metadata.extras?['isLive'] ?? false))
                  Expanded(
                    flex: 4,
                    child: NowPlayingControls(
                      size: size,
                      audioId: metadata.extras?['ytid'],
                      adjustedIconSize: adjustedIconSize,
                      adjustedMiniIconSize: adjustedMiniIconSize,
                      metadata: metadata,
                    ),
                  ),
                BottomActionsRow(
                  audioId: metadata.extras?['ytid'],
                  metadata: metadata,
                  iconSize: adjustedMiniIconSize,
                  isLargeScreen: true,
                  lyricsController: lyricsController,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        const Expanded(child: QueueWidget()),
      ],
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.metadata,
    required this.size,
    required this.adjustedIconSize,
    required this.adjustedMiniIconSize,
    required this.isLargeScreen,
    required this.lyricsController,
  });
  final MediaItem metadata;
  final Size size;
  final double adjustedIconSize;
  final double adjustedMiniIconSize;
  final bool isLargeScreen;
  final FlipCardController lyricsController;

  @override
  Widget build(BuildContext context) {
    final isLandscape = size.width > size.height;

    if (isLandscape) {
      return _buildLandscapeLayout(context);
    }
    return _buildPortraitLayout(context);
  }

  Widget _buildPortraitLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            flex: 5,
            child: Center(
              child: NowPlayingArtwork(
                size: size,
                metadata: metadata,
                lyricsController: lyricsController,
              ),
            ),
          ),
          if (!(metadata.extras?['isLive'] ?? false))
            Expanded(
              flex: 4,
              child: NowPlayingControls(
                size: size,
                audioId: metadata.extras?['ytid'],
                adjustedIconSize: adjustedIconSize,
                adjustedMiniIconSize: adjustedMiniIconSize,
                metadata: metadata,
              ),
            ),
          BottomActionsRow(
            audioId: metadata.extras?['ytid'],
            metadata: metadata,
            iconSize: adjustedMiniIconSize,
            isLargeScreen: isLargeScreen,
            lyricsController: lyricsController,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Center(
              child: NowPlayingArtwork(
                size: size,
                metadata: metadata,
                lyricsController: lyricsController,
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!(metadata.extras?['isLive'] ?? false))
                  Expanded(
                    child: NowPlayingControls(
                      size: size,
                      audioId: metadata.extras?['ytid'],
                      adjustedIconSize: adjustedIconSize,
                      adjustedMiniIconSize: adjustedMiniIconSize,
                      metadata: metadata,
                    ),
                  ),
                BottomActionsRow(
                  audioId: metadata.extras?['ytid'],
                  metadata: metadata,
                  iconSize: adjustedMiniIconSize,
                  isLargeScreen: isLargeScreen,
                  lyricsController: lyricsController,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
