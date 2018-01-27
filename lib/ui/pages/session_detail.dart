import 'package:droidkaigi2018/models/session.dart';
import 'package:droidkaigi2018/theme.dart';
import 'package:flutter/material.dart';

class SessionDetail extends StatefulWidget {
  final Session _session;

  SessionDetail(this._session);

  @override
  _SessionDetailState createState() => new _SessionDetailState();
}

const double _kAppBarHeight = 256.0;

enum AppBarBehavior { normal, pinned, floating, snapping }

class _SessionDetailState extends State<SessionDetail> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>();

  double _decideFontSize(double titleWidth) {
    double fontSize = titleWidth / widget._session.title.length;
    if (fontSize < 10.0) {
      fontSize = fontSize * 2;
    }
    if (fontSize > 18.0) {
      fontSize = 18.0;
    } else if (fontSize < 9.0) {
      fontSize = 9.0;
    }
    return fontSize;
  }

  Widget _buildAppBar(BuildContext context, double statusBarHeight) {
    final ThemeData theme = Theme.of(context);
    final TextStyle titleStyle =
        theme.textTheme.title.merge(new TextStyle(color: Colors.white));
    final subheadStyle =
        theme.textTheme.subhead.merge(new TextStyle(color: Colors.white));

    final Curve _textOpacity =
        const Interval(0.4, 1.0, curve: Curves.easeInOut);
    final Size screenSize = MediaQuery.of(context).size;
    final double titleWidth =
        screenSize.width - kToolbarHeight - NavigationToolbar.kMiddleSpacing;

    return new SliverAppBar(
      pinned: true,
      expandedHeight: _kAppBarHeight,
      flexibleSpace: new LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        final Size size = constraints.biggest;
        final double appBarHeight = size.height - statusBarHeight;
        final double t =
            (appBarHeight - kToolbarHeight) / (_kAppBarHeight - kToolbarHeight);

        final double extraPadding =
            new Tween<double>(begin: 10.0, end: 24.0).lerp(t);
        print("appBarHeight" + appBarHeight.toString());

        return new Padding(
          padding: new EdgeInsets.only(
            top: statusBarHeight,
          ),
          child: new Stack(
            children: [
              new Positioned(
                bottom: 0.0,
                width: size.width,
                child: new Opacity(
                  opacity: _textOpacity.transform(t.clamp(0.0, 1.0)),
                  child: new Container(
                    margin: const EdgeInsets.all(16.0),
                    child: new Column(
                      children: [
                        new Container(
                          alignment: Alignment.centerLeft,
                          child: new Text(
                            widget._session.title,
                            style: titleStyle,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        new Container(
                          margin: new EdgeInsets.only(top: 8.0),
                          alignment: Alignment.centerLeft,
                          child: new Text(
                            widget._session.topic.name,
                            style: subheadStyle,
                          ),
                        ),
                        new Container(
                          alignment: Alignment.centerLeft,
                          margin: new EdgeInsets.only(top: 8.0),
                          child: new Text(
                            widget._session.level.name,
                            style: subheadStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              new Positioned.fromRect(
                rect: new Rect.fromLTWH(
                    kToolbarHeight - NavigationToolbar.kMiddleSpacing,
                    0.0,
                    titleWidth,
                    kToolbarHeight),
                child: new Center(
                  child: new Opacity(
                    opacity: _textOpacity.transform(1 - t.clamp(0.0, 1.0)),
                    child: new Text(
                      widget._session.title,
                      style: titleStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double titleWidth = screenSize.width / 1.5 - 32.0;
    double fontSize = _decideFontSize(titleWidth);
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return new Theme(
      data: themeData,
      child: new Scaffold(
        key: _scaffoldKey,
        body: new CustomScrollView(
          slivers: [
            _buildAppBar(context, statusBarHeight),
            new SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: new SliverToBoxAdapter(
                child: new Text(widget._session.description),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Header extends StatefulWidget {
  Header({this.height, this.t});

  final double height;
  final double t;

  @override
  _HeaderState createState() => new _HeaderState();
}

class _HeaderState extends State<Header> {
  final Curve _textOpacity = const Interval(0.4, 1.0, curve: Curves.easeInOut);

  @override
  Widget build(BuildContext context) {
    return new Opacity(
      opacity: _textOpacity.transform(1 - widget.t),
      child: new Text(
        "まだAPI定義管理で消耗してるの？〜Swaggerを用いた大規模アプリ時代のAPI定義管理とコードジェネレート〜",
        style: new TextStyle(fontSize: 18.0),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );
  }
}
