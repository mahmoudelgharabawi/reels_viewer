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
        height: 40,
        width: 40,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => const SizedBox(
        height: 20,
        width: 20,
        child: Icon(Icons.error),
      ),
    );
  }
}
