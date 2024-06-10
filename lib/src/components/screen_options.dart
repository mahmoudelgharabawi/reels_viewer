import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:reels_viewer/reels_viewer.dart';
import 'package:reels_viewer/src/components/user_profile_image.dart';
import 'package:reels_viewer/src/utils/convert_numbers_to_short.dart';
import 'package:rich_readmore/rich_readmore.dart';

class ScreenOptions extends StatelessWidget {
  final ReelModel item;
  final bool showVerifiedTick;
  final Function(ReelModel)? onShare;
  final Function(ReelModel)? onProfileClicked;
  final Function(ReelModel)? onSaved;
  final Function(ReelModel)? onLike;
  final Function(ReelModel)? onComment;
  final Function(ReelModel)? onWhatsAppClicked;

  final Function()? onClickMoreBtn;
  final Function(ReelModel)? onFollow;

  const ScreenOptions({
    Key? key,
    required this.item,
    this.showVerifiedTick = true,
    this.onClickMoreBtn,
    this.onComment,
    this.onWhatsAppClicked,
    this.onFollow,
    this.onProfileClicked,
    this.onLike,
    this.onShare,
    this.onSaved,
  }) : super(key: key);

  TextStyle get mainSpanTextStyle => TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.white.withOpacity(.8));
  TextStyle get moreLessTextStyle => const TextStyle(
      fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const SizedBox(height: 250),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => onProfileClicked!(item),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (item.profileUrl != null)
                            UserProfileImage(profileUrl: item.profileUrl ?? ''),
                          if (item.profileUrl == null)
                            const CircleAvatar(
                              child: Icon(Icons.person, size: 18),
                              radius: 16,
                            ),
                          const SizedBox(width: 6),
                          SizedBox(
                            width: 150,
                            child: Text(item.userName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(width: 15),
                          if (showVerifiedTick)
                            const Icon(
                              Icons.verified,
                              size: 15,
                              color: Colors.white,
                            ),
                          if (showVerifiedTick) const SizedBox(width: 6),
                        ],
                      ),
                    ),

                    if (onFollow != null)
                      InkWell(
                        onTap: () => onFollow!(item),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              item.isFollowing
                                  ? item.followingText
                                  : item.followText,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),

                    // TextButton(
                    //   style: TextButton.styleFrom(
                    //       fixedSize: Size(item.isFollowing ? 150 : 80, 30),
                    //       shape: RoundedRectangleBorder(
                    //         side: const BorderSide(color: Colors.white),
                    //         borderRadius: BorderRadius.circular(15),
                    //       )),
                    //   onPressed: () => onFollow!(item),
                    //   child:,
                    // ),
                  ],
                ),
                if (item.reelDescription != null && item.reelDescription != '')
                  const SizedBox(height: 6),
                if (item.reelDescription != null && item.reelDescription != '')
                  RichReadMoreText(
                    TextSpan(
                        text: item.reelDescription, style: mainSpanTextStyle),
                    settings: LineModeSettings(
                      moreStyle: moreLessTextStyle,
                      lessStyle: moreLessTextStyle,
                      trimLines: 2,
                      trimCollapsedText: item.showMoreText,
                      trimExpandedText: item.showLessText,
                    ),
                  ),
                if (item.musicName != null) const SizedBox(height: 15),
                if (item.musicName != null)
                  Row(
                    children: [
                      const Icon(
                        Icons.music_note,
                        size: 15,
                        color: Colors.white,
                      ),
                      Text(
                        'Original Audio - ${item.musicName}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Column(
            children: [
              likeBtn,
              commentBtn,
              whatsAppBtn,
              savedBtn,
              shareBtn,
              moreBtn
            ],
          )
        ],
      ),
    );
  }

  Widget get moreBtn => Column(
        children: [
          if (onClickMoreBtn != null)
            InkWell(
              child: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              onTap: onClickMoreBtn!,
            ),
        ],
      );

  Widget get shareBtn => Column(
        children: [
          if (onShare != null)
            InkWell(
              child: const Icon(
                CupertinoIcons.reply,
                color: Colors.white,
                size: 30,
              ),
              onTap: () => onShare!(item),
            ),
          if (onShare != null) const SizedBox(height: 20),
        ],
      );

  Widget get savedBtn => Column(
        children: [
          if (onSaved != null)
            InkWell(
              child: Icon(
                item.isSaved ? Boxicons.bxs_bookmark : Boxicons.bx_bookmark,
                color: Colors.white,
                size: 30,
              ),
              onTap: () => onSaved!(item),
            ),
          if (onSaved != null) const SizedBox(height: 20),
        ],
      );

  Widget get whatsAppBtn => Column(
        children: [
          if (onWhatsAppClicked != null)
            InkWell(
              onTap: () => onWhatsAppClicked!(item),
              child: const Icon(
                Boxicons.bxl_whatsapp,
                color: Colors.white,
                size: 30,
              ),
            ),
          if (onWhatsAppClicked != null) const SizedBox(height: 20),
        ],
      );

  Widget get commentBtn => Column(
        children: [
          if (onComment != null)
            InkWell(
              onTap: () {
                onComment!(item);
                // showModalBottomSheet(
                //     barrierColor: Colors.transparent,
                //     context: context,
                //     builder: (ctx) => CommentBottomSheet(
                //         commentList: item.commentList ?? [],
                //         onComment: onComment));
              },
              child: const Icon(CupertinoIcons.conversation_bubble,
                  size: 30, color: Colors.white),
            ),
          // if (onComment != null)
          //   Text(
          //       NumbersToShort.convertNumToShort(
          //           item.commentList?.length ?? 0),
          //       style: const TextStyle(color: Colors.white)),
          if (onComment != null) const SizedBox(height: 20),
        ],
      );

  Widget get likeBtn => Column(
        children: [
          if (onLike != null && !item.isLiked)
            InkWell(
              onTap: () => onLike!(item),
              child: const Icon(Icons.favorite_outline,
                  size: 30, color: Colors.white),
            ),
          if (item.isLiked)
            InkWell(
              onTap: () => onLike!(item),
              child: const Icon(Icons.favorite_outline,
                  size: 30, color: Colors.red),
            ),
          Text(NumbersToShort.convertNumToShort(item.likeCount),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                height: 2,
              )),
          const SizedBox(height: 20),
        ],
      );
}
