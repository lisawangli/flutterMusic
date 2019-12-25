import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_music/player_page.dart';

class MusicPlayerExample extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MusicPlayerState();
  }

}

class _MusicPlayerState extends State<MusicPlayerExample> with TickerProviderStateMixin{

  AnimationController controller_record;
  Animation<double> animation_record;
  Animation<double> animation_needle;
  AnimationController controller_needle;
  final _rotateTween = new Tween<double>(begin: -0.15,end: 0.0);
  final _commonTween = new Tween<double>(begin: 0.0,end: 1.0);
  final GlobalKey<_MusicPlayerState> musicPlayerKey = new GlobalKey();

  String coverArt =
      'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1577268895865&di=7a7dc817844d1fda0c15b99622fc4e53&imgtype=0&src=http%3A%2F%2Ffile02.16sucai.com%2Fd%2Ffile%2F2014%2F0829%2F372edfeb74c3119b666237bd4af92be5.jpg',
      mp3Url = 'https://demo.dj63.com//2018/%E4%B8%B2%E7%83%A7%E8%BD%A6%E8%BD%BD/20181104/DJ%E6%B2%BE%E5%BC%9F_%E5%85%A8%E4%B8%AD%E6%96%87%E5%9B%BD%E7%B2%A4%E8%AF%ADHouse%E9%9F%B3%E4%B9%90Dj%E7%95%AA%E8%96%AFBVsDj%E5%81%A5%E5%9B%9D%E5%80%BE%E5%8A%9B%E6%89%93%E9%80%A0%E4%B8%B2%E7%83%A7.mp3';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller_record = new AnimationController(
        duration:const Duration(milliseconds: 15000),vsync: this);
    animation_record = new CurvedAnimation(parent: controller_record, curve: Curves.linear);
    controller_needle = new AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this);
    animation_needle = new CurvedAnimation(parent: controller_needle, curve: Curves.linear);
    animation_record.addStatusListener((status){
       if(status==AnimationStatus.completed){
         controller_record.repeat();
       }else if(status==AnimationStatus.dismissed){
         controller_record.forward();
       }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: <Widget>[
        new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
                image: new NetworkImage(coverArt),
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(
                Colors.black54,
                  BlendMode.overlay
                 ),
            )
          ),
        ),
        new Container(
          child: new BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0,sigmaY: 10.0),
              child: Opacity(
                opacity: 0.6,
                child: new Container(
                  decoration: new BoxDecoration(
                    color: Colors.grey.shade900,
                  ),
                ),
              ),
          ),
        ),
        new Scaffold(
          backgroundColor: Colors.transparent,
          appBar: new AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Container(
              child: Text(
                'Shape of You - Ed Sheeran',
                style: new TextStyle(fontSize: 13.0),
              ),
            ),
          ),
          body: new Stack(
            alignment: const FractionalOffset(0.5, 0.0),
              children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
    child: new Player(
      onError: (e) {
        Scaffold.of(context).showSnackBar(
          new SnackBar(
            content: new Text(e),
          ),
        );
      },
      onPrevious: () {},
      onNext: () {},
      onCompleted: () {},
    onPlaying: (isPlaying) {
      if (isPlaying) {
        controller_record.forward();
        controller_needle.forward();
      } else {
        controller_record.stop(canceled: false);
        controller_needle.reverse();
      }
    },
      key: musicPlayerKey,
      color: Colors.white,
      audioUrl: mp3Url,
    ),
              ),
              ]
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller_record.dispose();
    controller_needle.dispose();
  }

}