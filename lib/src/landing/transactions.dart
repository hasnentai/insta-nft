import 'dart:async';

import 'package:insta_nft/contract.g.dart';
import 'package:insta_nft/src/wallet_connect/wallet_connect.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:web3dart/web3dart.dart';

late SessionStatus session;
late Contract _c;

const String contractAddress = "0xCc0937B05FA2041D3944a21Bd0c3457c51e59697";

Future<String> mintToken(
  EthereumTransactionTester ethTransction,
  address,
  tokenURI,
) async {
  _c = Contract(
    address: EthereumAddress.fromHex(contractAddress),
    client: ethTransction.ethereum,
  );
  final transaction = Transaction(
    to: EthereumAddress.fromHex(contractAddress),
    from: EthereumAddress.fromHex(address!),
    value: EtherAmount.fromUnitAndValue(EtherUnit.finney, 0),
  );

  final credentials = WalletConnectEthereumCredentials(
    provider: ethTransction.provider,
  );

  launchUrlString("dapp://google.com");

  String? trx = await _c.createNFT(
    EthereumAddress.fromHex(address!),
    tokenURI,
    credentials: credentials,
    transaction: transaction,
  );

  return trx;
}

disconnectWallet(ethTransction) => ethTransction.connector.killSession();
