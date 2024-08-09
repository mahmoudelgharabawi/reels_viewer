import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reels_viewer/src/models/reel_model.dart';
import 'package:reels_viewer/src/services/cache.service.dart';
import 'package:reels_viewer/src/utils/url_checker.dart';
import 'package:video_player/video_player.dart';
import 'components/like_icon.dart';
import 'components/screen_options.dart';

class ReelsPage extends StatefulWidget {
  final ReelModel item;
  final bool showVerifiedTick;
  final Function(ReelModel)? onShare;
  final Future<void> Function(ReelModel)? onSaved;
  final Future<void> Function(ReelModel)? onLike;
  final Future<void> Function(ReelModel)? onComment;
  final Function(ReelModel)? onWhatsAppClicked;

  final Function(ReelModel)? onProfileClicked;

  final Function()? onClickMoreBtn;
  final Function(ReelModel)? onFollow;
  final SwiperController swiperController;
  final bool showProgressIndicator;
  final bool closeOnEnd;

  const ReelsPage({
    Key? key,
    required this.item,
    this.showVerifiedTick = true,
    this.onClickMoreBtn,
    this.onComment,
    this.onWhatsAppClicked,
    this.onProfileClicked,
    this.onFollow,
    this.onLike,
    this.onShare,
    this.onSaved,
    this.showProgressIndicator = true,
    this.closeOnEnd = false,
    required this.swiperController,
  }) : super(key: key);

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  Uint8List? imageUint8list;

  bool _liked = false;
  bool isSwiped = false;
  bool showPlayBtn = false;
  int volume = 1;
  @override
  void initState() {
    super.initState();
    if (!UrlChecker.isImageUrl(widget.item.videoData.url!) &&
        UrlChecker.isValid(widget.item.videoData.url!)) {
      initializePlayer();
    }
  }

  Future initializePlayer() async {
    isSwiped = false;
    // await _cacheManager!.emptyCache();

    var videoFile = await CacheService.cacheManager!
        .getFileFromCache(widget.item.videoData.url!);
    setState(() {});

    // print('>>>> is video cached${videoFile != null}');

    if (videoFile == null) {
      _videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(widget.item.videoData.url!));

      CacheService.cacheManager!.downloadFile(widget.item.videoData.url!);
    } else {
      _videoPlayerController = VideoPlayerController.file(videoFile.file);
    }

    if (_videoPlayerController != null) {
      await Future.wait([_videoPlayerController!.initialize()]);
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        showControls: false,
        looping: false,
      );

      setState(() {});

      _videoPlayerController!.addListener(() {
        // print('>>>position:${_videoPlayerController?.value.position}');
        // print('>>>isPlaying:${_videoPlayerController?.value.isPlaying}');
        // print(
        //     '>>>isInitialized:${_videoPlayerController?.value.isInitialized}');
        // print('>>>isCompleted:${_videoPlayerController?.value.isCompleted}');
        // // _videoPlayerController?.value.aspectRatio;
        if (_videoPlayerController!.value.isCompleted) {
          if (!isSwiped) {
            if (widget.closeOnEnd) {
              Navigator.of(context).pop();
            }

            widget.swiperController.next();
            isSwiped = true;
          }
        }
      });
    }
  }

  @override
  void dispose() {
    if (_videoPlayerController != null) {
      _videoPlayerController!.dispose();
    }
    if (_chewieController != null) {
      _chewieController!.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return getVideoView;
  }

  Widget get getVideoView {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        (_chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized &&
                _videoPlayerController != null)
            ? SizedBox(
                height: widget.item.videoData.height?.toDouble(),
                width: widget.item.videoData.width?.toDouble(),
                child: GestureDetector(
                  onTap: () {
                    if (_chewieController != null) {
                      if (_chewieController!.isPlaying) {
                        _chewieController!.pause();
                        showPlayBtn = true;
                      } else {
                        _chewieController!.play();
                      }
                      setState(() {});
                    }
                  },
                  // onDoubleTap: () {

                  //   if (!widget.item.isLiked) {
                  //     _liked = true;
                  //     if (widget.onLike != null) {
                  //       widget.onLike!(widget.item);
                  //     }
                  //     setState(() {});
                  //   }
                  // },
                  child: Transform.scale(
                    scale: 1.1,
                    child: Chewie(
                      controller: _chewieController!,
                    ),
                  ),
                ),
              )
            : CachedMemoryImage(
                height: widget.item.videoData.height?.toDouble(),
                width: widget.item.videoData.width?.toDouble(),
                fit: BoxFit.fill,
                uniqueKey: 'app/image/${widget.item.videoData.url!}',
                bytes: widget.item.videoData.thumbNail,
                frameBuilder: (context, child, frame, _) {
                  return frame != null
                      ? TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: .1, end: 1),
                          curve: Curves.ease,
                          duration: const Duration(milliseconds: 300),
                          builder: (BuildContext context, double opacity, _) {
                            return Opacity(
                              opacity: opacity,
                              child: child,
                            );
                          },
                        )
                      : const SizedBox.shrink();

                  // Shimmer(style: widget.shimmerStyle)
                },
                errorBuilder: (_, __, ___) {
                  return const Icon(Icons.error);
                },
              ),
        // const Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       CircularProgressIndicator(),
        //       SizedBox(height: 10),
        //       Text('Loading...')
        //     ],
        //   )
        //   ,
        if (_liked)
          const Center(
            child: LikeIcon(),
          ),
        // if (_chewieController != null &&
        //     _chewieController!.videoPlayerController.value.isInitialized &&
        //     (!(_chewieController?.isPlaying ?? false)))
        if (showPlayBtn &&
            _chewieController != null &&
            (!(_chewieController?.isPlaying ?? false)))
          Center(
            child: IconButton(
                onPressed: () {
                  _chewieController!.play();
                  setState(() {});
                },
                icon: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 65,
                )),
          ),

        Positioned(
          bottom: 2,
          right: Directionality.of(context) == TextDirection.ltr ? 0 : null,
          left: Directionality.of(context) == TextDirection.rtl ? 0 : null,
          child: IconButton(
            onPressed: () async {
              if (_chewieController != null) {
                volume = (volume == 1 ? 0 : 1);
                await _chewieController!.setVolume(volume.toDouble());
                setState(() {});
              }
            },
            icon: Icon(
              volume == 1 ? Icons.volume_up_outlined : Icons.volume_off_rounded,
              size: 15,
              color: Colors.white,
            ),
          ),
        ),
        if (widget.showProgressIndicator && _videoPlayerController != null)
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: VideoProgressIndicator(
              _videoPlayerController!,
              allowScrubbing: true,
              colors: VideoProgressColors(
                backgroundColor: Colors.white.withOpacity(.3),
                bufferedColor: Colors.white.withOpacity(.3),
                playedColor: Colors.white,
              ),
            ),
          ),
        Positioned(
          bottom: 0,
          width: MediaQuery.of(context)
              .size
              .width, // <<<HERE - max width of the screen

          child: ScreenOptions(
            onProfileClicked: (model) async {
              if (_chewieController != null) {
                _chewieController!.pause();
              }
              if (widget.onProfileClicked != null) {
                await widget.onProfileClicked!(widget.item);
              }
              if (_chewieController != null) {
                _chewieController!.play();
              }
            },
            onSaved: (model) async {
              if (_chewieController != null) {
                _chewieController!.pause();
              }
              if (widget.onSaved != null) {
                await widget.onSaved!(widget.item);
              }
              if (_chewieController != null) {
                _chewieController!.play();
              }
            },
            onWhatsAppClicked: widget.onWhatsAppClicked,
            onClickMoreBtn: widget.onClickMoreBtn,
            onComment: (model) async {
              if (_chewieController != null) {
                _chewieController!.pause();
              }
              if (widget.onComment != null) {
                await widget.onComment!(widget.item);
              }
              if (_chewieController != null) {
                _chewieController!.play();
              }
            },
            onFollow: widget.onFollow,
            onLike: (model) async {
              if (_chewieController != null) {
                _chewieController!.pause();
              }
              if (widget.onLike != null) {
                await widget.onLike!(widget.item);
              }
              if (_chewieController != null) {
                _chewieController!.play();
              }
            },
            onShare: (model) async {
              if (_chewieController != null) {
                _chewieController!.pause();
              }
              if (widget.onShare != null) {
                await widget.onShare!(widget.item);
              }
              if (_chewieController != null) {
                _chewieController!.play();
              }
            },
            showVerifiedTick: widget.showVerifiedTick,
            item: widget.item,
          ),
        )
      ],
    );
  }
}
