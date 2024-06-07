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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 250),
                  Row(
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
                        width: 100,
                        child: Text(item.userName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 10),
                      if (showVerifiedTick)
                        const Icon(
                          Icons.verified,
                          size: 15,
                          color: Colors.white,
                        ),
                      if (showVerifiedTick) const SizedBox(width: 6),
                      if (onFollow != null)
                        InkWell(
                          onTap: () => onFollow!(item),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
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
                      //       fixedSize: Size(item.isFollowing ? 100 : 80, 30),
                      //       shape: RoundedRectangleBorder(
                      //         side: const BorderSide(color: Colors.white),
                      //         borderRadius: BorderRadius.circular(10),
                      //       )),
                      //   onPressed: () => onFollow!(item),
                      //   child:,
                      // ),
                    ],
                  ),
                  if (item.reelDescription != null &&
                      item.reelDescription != '')
                    const SizedBox(height: 6),
                  if (item.reelDescription != null &&
                      item.reelDescription != '')
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
                  if (item.musicName != null) const SizedBox(height: 10),
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
          ),
          Column(
            children: [
              if (onLike != null && !item.isLiked)
                IconButton(
                  icon: const Icon(Icons.favorite_outline, color: Colors.white),
                  onPressed: () => onLike!(item),
                ),
              if (item.isLiked)
                IconButton(
                  icon: const Icon(Icons.favorite_rounded, color: Colors.red),
                  onPressed: () => onLike!(item),
                ),
              Text(NumbersToShort.convertNumToShort(item.likeCount),
                  style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 15),
              if (onComment != null)
                IconButton(
                  icon: const Icon(Boxicons.bx_comment, color: Colors.white),
                  onPressed: () {
                    onComment!(item);
                    // showModalBottomSheet(
                    //     barrierColor: Colors.transparent,
                    //     context: context,
                    //     builder: (ctx) => CommentBottomSheet(
                    //         commentList: item.commentList ?? [],
                    //         onComment: onComment));
                  },
                ),
              // if (onComment != null)
              //   Text(
              //       NumbersToShort.convertNumToShort(
              //           item.commentList?.length ?? 0),
              //       style: const TextStyle(color: Colors.white)),
              if (onComment != null) const SizedBox(height: 15),
              if (onWhatsAppClicked != null)
                IconButton(
                  onPressed: () => onWhatsAppClicked!(item),
                  icon: const Icon(Boxicons.bxl_whatsapp, color: Colors.white),
                ),
              if (onWhatsAppClicked != null) const SizedBox(height: 15),
              if (onSaved != null)
                IconButton(
                  icon: Icon(
                    item.isSaved ? Boxicons.bxs_bookmark : Boxicons.bx_bookmark,
                  ),
                  onPressed: () => onSaved!(item),
                  color: Colors.white,
                ),
              if (onSaved != null) const SizedBox(height: 15),
              if (onShare != null)
                IconButton(
                  icon: const Icon(Boxicons.bxs_save),
                  onPressed: () => onShare!(item),
                  color: Colors.white,
                ),
              if (onShare != null) const SizedBox(height: 15),
              if (onClickMoreBtn != null)
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: onClickMoreBtn!,
                  color: Colors.white,
                ),
            ],
          )
        ],
      ),
    );
  }
}
