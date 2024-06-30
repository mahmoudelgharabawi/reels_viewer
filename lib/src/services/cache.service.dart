import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:reels_viewer/reels_viewer.dart';

abstract class CacheService {
  static CacheManager? cacheManager;

  static void cacheAllVideos(List<ReelModel> reelsList) async {
    cacheManager = CacheManager(
      Config(
        'reels',
        stalePeriod: const Duration(days: 3),
        maxNrOfCacheObjects: 30,
        repo: JsonCacheInfoRepository(databaseName: 'reels'),
        fileService: HttpFileService(),
      ),
    );
    if (reelsList.isNotEmpty) {
      for (int i = 0; i < reelsList.length; i++) {
        if (reelsList[i].videoData.url != null) {
          await cacheManager?.downloadFile(
            reelsList[i].videoData.url!,
          );
          // print('>>>>> video cached ${i} ');
        }
      }
    }
  }
}
