import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
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

  /// function invoke when user click on follow btn
  final Function(ReelModel)? onFollow;

  /// function invoke when user click on profile btn
  final Function(ReelModel)? onProfileClicked;

  /// for change appbar title
  final String? appbarTitle;

  /// for show/hide appbar, by default true
  final bool showAppbar;

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
    this.showProgressIndicator = true,
  }) : super(key: key);

  @override
  State<ReelsViewer> createState() => _ReelsViewerState();
}

class _ReelsViewerState extends State<ReelsViewer> {
  SwiperController controller = SwiperController();

  @override
  void initState() {
    CacheService.cacheAllVideos(widget.reelsList);
    super.initState();
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
            duration: 1000,
            itemBuilder: (BuildContext context, int index) {
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
            onIndexChanged: widget.onIndexChanged,
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
