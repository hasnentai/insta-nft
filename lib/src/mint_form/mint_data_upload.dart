import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:insta_nft/src/landing/transactions.dart';
import 'package:insta_nft/src/wallet_connect/wallet_connect.dart';
import 'package:path_provider/path_provider.dart';

class UploadJsonFileToIPFS {
  Future<String?> uploadFile(
    String content,
    EthereumTransactionTester ethereumTransactionTester,
    String accounts,
  ) async {
    File jsonFile;
    Directory dir;
    String fileName =
        'my-insta-nft-${DateTime.now().millisecondsSinceEpoch}.json';
    String ipfsFileHash;
    try {
      String hash = await getApplicationSupportDirectory()
          .then((Directory directory) async {
        dir = directory;
        File file = createFile(content, dir, fileName);
        var uri = Uri.parse('https://api.pinata.cloud/pinning/pinFileToIPFS');

        var jsonFile = file.readAsBytesSync();

        /**
         * 
         * GET the keys from pinata.
         */

        Map<String, String> headers = <String, String>{
          "Content-Type": 'multipart/form-data',
          "pinata_api_key": "",
          "pinata_secret_api_key": "",
        };

        var request = http.MultipartRequest('POST', uri);
        request.files.add(
          http.MultipartFile(
              'file', file.readAsBytes().asStream(), file.lengthSync(),
              filename: fileName.split("/").last),
        );
        request.headers.addAll(headers);
        var res = await request.send();
        var responseData = await res.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        print(responseString);
        ipfsFileHash = jsonDecode(responseString.toString())["IpfsHash"];
        String tokenURI = 'https://gateway.pinata.cloud/ipfs/$ipfsFileHash';
        String? trx =
            await mintToken(ethereumTransactionTester, accounts, tokenURI);
        return trx;
      });
      return hash;
    } catch (e) {
      print(e);
      throw Exception("Somthing went wrong");
    }
  }

  File createFile(String content, Directory dir, String fileName) {
    File file = File('${dir.path}/$fileName');
    file.createSync();
    file.writeAsStringSync(content);
    return file;
  }
}
