import 'package:ecommerce_app/tabs/homeTab.dart';
import 'package:ecommerce_app/tabs/savedTab.dart';
import 'package:ecommerce_app/tabs/searchTab.dart';
import 'package:ecommerce_app/widgets/bottomTabs.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _tabsPageController;
  int _selectedTab = 0;
  @override
  void initState() {
    super.initState();
    _tabsPageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _tabsPageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Expanded(
              child: PageView(
                controller: _tabsPageController,
                onPageChanged: (num) {
                  setState(() {
                    _selectedTab = num;
                  });
                },
                children: [
                  HomeTab(),
                  SearchTab(),
                  SavedTab(),
                ],
              ),
            ),
          ),
          Container(
            child: BottomTabs(
              selectedTab: _selectedTab,
              tabPressed: (num) {
                setState(() {
                  _tabsPageController.animateToPage(
                    num,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                  );
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
