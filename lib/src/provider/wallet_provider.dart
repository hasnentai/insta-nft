import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

enum TransactionStatus { pending, success }

class WalletProvider extends ChangeNotifier {
  SessionStatus? _session;
  TransactionStatus? _status;

  SessionStatus? get session => _session;

  TransactionStatus? get status => _status;

  void setTransactionStatus(TransactionStatus? type) {
    _status = type;
    notifyListeners();
  }

  Future walletConnect(ethTransction) async {
    try {
      _session = await ethTransction.connector.createSession(
        chainId: 4,
        onDisplayUri: (uri) async => {
          await launchUrlString(
            uri,
          ),
        },
      );

      ethTransction.connector.on('connect', (session) => print(session));
      ethTransction.connector.on('session_update', (payload) => print(payload));
      ethTransction.connector.on('disconnect', (session) => print(session));

      notifyListeners();
    } catch (e) {
      return e.toString();
    }
  }
}
