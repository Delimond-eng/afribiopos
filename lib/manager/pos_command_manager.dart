import 'dart:async';

import 'package:afribiopos01/models/pos_commande_model.dart';
import 'package:afribiopos01/services/http_service.dart';

class PosCommandsManager {
  final StreamController<int> _commandCount = StreamController<int>();

  Stream<int> get commandCount => _commandCount.stream;

  Stream<PosCommandes> get posCommandView async* {
    yield await HttpService.getPosCommands();
  }

  PosCommandsManager() {
    posCommandView
        .listen((dataList) => _commandCount.add(dataList.commandes.length));
  }
}
