import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';


final commonRepositoryProvider = Provider((ref) => CommonRepository());

class CommonRepository {
  Future<String> getCurrentPlatform() async{

    if(Platform.isIOS){
      return 'IOS';
    }else if (Platform.isAndroid){
      return 'Android';
    }
    return 'Web';
  }
}