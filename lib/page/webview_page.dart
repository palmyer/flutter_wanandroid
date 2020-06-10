import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wanandroid/http/http.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  String _url;
  String title;
  int id;
  String link;
  bool collect;
  int originId;

  WebViewPage(this._url,
      {this.title,
      this.id,
      this.link,
      this.collect = false,
      this.originId = -1});

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  WebViewController _webViewController;
  bool _clicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new BackButton(
          onPressed: () async {
            if (_webViewController == null) {
              Navigator.pop(context, _clicked);
            } else {
              bool canGoBack = await _webViewController.canGoBack();
              if (canGoBack) {
                _webViewController.goBack();
              } else {
                Navigator.pop(context, _clicked);
              }
            }
          },
        ),
        title: new Text(widget.title == null ? "" : widget.title),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        actions: <Widget>[
          Builder(
              builder: (context) => IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    Http().share(widget.title, widget._url).then((value) =>
                        Scaffold.of(context).showSnackBar(
                            const SnackBar(content: const Text("分享成功"))));
                  })),
        ],
      ),
      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: widget._url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) async {
            _webViewController = webViewController;
            _controller.complete(webViewController);
            String name = await webViewController.getTitle();
            print("title: $name");
            if (widget.title == null && name == null && name.isEmpty) {
              setState(() {
                widget.title = name;
              });
            }
          },
          // ignore: prefer_collection_literals
          javascriptChannels: <JavascriptChannel>[
            _toasterJavascriptChannel(context),
          ].toSet(),
//          navigationDelegate: (NavigationRequest request) {
//            if (request.url.startsWith('https://www.youtube.com/')) {
//              print('blocking navigation to $request}');
//              return NavigationDecision.prevent;
//            }
//            print('allowing navigation to $request');
//            return NavigationDecision.navigate;
//          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          gestureNavigationEnabled: true,
        );
      }),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () {
            _clicked = true;
            if (widget.id != null && widget.id != 0) {
              if (widget.collect == null) {
                Http()
                    .collectRemoveMy(widget.id, originId: widget.originId)
                    .then((value) {
                  setState(() => widget.collect = false);
                  Scaffold.of(context).showSnackBar(
                      const SnackBar(content: const Text("取消收藏成功")));
                });
              } else if (widget.collect)
                Http().collectRemoveArticle(widget.id).then((value) {
                  setState(() => widget.collect = false);
                  Scaffold.of(context).showSnackBar(
                      const SnackBar(content: const Text("取消收藏成功")));
                });
              else
                Http().collectAdd(widget.id).then((value) {
                  setState(() => widget.collect = true);
                  Scaffold.of(context).showSnackBar(
                      const SnackBar(content: const Text("收藏成功")));
                });
            } else if (widget.link != null && widget.link.isNotEmpty)
              print("object");
          },
          child: new Icon(
            Icons.favorite,
            color: widget.collect ?? true ? Colors.red : Colors.white,
          ),
        ),
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}
