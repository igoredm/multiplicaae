// Trabalho flutter programação mobile

// Igor Ehlert Del Maschio - 11710374
// Vinícius Gomes - 11710390


import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData.dark(),
      home: MyHomePage(title: 'Multiplica aê!'),
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
  int _countTimer = 15;
  bool _firstTime = true;
  bool _visible = false;
  Timer _timer;
  int _points = 0;
  int _highscore = 0;
  int _numberOne;
  int _numberTwo;
  int _response;
  int _formResponse;

  final _controller = TextEditingController();

  bool _validadeResponse() {

    bool wrong = true;

    try {
      _formResponse = int.parse(_controller.text);
    } catch (error) {
      _formResponse = 0;
    }



    if (_formResponse == _response) {
      setState(() {
        _points++;
      });
      wrong = false;
    } else {
      if (_highscore < _points) {
        setState(() {
          _highscore = _points;
        });
      }
      setState(() {
        _points = 0;
      });
    }

    _controller.clear();
    return wrong;


  }

  void _generateNumbers() {
    Random random = new Random();
    if (_points < 11) {
      _numberOne = random.nextInt(10);
      _numberTwo = random.nextInt(10);
    } else {
      _numberOne = random.nextInt(_points);
      _numberTwo = random.nextInt(_points);
    }

    if (_numberOne < 2 || _numberTwo < 2) {
      _generateNumbers();
    } else{
      _response = _numberOne * _numberTwo;
    }
  }

  void _showDialog() {
    _visible = false;
    if (_timer != null) {
      _timer.cancel();
      setState(() {
        _countTimer = 15;
      });
    }

    _generateNumbers();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Errouuuuuuuu!"),
          content: new Text("Vamo tentar bater esse recorde ai!"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Fechar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void startTimer() {
    if (_timer != null) {
      _timer.cancel();
    }
    _countTimer = 15;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countTimer > 0) {
          _countTimer--;
        } else {
          bool wrong = _validadeResponse();
          print(wrong);
          if (wrong) {
            _showDialog();
            _timer.cancel();
          } else {
            _generateNumbers();
            startTimer();
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_firstTime) {
      _generateNumbers();
      _firstTime = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
              color: Colors.black
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body:
      Center(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    margin: new EdgeInsets.all(10.0),
                    child: Align(
                        child: HighscoreWidget(
                          highscore: _highscore,
                        )
                    )
                ),
                Container(
                    margin: new EdgeInsets.all(10.0),
                    child: Align(
                      child: Visibility(
                        visible: _visible,
                        child: TimerWidget(
                            timer: _countTimer
                        ),
                      ),
                    )
                ),
                Container(
                    margin: new EdgeInsets.all(10.0),
                    child: Align(
                        child: PointsWidget(
                          points: _points,
                        )
                    )
                ),
              ],
            ),
            Container(
                height: MediaQuery.of(context).size.height * 0.15,
                alignment: Alignment.center,
                margin: new EdgeInsets.all(10.0),
                child: Align(
                    alignment: Alignment.center,
                    child: OperationWidget(
                      numberOne: _numberOne,
                      numberTwo: _numberTwo,
                    )
                )
            ),
            Container(
                height: MediaQuery.of(context).size.height * 0.25,
                margin: new EdgeInsets.all(10.0),
                alignment: Alignment.center,
//                color: Colors.deepPurpleAccent,
                child: Align(
                    alignment: Alignment.center,
                    child: ResponseWidget(
                      controller: _controller,
                    )
                )
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: () {
          if (!_visible) {
            _visible = true;
          }
          bool wrong = _validadeResponse();
          if (wrong) {
            _showDialog();
          } else {
            _generateNumbers();
            startTimer();
          }
        },
        tooltip: 'Increment',
        child: Icon(Icons.check),
      ),
    );
  }
}

class PointsWidget extends StatelessWidget {
  const PointsWidget({
    Key key,
    @required int points,
  }) : _points = points, super(key: key);

  final int _points;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'Pontos:',
        ),
        Text(
          '$_points',
          style: Theme.of(context).textTheme.headline4,
        ),
      ],
    );
  }
}

class HighscoreWidget extends StatelessWidget {
  const HighscoreWidget({
    Key key,
    @required int highscore
  }) : _highscore = highscore, super(key: key);

  final int _highscore;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'Recorde:',
        ),
        Text(
          '$_highscore',
          style: Theme.of(context).textTheme.headline4,
        ),
      ],
    );
  }
}

class TimerWidget extends StatelessWidget {
  const TimerWidget({
    Key key,
    @required int timer,
  }) : _timer = timer, super(key: key);

  final int _timer;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          '$_timer',
          style: Theme.of(context).textTheme.headline4,
        ),
      ],
    );
  }
}

class OperationWidget extends StatelessWidget {
  const OperationWidget({
    Key key,
    @required int numberOne, int numberTwo,
  }) : _numberOne = numberOne, _numberTwo = numberTwo, super(key: key);

  final int _numberOne;
  final int _numberTwo;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
            '$_numberOne X $_numberTwo',

            style: TextStyle(
              fontSize: 80,
//            color: Colors.black
            )
        ),
      ],
    );
  }
}

class ResponseWidget extends StatelessWidget {
  const ResponseWidget({
    Key key,
    @required TextEditingController controller
  }) : _controller = controller, super(key: key);

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          controller: _controller,
          style: new TextStyle(fontSize: 50, ),
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly
          ],
          decoration: new InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(0.0, 100.0, 20.0, 10.0),
            border: new OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(10.0),
              ),
            ),
            hintText: "Resposta",
            hintStyle: new TextStyle(fontSize: 50),

          ),
        ),
      ],
    );
  }
}