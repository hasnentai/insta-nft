class InstagramConstant {
  static InstagramConstant? _instance;
  static InstagramConstant get instance {
    _instance ??= InstagramConstant._init();
    return _instance!;
  }

  InstagramConstant._init();

  //**
  /// Get the [ClientID] from facebook aka meta developer deshboard
  /// Get the [appSecret] from facebook aka meta developer deshboard
  // */
  static const String clientID = '';
  static const String appSecret = '';
  static const String redirectUri = 'https://httpstat.us/200';
  static const String scope = 'user_profile,user_media';
  static const String responseType = 'code';
  final String url =
      'https://api.instagram.com/oauth/authorize?client_id=$clientID&redirect_uri=$redirectUri&scope=user_profile,user_media&response_type=$responseType';
}
