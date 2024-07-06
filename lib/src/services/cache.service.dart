import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:reels_viewer/reels_viewer.dart';

abstract class CacheService {
  static CacheManager? cacheManager;

  static void cacheVideoIfNotCached(ReelModel reelModel) async {
    var cacheFile = (await CacheService.cacheManager!
        .getFileFromCache(reelModel.videoData.url!));
    if (cacheFile == null) {
      // only two must be cached before first launch
      cacheManager?.downloadFile(
        reelModel.videoData.url!,
      );

      print('>>>>> video cached Ex');
    } else {
      print('>>>>> Already video cached Ex');
    }
  }

  static void init() {
    cacheManager = CacheManager(
      Config(
        'reels',
        stalePeriod: const Duration(days: 3),
        maxNrOfCacheObjects: 30,
        repo: JsonCacheInfoRepository(databaseName: 'reels'),
        fileService: HttpFileService(),
      ),
    );
  }

  static Future<void> cacheVideos(List<ReelModel> reelsList) async {
    int counter = 0;

    if (reelsList.isNotEmpty) {
      // already will be cached through playing video
      reelsList.removeAt(0);
      int checkLength = 0;
      // only 10 videos to be cached when first launch
      if (reelsList.length < 2) {
        checkLength = reelsList.length;
      } else {
        checkLength = 2;
      }
      for (int i = 0; i < checkLength; i++) {
        if (reelsList[i].videoData.url != null) {
          var cacheFile = (await CacheService.cacheManager!
              .getFileFromCache(reelsList[i].videoData.url!));
          if (cacheFile == null) {
            cacheManager?.downloadFile(
              reelsList[i].videoData.url!,
            );
            // // only two must be cached before first launch
            // if (counter < 2) {
            //   await cacheManager?.downloadFile(
            //     reelsList[i].videoData.url!,
            //   );
            // } else {
            //   cacheManager?.downloadFile(
            //     reelsList[i].videoData.url!,
            //   );
            // }
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
