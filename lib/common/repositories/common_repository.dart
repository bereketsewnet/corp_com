import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';


final commonRepositoryProvider = Provider((ref) => CommonRepository());

final currentUserProvider = FutureProvider((ref) {
  final commonRepository = ref.watch(commonRepositoryProvider);
  return commonRepository.getCurrentPlatform();
});

class CommonRepository {
  Future<String> getCurrentPlatform() async{

    if(Platform.isIOS || Platform.isMacOS){
      return 'IOS';
    }else if (Platform.isAndroid || Platform.isWindows){
      return 'Android';
    }
    return 'Web';
  }
}