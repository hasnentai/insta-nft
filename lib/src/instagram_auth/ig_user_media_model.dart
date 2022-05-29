class IgUserMedia {
  List<Data>? data;
  Paging? paging;

  IgUserMedia({this.data, this.paging});

  IgUserMedia.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    paging = json['paging'] != null ? Paging.fromJson(json['paging']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (paging != null) {
      data['paging'] = paging!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? mediaUrl;
  String? permalink;
  String? mediaType;

  Data({this.id, this.mediaUrl, this.permalink, this.mediaType});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mediaUrl = json['media_url'];
    permalink = json['permalink'];
    mediaType = json['media_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['media_url'] = mediaUrl;
    data['permalink'] = permalink;
    data['media_type'] = mediaType;
    return data;
  }
}

class Paging {
  Cursors? cursors;

  Paging({this.cursors});

  Paging.fromJson(Map<String, dynamic> json) {
    cursors =
        json['cursors'] != null ? Cursors.fromJson(json['cursors']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cursors != null) {
      data['cursors'] = cursors!.toJson();
    }
    return data;
  }
}

class Cursors {
  String? before;
  String? after;

  Cursors({this.before, this.after});

  Cursors.fromJson(Map<String, dynamic> json) {
    before = json['before'];
    after = json['after'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['before'] = before;
    data['after'] = after;
    return data;
  }
}
