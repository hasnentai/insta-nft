import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:insta_nft/src/instagram_auth/ig_user_media_model.dart';
import 'package:insta_nft/src/instagram_auth/instagram_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InstagramPhotoSelection extends StatefulWidget {
  const InstagramPhotoSelection({Key? key, required this.selectImage})
      : super(key: key);
  final Function selectImage;
  @override
  State<InstagramPhotoSelection> createState() =>
      _InstagramPhotoSelectionState();
}

class _InstagramPhotoSelectionState extends State<InstagramPhotoSelection> {
  final InstagramModel _instagramModel = InstagramModel();
  IgUserMedia _igUserMedia = IgUserMedia();

  bool isTokenPresent = false;
  String? _token;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> getToken() async {
    final SharedPreferences prefs = await _prefs;
    String? token = prefs.getString('token');
    _igUserMedia = await _instagramModel.getUserMedia(token);
    if (mounted) {
      setState(() {
        isTokenPresent = token != null ? token.isNotEmpty : false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Image to Upload"),
      ),
      body: Container(
        padding: const EdgeInsets.all(12.0),
        child: isTokenPresent
            ? _igUserMedia.data!.isNotEmpty
                ? renderImageGridView()
                : Container()
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  GridView renderImageGridView() {
    return GridView.builder(
      itemCount: _igUserMedia.data!.length,
      gridDelegate: sliverGridDelegateWithFixedCrossAxisCount(),
      itemBuilder: (BuildContext context, int index) {
        return renderNetworkImage(index);
      },
    );
  }

  GestureDetector renderNetworkImage(int index) {
    return GestureDetector(
      onTap: () => {
        widget.selectImage(_igUserMedia.data![index].mediaUrl!),
        Navigator.pop(context)
      },
      child: Image.network(
        _igUserMedia.data![index].mediaUrl!,
        fit: BoxFit.cover,
      ),
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount
      sliverGridDelegateWithFixedCrossAxisCount() {
    return const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0);
  }
}
