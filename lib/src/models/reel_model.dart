import 'package:reels_viewer/reels_viewer.dart';
import 'package:reels_viewer/src/models/video_data.dart';

class ReelModel {
  final String? id;
  VideoData videoData;
  bool isLiked;
  bool isFollowing;
  int likeCount;
  String followingText;
  String followText;
  String showMoreText;
  String showLessText;
  final String userName;
  final String? profileUrl;
  final String? reelDescription;
  final String? musicName;
  final List<ReelCommentModel>? commentList;
  ReelModel(this.videoData, this.userName,
      {this.id,
      this.isLiked = false,
      this.isFollowing = false,
      this.likeCount = 0,
      this.followingText = 'Following',
      this.followText = 'Follow',
      this.showMoreText = 'Show More',
      this.showLessText = 'Show Less',
      this.profileUrl,
      this.reelDescription,
      this.musicName,
      this.commentList});
}
