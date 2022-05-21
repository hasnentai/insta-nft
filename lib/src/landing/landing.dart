import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart';
import 'package:insta_nft/contract.g.dart';
import 'package:insta_nft/src/wallet_connect/wallet_connect.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:web3dart/web3dart.dart';

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  late SessionStatus session;
  late Contract _c;
  final EthereumTransactionTester _ethTransction = EthereumTransactionTester();
  String? _address;
  final client =
      Web3Client("https://data-seed-prebsc-1-s1.binance.org:8545/", Client());

  writeValue() async {
    _c = Contract(
        address: EthereumAddress.fromHex(
            "0x3087722aF2770644052F77535543d42a8B1da550"),
        client: client);
    final transaction = Transaction(
      to: EthereumAddress.fromHex("0x3087722aF2770644052F77535543d42a8B1da550"),
      from: EthereumAddress.fromHex(_address!),
      value: EtherAmount.fromUnitAndValue(EtherUnit.finney, 0),
    );

    final credentials =
        WalletConnectEthereumCredentials(provider: _ethTransction.provider);
    launchUrlString("https://metamask.app.link/");
    // WalletConnectEthereumCredentials credentials =
    //     WalletConnectEthereumCredentials(provider: _ethTransction.provider);
    var s = await _c.addVal(BigInt.from(100.0),
        credentials: credentials, transaction: transaction);
    print(s);
  }

  getValue() async {
    _c = Contract(
        address: EthereumAddress.fromHex(
            "0x7dD4b42819b968afA8EF48Bae3C76620cDb4b7e1"),
        client: client);
    var val = await _c.displayHello();
    print(val);
  }

  walletConnect() async {
    try {
      session = await _ethTransction.connector.createSession(
          chainId: 97,
          onDisplayUri: (uri) async =>
              {print(uri), await launchUrlString(uri)});
      print(session.accounts);
      setState(() {
        _address = session.accounts[0];
      });
    } catch (e) {
      print(e);
    }
//Subscribe to events
    _ethTransction.connector.on("connect", (_session) {
      //  _c = Contract(address:session. , client: client)
    });
    _ethTransction.connector
        .on('session_update', (payload) => {print(payload), setState(() {})});
    _ethTransction.connector
        .on('disconnect', (_session) => {print(_session), setState(() {})});
    // print(connector);
  }

  disconnectWallet() => _ethTransction.disconnect();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            !_ethTransction.connector.connected
                ? MaterialButton(
                    onPressed: () => {walletConnect()},
                    child: const Text("Connect Wallet"),
                  )
                : MaterialButton(
                    onPressed: () => {disconnectWallet()},
                    child: const Text("Disconnect Wallet"),
                  ),
            MaterialButton(
              onPressed: () => {print(_ethTransction.connector.connected)},
              child: const Text("Test Connection"),
            ),
            MaterialButton(
              onPressed: () => {writeValue()},
              child: const Text("Itteract with contract"),
            ),
            MaterialButton(
              onPressed: () => {getValue()},
              child: const Text("Itteract with contract read"),
            ),
            _address != null ? Text(_address.toString()) : const SizedBox()
          ],
        ),
      ),
    );
  }
}
