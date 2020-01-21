import 'dart:async';
import 'dart:developer';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Color(0xFF81B3FE),
  _Element.text: Colors.lightBlue,
  _Element.shadow: Colors.lightGreen,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.blue,
  _Element.shadow: Color(0xFF174EA6),
};

class DayNightClock extends StatefulWidget {
  const DayNightClock(this.model);

  final ClockModel model;

  @override
  _DayNightClockState createState() => _DayNightClockState();
}

class _DayNightClockState extends State<DayNightClock> {
  DateTime _dateTime = DateTime.now();
  String imagepam = "";
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DayNightClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
      imagepam = getImage();
    });
  }

  String getImage(){

    var hourCurrent = "20";//DateFormat('HH').format(_dateTime);
    var imgpam = "";
    log(hourCurrent);
    if(int.parse(hourCurrent) == 0){
      imgpam = "assets/img/moon.png";
    }
    if(int.parse(hourCurrent) < 18 && int.parse(hourCurrent) > 0){
      imgpam = "assets/img/sun.png";
    }
    if(int.parse(hourCurrent) == 18){
      imgpam = "assets/img/sunset.png";
    }
    if(int.parse(hourCurrent) > 18){
      imgpam = "assets/img/moon.png";
    }
    return imgpam;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final hour = DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final ampm = widget.model.is24HourFormat ? '' : DateFormat('a').format(_dateTime);
    final fontSize = MediaQuery.of(context).size.width / 7;
    final defaultStyle = TextStyle(
    
      color: colors[_Element.text],
      fontFamily: 'PermanentMarker',
      fontSize: fontSize,
      shadows: [
        Shadow(
          blurRadius: 0,
          color: colors[_Element.shadow],
          offset: Offset(10, 0),
        ),
      ],
    );

    return Container(
      color: colors[_Element.background],
      child: Center(
        child: DefaultTextStyle(
          style: defaultStyle,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
      child: Image.asset(imagepam, fit: BoxFit.fitWidth),
      
    ),
              Center(
                child: Text(hour+":"+minute+" "+ampm,)        
              )
            ],
          ),
        ),
      ),
    );
  }
}
