import 'package:flutter/material.dart';
import 'package:funny_video/model/Album.dart';
import 'package:funny_video/provider/api.dart';
import 'package:funny_video/theme/colors.dart';
import 'package:funny_video/widget/column_social_icon.dart';
import 'package:funny_video/widget/header_home_page.dart';
import 'package:funny_video/widget/left_panel.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TabController _tabController;
  Future<List<Album>> album;

  List<Album> items = [];

  @override
  void initState() {
    // fetchAlbumList();
    // TODO: implement initState
    super.initState();
  }

  // fetchAlbumList() async {
  //   album = fetchAlbum();
  //   List<Album> l = await album;
  //   l.forEach((element) {
  //     print("eeeeee" + element.title);
  //   });
  //   items.addAll(l);
  //   // _tabController = _makeNewTabController();
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return getBody();
    var size = MediaQuery.of(context).size;

    return FutureBuilder<List<Album>>(
      future: fetchAlbum(),
      builder: (c, s) {
        if (s.hasData) {
          _tabController = TabController(
            vsync: this,
            length: s.data.length,
          );
          return RotatedBox(
              quarterTurns: 1,
              child: TabBarView(
                  controller: _tabController,
                  children: List.generate(s.data.length, (index) {
                    print(s.data[index].user);
                    return VideoPlayerItem(
                      videoUrl: s.data[index].url,
                      size: size,
                      name: s.data[index].user.name,
                      caption: s.data[index].title,
                      songName: "",
                      profileImg: s.data[index].user.headshot,
                      likes: s.data[index].likeCount.toString(),
                      comments: s.data[index].commentCount.toString(),
                      shares: s.data[index].shareCount.toString(),
                      albumImg: s.data[index].user.headshot.toString(),
                    );
                  })));
        }
        if (s.hasError) print(s.error.toString());
        return Scaffold(
            body: Center(
                child: s.hasError
                    ? Text(s.error.toString())
                    : CircularProgressIndicator()));
      },
    );
  }

  // Widget getBody() {
  //   var size = MediaQuery.of(context).size;
  //   return RotatedBox(
  //     quarterTurns: 1,
  //     child: TabBarView(
  //       controller: _tabController,
  //       children: List.generate(items.length, (index) {
  //         print(items[index].user);
  //         return VideoPlayerItem(
  //           videoUrl: items[index].url,
  //           size: size,
  //           name: items[index].user.name,
  //           caption: items[index].title,
  //           songName: "xyz",
  //           profileImg: items[index].user.headshot,
  //           likes: items[index].likeCount.toString(),
  //           comments: items[index].commentCount.toString(),
  //           shares: items[index].shareCount.toString(),
  //           albumImg: items[index].user.headshot.toString(),
  //         );
  //       }),
  //     ),
  //   );
  // }
}

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final String name;
  final String caption;
  final String songName;
  final String profileImg;
  final String likes;
  final String comments;
  final String shares;
  final String albumImg;
  VideoPlayerItem(
      {Key key,
      @required this.size,
      this.name,
      this.caption,
      this.songName,
      this.profileImg,
      this.likes,
      this.comments,
      this.shares,
      this.albumImg,
      this.videoUrl})
      : super(key: key);

  final Size size;

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  VideoPlayerController _videoController;
  bool isShowPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _videoController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        _videoController.play();
        setState(() {
          isShowPlaying = false;
        });
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _videoController.dispose();
  }

  Widget isPlaying() {
    return _videoController.value.isPlaying && !isShowPlaying
        ? Container()
        : Icon(
            Icons.play_arrow,
            size: 80,
            color: white.withOpacity(0.5),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          setState(() {
            _videoController.value.isPlaying
                ? _videoController.pause()
                : _videoController.play();
          });
        },
        child: RotatedBox(
          quarterTurns: -1,
          child: Container(
              height: widget.size.height,
              width: widget.size.width,
              child: Stack(
                children: <Widget>[
                  Container(
                    height: widget.size.height,
                    width: widget.size.width,
                    decoration: BoxDecoration(color: black),
                    child: Stack(
                      children: <Widget>[
                        VideoPlayer(_videoController),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(),
                            child: isPlaying(),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: widget.size.height,
                    width: widget.size.width,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 15, top: 20, bottom: 10),
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            HeaderHomePage(),
                            Expanded(
                                child: Row(
                              children: <Widget>[
                                LeftPanel(
                                  size: widget.size,
                                  name: "${widget.name}",
                                  caption: "${widget.caption}",
                                  songName: "${widget.songName}",
                                ),
                                RightPanel(
                                  size: widget.size,
                                  likes: "${widget.likes}",
                                  comments: "${widget.comments}",
                                  shares: "${widget.shares}",
                                  profileImg: "${widget.profileImg}",
                                  albumImg: "${widget.albumImg}",
                                )
                              ],
                            ))
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}

class RightPanel extends StatelessWidget {
  final String likes;
  final String comments;
  final String shares;
  final String profileImg;
  final String albumImg;
  const RightPanel({
    Key key,
    @required this.size,
    this.likes,
    this.comments,
    this.shares,
    this.profileImg,
    this.albumImg,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: size.height,
        child: Column(
          children: <Widget>[
            Container(
              height: size.height * 0.5,
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                getProfile(profileImg),
                getIcons(IconData(0xe808, fontFamily: 'TikTokIcons'), comments,
                    35.0),
                getIcons(
                    IconData(0xe80e, fontFamily: 'TikTokIcons'), shares, 25.0),
                getAlbum(albumImg)
              ],
            ))
          ],
        ),
      ),
    );
  }
}
