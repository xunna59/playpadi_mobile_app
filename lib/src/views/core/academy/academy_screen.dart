import 'package:flutter/material.dart';

import 'available_classes.dart';
import 'user_classes.dart';
import 'youtube_tutorials.dart';

class AcademyScreen extends StatefulWidget {
  const AcademyScreen({super.key});

  @override
  State<AcademyScreen> createState() => _AcademyScreenState();
}

class _AcademyScreenState extends State<AcademyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _titles = [
    'Available',
    'Your Classes',
    'YouTube Tutorials',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _titles.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        //   backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _titles[_tabController.index],
          //  style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: colorScheme.primary,
          tabs: _titles.map((t) => Tab(text: t)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AvailableClassesTab(),
          UserClassesTab(), // placeholder
          YouTubeTutorialsTab(), // placeholder
        ],
      ),
    );
  }
}
