import 'package:flutter/material.dart';
import 'dart:async'; // Import for Timer
import 'package:hacker_news/View/Home_page/components/latest.dart';
import 'package:hacker_news/View/Home_page/components/top.dart';
import 'package:hacker_news/size.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final GlobalKey<LatestState> _latestKey = GlobalKey<LatestState>();
  final GlobalKey<TopState> _topKey = GlobalKey<TopState>();
  Timer? _timer;

  Future<void> _refresh() async {
    _latestKey.currentState?.refresh();
    _topKey.currentState?.refresh();
    _resetTimer();
  }

  void _resetTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 300), (timer) {
      _refresh();
    });
  }

  @override
  void initState() {
    super.initState();
    _resetTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(getProportionateScreenWidth(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Top(key: _topKey),
                const SizedBox(height: 30),
                Latest(key: _latestKey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
