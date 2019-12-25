import 'package:flutter/material.dart';
import 'MusicPlayerExample.dart';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
//        home: MusicPlayerExample(),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  AudioPlayer audioPlayer;
  Duration duration;
  Duration position;
  double sliderValue;

  String coverArt =
      'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1577268895865&di=7a7dc817844d1fda0c15b99622fc4e53&imgtype=0&src=http%3A%2F%2Ffile02.16sucai.com%2Fd%2Ffile%2F2014%2F0829%2F372edfeb74c3119b666237bd4af92be5.jpg',
      mp3Url = 'https://demo.dj63.com//2018/%E4%B8%B2%E7%83%A7%E8%BD%A6%E8%BD%BD/20181104/DJ%E6%B2%BE%E5%BC%9F_%E5%85%A8%E4%B8%AD%E6%96%87%E5%9B%BD%E7%B2%A4%E8%AF%ADHouse%E9%9F%B3%E4%B9%90Dj%E7%95%AA%E8%96%AFBVsDj%E5%81%A5%E5%9B%9D%E5%80%BE%E5%8A%9B%E6%89%93%E9%80%A0%E4%B8%B2%E7%83%A7.mp3';

  bool isPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    audioPlayer = new AudioPlayer();
    audioPlayer..durationHandler = ((duration){
      setState(() {
        this.duration = duration;
        if(position!=null){
          this.sliderValue = position.inSeconds/duration.inSeconds;
        }
      });
    })
    ..positionHandler = ((position){
      setState(() {
        this.position = position;
        if(duration!=null){
          this.sliderValue = position.inSeconds/duration.inSeconds;
        }
      });
    });
    play();
  }

  play() async{
    int result = await audioPlayer.play(mp3Url);
    if (result == 1) {
      // success
      print('play success');
    } else {
      print('play failed');
    }
  }

  pause()async{
    int result = await audioPlayer.pause();
    if(result==1){
      print("pause success");
    }else{
      print("pause failed");
    }
  }
  @override
  Widget build(BuildContext context) {
    
    return Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: new DecorationImage(image: new NetworkImage(coverArt),
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(Colors.black54, BlendMode.overlay)
              ),

            ),
          ),
    Container(
      child: new BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0,sigmaY: 10.0),
        child: Opacity(opacity: 0.6,
               child: new Container(
                 decoration: new BoxDecoration(
                   color: Colors.grey.shade900,
                 ),
               ),
        ),
      ),
    ),
    Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("音乐title"),
        backgroundColor: Colors.transparent,
      ),


      body: Container(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,

          children: <Widget>[
            Padding(padding: EdgeInsets.only(left: 25,right: 25,bottom: 5),
            child:  Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new IconButton(
                    icon: new Icon(Icons.skip_previous),
                    iconSize: 32,
                    color: Colors.white,
                    onPressed: (){

                    }),
                new IconButton(icon: new Icon(isPlaying?Icons.pause:Icons.play_arrow),
                    iconSize: 32,
                    color: Colors.white,
                    onPressed: (){
                      print("play======="+this.isPlaying.toString());
                      if(this.isPlaying){
                        play();
                      }else{
                        print("==pause=====");
                        audioPlayer.pause();
                      }
                      setState(() {
                        this.isPlaying = !isPlaying;

                      });
                    }),
                new IconButton(
                    icon: new Icon(Icons.skip_next),
                    iconSize: 32,
                    color: Colors.white,
                    onPressed: (){

                    }),
              ],
            ),),
            Slider(
                value: sliderValue??0.0,
                onChanged: (newValue){
                  if(duration!=null){
                    int seconds = (duration.inSeconds*newValue).round();
                    audioPlayer.seek(new Duration(seconds: seconds));
                  }
                }),

          ],

        ),
      ),
    ),
    ]
    );
//    return
    // This trailing comma makes auto-formatting nicer for build methods.
//    );
  }
}
