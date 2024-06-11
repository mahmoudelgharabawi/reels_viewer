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

  TextStyle get mainSpanTextStyle => const TextStyle(
        fontSize: 15,
        color: Colors.white,
      );
  TextStyle get moreLessTextStyle => const TextStyle(
      fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      item.userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
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
                if (item.reelDescription != null && item.reelDescription != '')
                  const SizedBox(height: 8),
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
          Container(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                profileBtn,
                likeBtn,
                commentBtn,
                // whatsAppBtn,
                savedBtn,
                shareBtn,
                moreBtn
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget get profileBtn => Stack(
        children: [
          Column(
            children: [
              if (item.profileUrl != null)
                UserProfileImage(profileUrl: item.profileUrl ?? ''),
              if (item.profileUrl == null)
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Text(
                    item.userName[0].toUpperCase(),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              const SizedBox(height: 16)
            ],
          ),
          Positioned.fill(
            bottom: 10,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: CircleAvatar(
                child: item.isFollowing
                    ? Icon(
                        Icons.check,
                        size: 12,
                      )
                    : Icon(
                        Icons.add,
                        size: 12,
                      ),
                radius: 8,
              ),
            ),
          )
        ],
      );

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
          if (onShare != null) const SizedBox(height: 16),
        ],
      );

  Widget get savedBtn => Column(
        children: [
          if (onSaved != null)
            InkWell(
              child: Icon(
                item.isSaved ? Icons.bookmark_border : Icons.bookmark,
                color: Colors.white,
              ),
              onTap: () => onSaved!(item),
            ),
          if (onSaved != null) const SizedBox(height: 4),
          if (onSaved != null)
            Text(NumbersToShort.convertNumToShort(item.likeCount),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                )),
          if (onSaved != null) const SizedBox(height: 16),
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
          if (onWhatsAppClicked != null) const SizedBox(height: 16),
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
              child:
                  const Icon(Icons.mode_comment_outlined, color: Colors.white),
            ),
          const SizedBox(height: 4),
          Text(NumbersToShort.convertNumToShort(item.likeCount),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              )),
          // if (onComment != null)
          //   Text(
          //       NumbersToShort.convertNumToShort(
          //           item.commentList?.length ?? 0),
          //       style: const TextStyle(color: Colors.white)),
          if (onComment != null) const SizedBox(height: 16),
        ],
      );

  Widget get likeBtn => Column(
        children: [
          if (onLike != null && !item.isLiked)
            InkWell(
              onTap: () => onLike!(item),
              child: const Icon(Icons.favorite_outline, color: Colors.white),
            ),
          if (item.isLiked)
            InkWell(
              onTap: () => onLike!(item),
              child: const Icon(Icons.favorite, size: 30, color: Colors.red),
            ),
          const SizedBox(height: 4),
          Text(NumbersToShort.convertNumToShort(item.likeCount),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              )),
          const SizedBox(height: 16),
        ],
      );
}
  // if (onFollow != null)
                    //   InkWell(
                    //     onTap: () => onFollow!(item),
                    //     child: Container(
                    //       decoration: BoxDecoration(
                    //         border: Border.all(color: Colors.white),
                    //         borderRadius: BorderRadius.circular(15),
                    //       ),
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: Text(
                    //           item.isFollowing
                    //               ? item.followingText
                    //               : item.followText,
                    //           style: const TextStyle(
                    //             color: Colors.white,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),