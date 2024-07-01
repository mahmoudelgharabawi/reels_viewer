import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:reels_viewer/reels_viewer.dart';

abstract class CacheService {
  static CacheManager? cacheManager;

  static Future<void> cacheAllVideos(List<ReelModel> reelsList) async {
    int counter = 0;
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
          var cacheFile = (await CacheService.cacheManager!
              .getFileFromCache(reelsList[i].videoData.url!));
          if (cacheFile == null) {
            if (counter < 2) {
              await cacheManager?.downloadFile(
                reelsList[i].videoData.url!,
              );
            } else if (counter < 30) {
              cacheManager?.downloadFile(
                reelsList[i].videoData.url!,
              );
            } else {
              break;
            }
            counter++;
            print('>>>>> video cached ${i} ');
          } else {
            counter++;
            print('>>>>> Already video cached ${i}');
          }
        }
      }
    }
  }
}
