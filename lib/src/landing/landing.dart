import 'package:flutter/material.dart';
import 'package:insta_nft/src/landing/transactions.dart';
import 'package:insta_nft/src/wallet_connect/wallet_connect.dart';
import 'package:insta_nft/src/instagram_auth/instagram_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);
  static const routeName = "/landing-page";
  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  final EthereumTransactionTester _ethTransction = EthereumTransactionTester();
  String? _address;
  bool isTokenPresent = false;
  String? _token;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> getToken() async {
    final SharedPreferences prefs = await _prefs;
    String? token = prefs.getString('token');
    setState(() {
      isTokenPresent = token != null ? token.isNotEmpty : false;
      _token = token;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
  }

  final InstagramModel instagram = InstagramModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            !_ethTransction.connector.connected
                ? MaterialButton(
                    onPressed: () async => {
                      // _address = await walletConnect(_ethTransction),
                      setState(() {})
                    },
                    child: const Text("Connect Wallet"),
                  )
                : MaterialButton(
                    onPressed: () => {disconnectWallet(_ethTransction)},
                    child: const Text("Disconnect Wallet"),
                  ),
            MaterialButton(
              onPressed: () => {print(_ethTransction.connector.connected)},
              child: const Text("Test Connection"),
            ),
            MaterialButton(
              onPressed: () => {
                //mintToken(_ethTransction, _address)
              },
              child: const Text("Itteract with contract"),
            ),
            MaterialButton(
              onPressed: () => {instagram.getUserMedia(_token)},
              child: const Text("Get Media"),
            ),
            _address != null ? Text(_address.toString()) : const SizedBox()
          ],
        ),
      ),
    );
  }
}
