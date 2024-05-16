import 'dart:typed_data';

import 'package:reels_viewer/reels_viewer.dart';

class ReelModel {
  final String? id;
  final String url;
  final Uint8List? videoThumbnail;
  final bool isLiked;
  final int likeCount;
  final String userName;
  final String? profileUrl;
  final String? reelDescription;
  final String? musicName;
  final List<ReelCommentModel>? commentList;
  ReelModel(this.url, this.userName,
      {this.id,
      this.videoThumbnail,
      this.isLiked = false,
      this.likeCount = 0,
      this.profileUrl,
      this.reelDescription,
      this.musicName,
      this.commentList});
}
