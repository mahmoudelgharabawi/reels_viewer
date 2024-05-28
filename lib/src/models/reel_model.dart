import 'package:reels_viewer/reels_viewer.dart';
import 'package:reels_viewer/src/models/video_data.dart';

class ReelModel {
  final String? id;
  VideoData videoData;
  bool isLiked;
  int likeCount;
  final String userName;
  final String? profileUrl;
  final String? reelDescription;
  final String? musicName;
  final List<ReelCommentModel>? commentList;
  ReelModel(this.videoData, this.userName,
      {this.id,
      this.isLiked = false,
      this.likeCount = 0,
      this.profileUrl,
      this.reelDescription,
      this.musicName,
      this.commentList});
}
