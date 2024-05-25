import 'dart:convert';

import 'package:flutter/foundation.dart';

class VideoData {
  String? url;
  int? seconds;
  Uint8List? thumbNail;
  int? width;
  int? height;

  VideoData();

  VideoData.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    seconds = json['seconds'];
    thumbNail = json['thumbNail'] != null
        ? Uint8List.fromList(jsonDecode(json['thumbNail']).cast<int>().toList())
        : null;
    width = json['width'];
    height = json['height'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['url'] = url;
    data['seconds'] = seconds;
    data['thumbNail'] = thumbNail?.toString();
    data['width'] = width;
    data['height'] = height;
    return data;
  }
}
