import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:insta_nft/src/instagram_auth/instagram_constant.dart';
import 'package:insta_nft/src/instagram_auth/instagram_model.dart';
import 'package:insta_nft/src/instagram_photos/instagram_photo_view.dart';
import 'package:insta_nft/src/landing/landing.dart';
import 'package:insta_nft/src/mint_form/mint_form_view.dart';

class InstagramView extends StatefulWidget {
  const InstagramView({Key? key}) : super(key: key);
  static const routeName = '/instagram-login';

  @override
  State<InstagramView> createState() => _InstagramViewState();
}

class _InstagramViewState extends State<InstagramView> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final webview = FlutterWebviewPlugin();
      final InstagramModel instagram = InstagramModel();

      buildRedirectToHome(webview, instagram, context);

      return WebviewScaffold(
        url: InstagramConstant.instance.url,
        resizeToAvoidBottomInset: true,
        appBar: buildAppBar(context),
      );
    });
  }

  Future<void> buildRedirectToHome(FlutterWebviewPlugin webview,
      InstagramModel instagram, BuildContext context) async {
    webview.onUrlChanged.listen((String url) async {
      if (url.contains(InstagramConstant.redirectUri)) {
        instagram.getAuthorizationCode(url);
        if (url.contains('${InstagramConstant.redirectUri}?code=')) {
          await instagram.getTokenAndUserID().then((isDone) {
            if (isDone) {
              instagram.getUserProfile().then((isDone) async {
                await webview.close();
                await Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const MintFormView()),
                );
              });
            }
          });
        }
      }
    });
  }

  AppBar buildAppBar(BuildContext context) => AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Instagram Login',
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: Colors.black),
        ),
      );
}
