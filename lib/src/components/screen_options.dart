import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reels_viewer/reels_viewer.dart';
import 'package:reels_viewer/src/components/user_profile_image.dart';
import 'package:reels_viewer/src/utils/convert_numbers_to_short.dart';
import 'package:rich_readmore/rich_readmore.dart';

class ScreenOptions extends StatelessWidget {
  final ReelModel item;
  final bool showVerifiedTick;
  final Function(ReelModel)? onShare;
  final Function(ReelModel)? onLike;
  final Function(String)? onComment;
  final Function()? onClickMoreBtn;
  final Function()? onFollow;

  const ScreenOptions({
    Key? key,
    required this.item,
    this.showVerifiedTick = true,
    this.onClickMoreBtn,
    this.onComment,
    this.onFollow,
    this.onLike,
    this.onShare,
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
                  const SizedBox(height: 160),
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
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              minimumSize: Size(90, 30),
                              fixedSize: Size(90, 30)),
                          onPressed: onFollow,
                          child: Text(
                            item.isFollowing
                                ? item.followingText
                                : item.followText,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 6),
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
                  const SizedBox(height: 10),
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
              const SizedBox(height: 20),
              IconButton(
                icon: const Icon(Icons.comment_rounded, color: Colors.white),
                onPressed: () {
                  // if (onComment != null) {
                  //   showModalBottomSheet(
                  //       barrierColor: Colors.transparent,
                  //       context: context,
                  //       builder: (ctx) => CommentBottomSheet(
                  //           commentList: item.commentList ?? [],
                  //           onComment: onComment));
                  // }
                },
              ),
              Text(
                  NumbersToShort.convertNumToShort(
                      item.commentList?.length ?? 0),
                  style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 20),
              if (onShare != null)
                InkWell(
                  onTap: () => onShare!(item),
                  child: Transform(
                    transform: Matrix4.rotationZ(5.8),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
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
