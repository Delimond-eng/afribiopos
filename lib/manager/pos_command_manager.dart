import 'dart:async';

import 'package:afribiopos01/models/pos_commande_model.dart';
import 'package:afribiopos01/services/http_service.dart';
import 'package:flutter_beep/flutter_beep.dart';

class PosCommandsManager {
  final StreamController<int> _commandCount = StreamController<int>();

  Stream<int> get commandCount{
    FlutterBeep.playSysSound(AndroidSoundIDs.TONE_CDMA_ABBR_ALERT);
    return _commandCount.stream;
  }

  Stream<PosCommandes> get posCommandView async* {
    while(true){
      await Future.delayed(Duration(milliseconds: 500));
      yield await HttpService.getPosCommands();
    }
  }

  PosCommandsManager() {
    posCommandView
        .listen((dataList){
          return _commandCount.add(dataList.commandes.length);
    });
  }
}
