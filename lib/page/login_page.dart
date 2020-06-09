import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wanandroid/http/http.dart';
import 'package:wanandroid/res.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  List<String> _list = [];
  String _src = "";
  int _index = 0;
  Timer _timer;
  bool _isLogin = true;
  TextEditingController _controllerName;
  TextEditingController _controllerPwd;
  TextEditingController _controllerRePwd;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1, end: 1.2).animate(_controller);
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _src = _list.length == 0 ? "" : _list[_index++ % _list.length];
      if (_controller.status == AnimationStatus.completed)
        _controller.reverse();
      else if (_controller.status == AnimationStatus.dismissed)
        _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      body: new Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          new AnimatedBuilder(
            animation: _animation,
            builder: (BuildContext context, Widget child) {
              return Transform.scale(
                scale: _animation.value,
                child: new SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: new FadeInImage.assetNetwork(
                      placeholder: Res.drawer_header,
                      image: _src,
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(seconds: 1),
                    )),
              );
            },
          ),
          new BackdropFilter(
            filter: new ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: new Container(
              color: Colors.white.withOpacity(0.1),
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          new Positioned(
              top: 0,
              left: 0,
              child: new SafeArea(
                child: new IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context)),
              )),
          new Positioned(
            left: 30,
            right: 30,
            child: new Card(
              child: new Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: new Column(
                  children: <Widget>[
                    new TextField(
                      controller: _controllerName,
                      decoration: InputDecoration.collapsed(hintText: "用户名"),
                    ),
                    const Divider(),
                    new TextField(
                      controller: _controllerPwd,
                      decoration: InputDecoration.collapsed(hintText: "密码"),
                      obscureText: true,
                    ),
                    new Offstage(
                      offstage: _isLogin,
                      child: const Divider(),
                    ),
                    new Offstage(
                      offstage: _isLogin,
                      child: new TextField(
                        controller: _controllerRePwd,
                        decoration:
                            InputDecoration.collapsed(hintText: "再次输入密码"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          new Positioned(
            bottom: 0,
            left: 10,
            right: 10,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new FlatButton(
                    onPressed: () => setState(() => _isLogin = !_isLogin),
                    child: new Text(
                      _isLogin ? "用户注册" : "用户登录",
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    )),
                new FlatButton(
                    color: Colors.blue,
                    onPressed: () => _isLogin ? getLogin() : getRegister(),
                    child: new Text(
                      _isLogin ? "登录" : "注册",
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  getMeiziList() {
    Future.wait([
      Future.delayed(const Duration(milliseconds: 500)),
      Http().getMeiziList().then((value) {
        _list.clear();
        value.forEach((element) {
          _list.addAll(element.images);
        });
      })
    ]).then((value) => setState(() => _controller.forward()));
  }

  getRegister() {
    if (_controllerName.text.isEmpty ||
        _controllerPwd.text.isEmpty ||
        _controllerRePwd.text.isEmpty) {
      return;
    }
    Http()
        .getRegister(
            _controllerName.text, _controllerPwd.text, _controllerRePwd.text)
        .then((value) => Navigator.pop(context));
  }

  getLogin() {
    if (_controllerName.text.isEmpty || _controllerPwd.text.isEmpty) {
      return;
    }
    Http()
        .getLogin(_controllerName.text, _controllerPwd.text)
        .then((value) => Navigator.pop(context));
  }
}
