import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:insta_nft/src/instagram_auth/ig_user_media_model.dart';
import 'package:insta_nft/src/instagram_auth/instagram_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InstagramModel {
  List<String> userFields = ['id', 'username'];
  var completer = Completer<IgUserMedia>();
  String? authorizationCode;
  String? accessToken;
  String? userID;
  String? username;

  void getAuthorizationCode(String url) {
    authorizationCode = url
        .replaceAll('${InstagramConstant.redirectUri}?code=', '')
        .replaceAll('#_', '');
  }

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> setToken(String? token) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString('token', token!);
  }

  Future<bool> getTokenAndUserID() async {
    var url = Uri.parse('https://api.instagram.com/oauth/access_token');
    final response = await http.post(url, body: {
      'client_id': InstagramConstant.clientID,
      'redirect_uri': InstagramConstant.redirectUri,
      'client_secret': InstagramConstant.appSecret,
      'code': authorizationCode,
      'grant_type': 'authorization_code'
    });
    accessToken = json.decode(response.body)['access_token'];
    print(accessToken);
    setToken(accessToken);
    userID = json.decode(response.body)['user_id'].toString();
    return (accessToken != null && userID != null) ? true : false;
  }

  Future<bool> getUserProfile() async {
    final fields = userFields.join(',');
    final responseNode = await http.get(Uri.parse(
        'https://graph.instagram.com/$userID?fields=$fields&access_token=$accessToken'));
    var instaProfile = {
      'id': json.decode(responseNode.body)['id'].toString(),
      'username': json.decode(responseNode.body)['username'],
    };
    username = json.decode(responseNode.body)['username'];
    print('username: $username');
    return instaProfile.isNotEmpty ? true : false;
  }

  Future<IgUserMedia> getUserMedia(String? accessToken) async {
    IgUserMedia igUserMedia = IgUserMedia();
    final response = await http.get(Uri.parse(
        'https://graph.instagram.com/me/media?fields=id,caption,media_url,permalink,thumbnail_url,media_type&access_token=${accessToken!}'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      igUserMedia = IgUserMedia.fromJson(data);
    } else {
      print('Somthing went wrong');
    }

    return igUserMedia;
  }
}
