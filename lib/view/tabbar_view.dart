import 'package:flutter/material.dart';

// ★ 각 화면 파일 import
import 'package:todo_ex_app/view/home_view.dart';
import 'package:todo_ex_app/view/today_view.dart';
import 'package:todo_ex_app/view/map_view.dart';
import 'package:todo_ex_app/view/camera_view.dart';
import 'package:todo_ex_app/view/calendar_view.dart';

class TabbarView extends StatefulWidget {
  const TabbarView({super.key});

  @override
  State<TabbarView> createState() => _TabbarViewState();
}


class _TabbarViewState extends State<TabbarView> {

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 5,

      child: Scaffold(

        // ★ 실제 페이지 연결
        body: TabBarView(
          children: [

            // ★ 0번 : 홈
            HomeView(),

            // ★ 1번 : 할일
            TodayView(),

            // ★ 2번 : 캘린더
            CalendarView(),

            // ★ 3번 : 지도
            MapView(),

            // ★ 4번 : 카메라
            CameraView(),
          ],
        ),


        // =====================================================
        // TabBar 디자인
        // =====================================================

        bottomNavigationBar: Container(
          height: 85,
          color: Colors.white,

          child: TabBar(

            // 선택된 아이콘 + 글자 색
            labelColor: Theme.of(context).colorScheme.primary,

            // 선택되지 않은 아이콘 + 글자 색
            unselectedLabelColor: Color(0xFFADB5C2),

            // 기본적으로 생기는 TabBar 밑줄 색깔
            indicatorColor: Theme.of(context).colorScheme.primary,

            // 선택된 글자 디자인
            labelStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),

            // 선택되지 않은 글자 디자인
            unselectedLabelStyle: TextStyle(
              fontSize: 12,
            ),

            tabs: [

              // ---------------- 홈 ----------------

              Tab(
                icon: Icon(
                  Icons.home_outlined,
                  size: 30,
                ),
                text: '홈',
              ),


              // ---------------- 할일 ----------------

              Tab(
                icon: Icon(
                  Icons.check_circle_outline,
                  size: 30,
                ),
                text: '할일',
              ),


              // ---------------- 캘린더 ----------------

              Tab(
                icon: Icon(
                  Icons.calendar_today_outlined,
                  size: 28,
                ),
                text: '캘린더',
              ),


              // ---------------- 지도 ----------------

              Tab(
                icon: Icon(
                  Icons.location_on_outlined,
                  size: 30,
                ),
                text: '지도',
              ),


              // ---------------- 카메라 ----------------

              Tab(
                icon: Icon(
                  Icons.camera_alt_outlined,
                  size: 30,
                ),
                text: '카메라',
              ),
            ],
          ),
        ),
      ),
    );
  }
}