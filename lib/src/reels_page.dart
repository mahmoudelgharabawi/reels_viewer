import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:reels_viewer/src/models/reel_model.dart';
import 'package:reels_viewer/src/utils/url_checker.dart';
import 'package:video_player/video_player.dart';
import 'components/like_icon.dart';
import 'components/screen_options.dart';

class ReelsPage extends StatefulWidget {
  final ReelModel item;
  final bool showVerifiedTick;
  final Function(ReelModel)? onShare;
  final Function(ReelModel)? onSaved;
  final Function(ReelModel)? onLike;
  final Function(ReelModel)? onComment;
  final Function(ReelModel)? onWhatsAppClicked;
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
  DefaultCacheManager? _cacheManager;
  Uint8List? imageUint8list;

  bool _liked = false;
  bool isSwiped = false;
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
    _cacheManager ??= DefaultCacheManager();
    // await _cacheManager!.emptyCache();

    var videoFile =
        await _cacheManager!.getFileFromCache(widget.item.videoData.url!);
    setState(() {});

    if (videoFile == null) {
      _videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(widget.item.videoData.url!));
      _cacheManager!.downloadFile(widget.item.videoData.url!);
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
    return getVideoView();
  }

  Widget getVideoView() {
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
                  onDoubleTap: () {
                    if (!widget.item.isLiked) {
                      _liked = true;
                      if (widget.onLike != null) {
                        widget.onLike!(widget.item);
                      }
                      setState(() {});
                    }
                  },
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
        if (widget.showProgressIndicator && _videoPlayerController != null)
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: VideoProgressIndicator(
              _videoPlayerController!,
              allowScrubbing: false,
              colors: const VideoProgressColors(
                backgroundColor: Colors.blueGrey,
                bufferedColor: Colors.blueGrey,
                playedColor: Colors.black,
              ),
            ),
          ),
        Positioned(
          bottom: 0,
          width: MediaQuery.of(context)
              .size
              .width, // <<<HERE - max width of the screen

          child: ScreenOptions(
            onSaved: widget.onSaved,
            onWhatsAppClicked: widget.onWhatsAppClicked,
            onClickMoreBtn: widget.onClickMoreBtn,
            onComment: widget.onComment,
            onFollow: widget.onFollow,
            onLike: widget.onLike,
            onShare: widget.onShare,
            showVerifiedTick: widget.showVerifiedTick,
            item: widget.item,
          ),
        )
      ],
    );
  }
}
