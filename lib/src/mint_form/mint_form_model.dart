class MintFormData {
  String? imageUrl;
  String? name;
  String? desc;
  String? instaUser;
  String? price;

  MintFormData(
      {this.imageUrl, this.name, this.desc, this.instaUser, this.price});

  Map toJson() => {
        "media_url": imageUrl,
        "name": name,
        "desc": desc,
        "insta-user": "@test.app.nft",
        "price": price
      };
}
