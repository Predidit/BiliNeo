import 'package:bilineo/utils/em.dart';
import 'package:bilineo/utils/utils.dart';

class SearchVideoModel {
  SearchVideoModel({this.list});
  List<SearchVideoItemModel>? list;
  SearchVideoModel.fromJson(Map<String, dynamic> json) {
    list = json['result']
        .where((e) => e['available'] == true)
        .map<SearchVideoItemModel>((e) => SearchVideoItemModel.fromJson(e))
        .toList();
  }
}

class SearchVideoItemModel {
  SearchVideoItemModel({
    this.type,
    this.id,
    this.cid,
    // this.author,
    this.mid,
    // this.typeid,
    // this.typename,
    this.arcurl,
    this.aid,
    this.bvid,
    this.title,
    this.description,
    this.pic,
    // this.play,
    this.videoReview,
    // this.favorites,
    this.tag,
    // this.review,
    this.pubdate,
    this.senddate,
    this.duration,
    // this.viewType,
    // this.like,
    // this.upic,
    // this.danmaku,
    this.owner,
    this.stat,
    this.rcmdReason,
  });

  String? type;
  int? id;
  int? cid;
  // String? author;
  int? mid;
  // String? typeid;
  // String? typename;
  String? arcurl;
  int? aid;
  String? bvid;
  List? title;
  // List? titleList;
  String? description;
  String? pic;
  // String? play;
  int? videoReview;
  // String? favorites;
  String? tag;
  // String? review;
  int? pubdate;
  int? senddate;
  int? duration;
  // String? duration;
  // String? viewType;
  // String? like;
  // String? upic;
  // String? danmaku;
  Owner? owner;
  Stat? stat;
  String? rcmdReason;

  SearchVideoItemModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    arcurl = json['arcurl'];
    aid = json['aid'];
    bvid = json['bvid'];
    mid = json['mid'];
    // title = json['title'].replaceAll(RegExp(r'<.*?>'), '');
    title = Em.regTitle(json['title']);
    description = json['description'];
    pic = 'https:${json['pic']}';
    videoReview = json['video_review'];
    pubdate = json['pubdate'];
    senddate = json['senddate'];
    duration = Utils.duration(json['duration']);
    owner = Owner.fromJson(json);
    stat = Stat.fromJson(json);
  }
}

class Stat {
  Stat({
    this.view,
    this.danmaku,
    this.favorite,
    this.reply,
    this.like,
  });

  // 播放量
  int? view;
  // 弹幕数
  int? danmaku;
  // 收藏数
  int? favorite;
  // 评论数
  int? reply;
  // 喜欢
  int? like;

  Stat.fromJson(Map<String, dynamic> json) {
    view = json['play'];
    danmaku = json['danmaku'];
    favorite = json['favorite'];
    reply = json['review'];
    like = json['like'];
  }
}

class Owner {
  Owner({
    this.mid,
    this.name,
    this.face,
  });
  int? mid;
  String? name;
  String? face;

  Owner.fromJson(Map<String, dynamic> json) {
    mid = json["mid"];
    name = json["author"];
    face = json['upic'];
  }
}

class SearchUserModel {
  SearchUserModel({this.list});
  List<SearchUserItemModel>? list;
  SearchUserModel.fromJson(Map<String, dynamic> json) {
    list = json['result']
        .map<SearchUserItemModel>((e) => SearchUserItemModel.fromJson(e))
        .toList();
  }
}

class SearchUserItemModel {
  SearchUserItemModel({
    this.type,
    this.mid,
    this.uname,
    this.usign,
    this.fans,
    this.videos,
    this.upic,
    this.faceNft,
    this.faceNftType,
    this.verifyInfo,
    this.level,
    this.gender,
    this.isUpUser,
    this.isLive,
    this.roomId,
    this.officialVerify,
  });

  String? type;
  int? mid;
  String? uname;
  String? usign;
  int? fans;
  int? videos;
  String? upic;
  int? faceNft;
  int? faceNftType;
  String? verifyInfo;
  int? level;
  int? gender;
  int? isUpUser;
  int? isLive;
  int? roomId;
  Map? officialVerify;

  SearchUserItemModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    mid = json['mid'];
    uname = json['uname'];
    usign = json['usign'];
    fans = json['fans'];
    videos = json['videos'];
    upic = 'https:${json['upic']}';
    faceNft = json['face_nft'];
    faceNftType = json['face_nft_type'];
    verifyInfo = json['verify_info'];
    level = json['level'];
    gender = json['gender'];
    isUpUser = json['is_upuser'];
    isLive = json['is_live'];
    roomId = json['room_id'];
    officialVerify = json['official_verify'];
  }
}

class SearchLiveModel {
  SearchLiveModel({this.list});
  List<SearchLiveItemModel>? list;
  SearchLiveModel.fromJson(Map<String, dynamic> json) {
    list = json['result']
        .map<SearchLiveItemModel>((e) => SearchLiveItemModel.fromJson(e))
        .toList();
  }
}

class SearchLiveItemModel {
  SearchLiveItemModel({
    this.rankOffset,
    this.uid,
    this.tags,
    this.liveTime,
    this.uname,
    this.uface,
    this.face,
    this.userCover,
    this.type,
    this.title,
    this.cover,
    this.pic,
    this.online,
    this.rankIndex,
    this.rankScore,
    this.roomid,
    this.attentions,
    this.cateName,
  });

  int? rankOffset;
  int? uid;
  String? tags;
  String? liveTime;
  String? uname;
  String? uface;
  String? face;
  String? userCover;
  String? type;
  List? title;
  String? cover;
  String? pic;
  int? online;
  int? rankIndex;
  int? rankScore;
  int? roomid;
  int? attentions;
  String? cateName;
  Map? watchedShow;

  SearchLiveItemModel.fromJson(Map<String, dynamic> json) {
    rankOffset = json['rank_offset'];
    uid = json['uid'];
    tags = json['tags'];
    liveTime = json['live_time'];
    uname = json['uname'];
    uface = json['uface'];
    face = json['uface'];
    userCover = json['user_cover'];
    type = json['type'];
    title = Em.regTitle(json['title']);
    cover = json['cover'];
    pic = json['cover'];
    online = json['online'];
    rankIndex = json['rank_index'];
    rankScore = json['rank_score'];
    roomid = json['roomid'];
    attentions = json['attentions'];
    cateName = Em.regCate(json['cate_name']) ?? '';
  }
}

class SearchMBangumiModel {
  SearchMBangumiModel({this.list});
  List<SearchMBangumiItemModel>? list;
  SearchMBangumiModel.fromJson(Map<String, dynamic> json) {
    list = json['result'] != null
        ? json['result']
            .map<SearchMBangumiItemModel>(
                (e) => SearchMBangumiItemModel.fromJson(e))
            .toList()
        : [];
  }
}

class SearchMBangumiItemModel {
  SearchMBangumiItemModel({
    this.type,
    this.mediaId,
    this.title,
    this.orgTitle,
    this.mediaType,
    this.cv,
    this.staff,
    this.seasonId,
    this.isAvid,
    this.hitEpids,
    this.seasonType,
    this.seasonTypeName,
    this.url,
    this.buttonText,
    this.isFollow,
    this.isSelection,
    this.cover,
    this.areas,
    this.styles,
    this.gotoUrl,
    this.desc,
    this.pubtime,
    this.mediaMode,
    this.mediaScore,
    this.indexShow,
  });

  String? type;
  int? mediaId;
  List? title;
  String? orgTitle;
  int? mediaType;
  String? cv;
  String? staff;
  int? seasonId;
  bool? isAvid;
  String? hitEpids;
  int? seasonType;
  String? seasonTypeName;
  String? url;
  String? buttonText;
  int? isFollow;
  int? isSelection;
  String? cover;
  String? areas;
  String? styles;
  String? gotoUrl;
  String? desc;
  int? pubtime;
  int? mediaMode;
  Map? mediaScore;
  String? indexShow;

  SearchMBangumiItemModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    mediaId = json['media_id'];
    title = Em.regTitle(json['title']);
    orgTitle = json['org_title'];
    mediaType = json['media_type'];
    cv = json['cv'];
    staff = json['staff'];
    seasonId = json['season_id'];
    isAvid = json['is_avid'];
    hitEpids = json['hit_epids'];
    seasonType = json['season_type'];
    seasonTypeName = json['season_type_name'];
    url = json['url'];
    buttonText = json['button_text'];
    isFollow = json['is_follow'];
    isSelection = json['is_selection'];
    cover = json['cover'];
    areas = json['areas'];
    styles = json['styles'];
    gotoUrl = json['goto_url'];
    desc = json['desc'];
    pubtime = json['pubtime'];
    mediaMode = json['media_mode'];
    mediaScore = json['media_score'];
    indexShow = json['index_show'];
  }
}

class SearchArticleModel {
  SearchArticleModel({this.list});

  List<SearchArticleItemModel>? list;

  SearchArticleModel.fromJson(Map<String, dynamic> json) {
    list = json['result'] != null
        ? json['result']
            .map<SearchArticleItemModel>(
                (e) => SearchArticleItemModel.fromJson(e))
            .toList()
        : [];
  }
}

class SearchArticleItemModel {
  SearchArticleItemModel({
    this.pubTime,
    this.like,
    this.title,
    this.subTitle,
    this.rankOffset,
    this.mid,
    this.imageUrls,
    this.id,
    this.categoryId,
    this.view,
    this.reply,
    this.desc,
    this.rankScore,
    this.type,
    this.templateId,
    this.categoryName,
  });

  int? pubTime;
  int? like;
  List? title;
  String? subTitle;
  int? rankOffset;
  int? mid;
  List? imageUrls;
  int? id;
  int? categoryId;
  int? view;
  int? reply;
  String? desc;
  int? rankScore;
  String? type;
  int? templateId;
  String? categoryName;

  SearchArticleItemModel.fromJson(Map<String, dynamic> json) {
    pubTime = json['pub_time'];
    like = json['like'];
    title = Em.regTitle(json['title']);
    subTitle = json['title'].replaceAll(RegExp(r'<[^>]*>'), '');
    rankOffset = json['rank_offset'];
    mid = json['mid'];
    imageUrls = json['image_urls'];
    id = json['id'];
    categoryId = json['category_id'];
    view = json['view'];
    reply = json['reply'];
    desc = json['desc'];
    rankScore = json['rank_score'];
    type = json['type'];
    templateId = json['templateId'];
    categoryName = json['category_name'];
  }
}
