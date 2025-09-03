import 'package:flutter/material.dart';
import 'package:kaseapp_ui/models/pre_order_model.dart';
import 'package:kaseapp_ui/widgets/annoucementhistory.dart';
import 'package:kaseapp_ui/widgets/form_request.dart';
import 'package:kaseapp_ui/widgets/product_card.dart';

class TabControllerWidget extends StatefulWidget {
  const TabControllerWidget({super.key});

  @override
  State<TabControllerWidget> createState() => _TabControllerWidgetState();
}

class _TabControllerWidgetState extends State<TabControllerWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Color activeColor = const Color(0xFF06BC00);
  final Color activeBackground = const Color(0x1A06BC00); // 10% opacity

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: TabBar(
            isScrollable: true,
            controller: _tabController,
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: activeColor, width: 2),
              ),
              color: activeBackground,
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: activeColor,
            unselectedLabelColor: Colors.black87,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
            tabs: const [
              SizedBox(width: 120,height: 70, child: Tab(text: 'Supply Offer Form'),),
              SizedBox(width: 120,height: 70, child: Tab(text: 'Incoming Orders'),),
              SizedBox(width: 120,height: 70, child: Tab(text: 'My Announcement'),),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              SupplyForm(),
              const ProductCard(),
              const AnnouncementHistory(),
            ],
          ),
        ),
      ],
    );
  }
}
