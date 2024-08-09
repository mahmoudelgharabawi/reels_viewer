import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:reels_viewer/reels_viewer.dart';
import 'package:reels_viewer/src/models/reel_model.dart';
import 'package:reels_viewer/src/reels_page.dart';
import 'package:reels_viewer/src/services/cache.service.dart';

class ReelsViewer extends StatefulWidget {
  /// use reel model and provide list of reels, list contains reels object, object contains url and other parameters
  final List<ReelModel> reelsList;

  /// use to show/hide verified tick, by default true
  final bool showVerifiedTick;

  /// function invoke when user click on share btn and return Reel Model
  final Function(ReelModel)? onShare;

  /// function invoke when user click on save btn and return Reel Model
  final Future<void> Function(ReelModel)? onSaved;

  /// function invoke when user click on like btn and return Reel Model
  final Future<void> Function(ReelModel)? onLike;

  /// function invoke when user click on comment btn and return reel comment
  final Future<void> Function(ReelModel)? onComment;

  /// function invoke when reel change and return current index
  final Function(int)? onIndexChanged;

  /// function invoke when user click on more options btn
  final Function()? onClickMoreBtn;

  /// function invoke to show loading indicator
  final Widget Function()? onLoadMoreWidget;

  /// function invoke when loadMore
  final Future<void> Function()? onLoadMore;

  /// function invoke when user click on follow btn
  final Function(ReelModel)? onFollow;

  /// function invoke when user click on profile btn
  final Function(ReelModel)? onProfileClicked;

  /// for change appbar title
  final String? appbarTitle;

  /// for show/hide appbar, by default true
  final bool showAppbar;

  /// for looping the swiper
  final bool loop;

  /// for show/hide video progress indicator, by default true
  final bool showProgressIndicator;

  /// function invoke when user click on back btn
  final Function()? onClickBackArrow;
  final Function(ReelModel)? onWhatsAppClicked;
  final bool closeOnEnd;
  const ReelsViewer({
    Key? key,
    required this.reelsList,
    this.showVerifiedTick = true,
    this.onClickMoreBtn,
    this.onLoadMore,
    this.onLoadMoreWidget,
    this.onComment,
    this.onFollow,
    this.onWhatsAppClicked,
    this.onLike,
    this.onProfileClicked,
    this.onShare,
    this.onSaved,
    this.appbarTitle,
    this.showAppbar = true,
    this.onClickBackArrow,
    this.onIndexChanged,
    this.closeOnEnd = false,
    this.loop = true,
    this.showProgressIndicator = true,
  }) : super(key: key);

  @override
  State<ReelsViewer> createState() => _ReelsViewerState();
}

class _ReelsViewerState extends State<ReelsViewer> {
  SwiperController controller = SwiperController();
  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    CacheService.init();
    if (!(widget.closeOnEnd || widget.loop)) {
      var index =
          widget.reelsList.indexWhere((element) => element.userName == 'load');
      if (index != -1) {
        widget.reelsList.removeAt(index);
      }
      widget.reelsList.add(ReelModel(VideoData(), 'load'));
      controller.index = index;
      controller.addListener(() {
        if (controller.index == widget.reelsList.length - 1) {
          setState(() {
            controller.index = 0;
          });
        }
      });
    }
    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          //We need swiper for every content
          Swiper(
            loop: widget.loop,
            itemBuilder: (BuildContext context, int index) {
              if (widget.reelsList[index].userName == 'load' &&
                  widget.onLoadMoreWidget != null) {
                return LoadMoreWidget(
                  onLoadMore: widget.onLoadMore,
                  onLoadMoreWidget: widget.onLoadMoreWidget,
                );
              }
              return ReelsPage(
                closeOnEnd: widget.closeOnEnd
                    ? index ==
                        (widget.reelsList.isNotEmpty
                            ? (widget.reelsList.length - 1)
                            : 0)
                    : false,
                onWhatsAppClicked: widget.onWhatsAppClicked,
                onProfileClicked: widget.onProfileClicked,
                item: widget.reelsList[index],
                onClickMoreBtn: widget.onClickMoreBtn,
                onComment: widget.onComment,
                onFollow: widget.onFollow,
                onLike: widget.onLike,
                onSaved: widget.onSaved,
                onShare: widget.onShare,
                showVerifiedTick: widget.showVerifiedTick,
                swiperController: controller,
                showProgressIndicator: widget.showProgressIndicator,
              );
            },
            controller: controller,
            itemCount: widget.reelsList.length,
            scrollDirection: Axis.vertical,
            onIndexChanged: (index) {
              // for (var i = 1; i < 3; i++) {
              //   if ((index + i) < widget.reelsList.length) {
              //     CacheService.cacheVideoIfNotCached(
              //         widget.reelsList[index + i]);
              //   }
              // }
              widget.onIndexChanged?.call(index);
            },
          ),

          if (widget.showAppbar)
            Container(
              margin: EdgeInsets.only(top: 25),
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: widget.onClickBackArrow ??
                          () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
                  // Text(
                  //   widget.appbarTitle ?? 'Reels View',
                  //   style: const TextStyle(
                  //       fontSize: 22,
                  //       fontWeight: FontWeight.w600,
                  //       color: Colors.white),
                  // ),
                  // const SizedBox(),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class LoadMoreWidget extends StatefulWidget {
  final Future<void> Function()? onLoadMore;
  final Widget Function()? onLoadMoreWidget;

  const LoadMoreWidget({
    Key? key,
    required this.onLoadMore,
    required this.onLoadMoreWidget,
  }) : super(key: key);

  @override
  State<LoadMoreWidget> createState() => _LoadMoreWidgetState();
}

class _LoadMoreWidgetState extends State<LoadMoreWidget> {
  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    await widget.onLoadMore!.call();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(160.0),
      child: widget.onLoadMoreWidget!.call(),
    );
  }
}
