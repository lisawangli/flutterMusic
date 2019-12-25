import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class Player extends StatefulWidget{

  //播放地址
  final String audioUrl;

  //音量
  final double volume;

  //错误回调
  final Function(String) onError;

  //播放完成
  final Function() onCompleted;

  //上一首
  final Function onPrevious;

  //下一首
  final Function onNext;

  final Function(bool) onPlaying;

  final Key key;

  final Color color;

  //是否是本地资源
  final bool isLocal;

  const Player({
    @required this.audioUrl,
    @required this.onCompleted,
    @required this.onError,
    @required this.onNext,
    @required this.onPrevious,
    this.key,
    this.volume: 1.0,
    this.onPlaying,
    this.color:Colors.white,
    this.isLocal:false
  });

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PlayState();
  }

}

class _PlayState extends State<Player>{
  AudioPlayer audioPlayer;
  bool isPlaying = false;
  Duration duration;
  Duration position;
  double sliderValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    audioPlayer = new AudioPlayer();
    audioPlayer
      ..completionHandler = widget.onCompleted
      ..errorHandler = widget.onError
      ..durationHandler = ((duration){
        setState(() {
          this.duration = duration;
          if(position!=null){
            this.sliderValue = position.inSeconds/duration.inSeconds;
          }
        });
      })
    ..positionHandler=((position){
      setState(() {
        this.position = position;
        if(duration!=null){
          this.sliderValue = position.inSeconds/duration.inSeconds;
        }
      });
    });
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    audioPlayer.stop();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    audioPlayer.release();
  }

  String _formatDuration(Duration d){
    int minute = d.inMinutes;
    int second = d.inSeconds>60?d.inSeconds%60:d.inSeconds;
    String foramt = ((minute<10)?"0$minute":"$minute")+":"+((second<10)?"0$second":"$second");
    return foramt;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.end,
      children:  _controllers(context),
    );
  }

  List<Widget> _controllers(BuildContext context) {

    return [
      const Divider(color: Colors.transparent,),
      const Divider(
        color: Colors.transparent,
        height: 32,
      ),
      new Padding(padding: const EdgeInsets.symmetric(horizontal: 32),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new IconButton(
                  icon: new Icon(Icons.skip_previous, 
                  size: 32,
                  color: widget.color,),
                  onPressed: (){
                    widget.onPrevious();
                  }
            ),
            new IconButton(icon: new Icon(
              isPlaying?Icons.pause:Icons.play_arrow,
              size: 48,
              color: widget.color,
            ),
                onPressed: (){
                  if(isPlaying){
                    audioPlayer.pause();
                  }else{
                    audioPlayer.play(
                        widget.audioUrl,
                        isLocal: widget.isLocal,
                        volume:  widget.volume
                    );
                  }
                  setState(() {
                    isPlaying = !isPlaying;
                    widget.onPlaying(isPlaying);
                  });
                },
              padding: const EdgeInsets.all(0.0),
                ),
            new IconButton(icon: new Icon(
                Icons.skip_next,
                size: 32,
              color: widget.color,
            ),
                onPressed: widget.onNext
            ),
            
          ],
        ),
      ),
      new Slider(
          value: sliderValue??0.0,
          activeColor:widget.color,
          onChanged: (newValue){
            if(duration!=null){
              int seconds = (duration.inSeconds*newValue).round();
              audioPlayer.seek(new Duration(seconds: seconds));
            }
          }),
      new Padding(padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8
      ),
        child:  _timer(context),
      )
    ];

  }

  Widget _timer(BuildContext context) {
    var style = new TextStyle(color: widget.color);
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        new Text(
          position ==null?"--:--":_formatDuration(position),
          style: style,
        ),
        new Text(
          duration==null?"--:--":_formatDuration(duration),
          style: style,
        ),
      ],
    );
  }

}