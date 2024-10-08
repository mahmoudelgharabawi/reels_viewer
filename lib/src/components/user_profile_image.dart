import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserProfileImage extends StatelessWidget {
  final String profileUrl;
  const UserProfileImage({Key? key, required this.profileUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: profileUrl,
      alignment: Alignment.centerLeft,
      imageBuilder: (context, imageProvider) => Container(
        height: 56,
        width: 56,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(50),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        height: 56,
        width: 56,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.grey,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        height: 56,
        width: 56,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.grey,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
