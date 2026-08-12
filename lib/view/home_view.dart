import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  //Property
  late List<IconData> gridIcon;
  late List<String> gridTitle;
  late List<String> gridContent;

  // 다른 페이지 구성시 받아야 하는 data

  // 로그인 화면에서 받아올 사용자 ID
  // Get.argument 로 받기 
  // late String userId

  // TodoList 데이터를 저장할 리스트
  // late List<TodoList> todoList;

  // 오늘 날짜에 해당하는 todo 전체 개수
  // late int todayCount;

  // 오늘 완료한 todo개수
  // late int doneCount;

  // 오늘 할 일 달성률
  // 완료개 수 / 전체개수 * 100  -> 소수점 없이
  // late double percent;

  @override
  void initState() {
    super.initState();
    gridIcon = [
      Icons.check_circle_outline,
      Icons.add_circle_outline,
      Icons.location_on_outlined,
      Icons.camera_alt_outlined,
    ];

    gridTitle = [
      '오늘 할 일',
      '할 일 추가',
      '지도 메뉴',
      '포토 메뉴'
    ];

    gridContent = [
      '개 남음',          //  오늘 날짜에 해당하는 todo 전체 개수 $todayCount
      '이번 달  개',      //  이번 달 전체 todo 개수 ... 가능할까..... monthCount
      '최근 위치 2곳',
      '신규 등록 가능'
    ];

    // 나중에 로그인 페이지에서 받은 값으로 변경하기
    // userId = '';

    // 나중에 todayView의 실제 todo 데이터와 연결
    // todayCount = 0;

    // 체크 된 todo 개수 받아오기
    // doneCount = 0;

    // 달성률 계산
    // percnet = todayCount == 0 ? 0 : doneCount / todayCount * 100;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F7FF),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 60,
            ),
            Text(
              '안녕하세요,           님 👋', 

                // 로그인 페이지에서 받아온 userId를 출력 $userId

              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '오늘도 한 걸음 가벼운 하루를 설계해보세요.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 350,
              height: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '오늘의 할 일 달성률',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '      %',

                      // ${percent.toStringAsFixed(0)%}

                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              '   바로가기',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(20),
              ),
               color: Theme.of(context).colorScheme.tertiary,
              child: SizedBox(
                height: 450,
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.9
                    ),
                  itemCount: gridTitle.length, 
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(20),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(15),
                        
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.tertiary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                gridIcon[index],
                                size: 35,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              gridTitle[index],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              gridContent[index],
                              style: TextStyle(
                                fontSize: 14,    // change -> 12                                color: Color(0xFF4A5DBB),
                                fontWeight: FontWeight.bold
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  } // build
} // class

/*
import 'package:flutter/material.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}


class _HomeViewState extends State<HomeView> {

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 5,

      child: Scaffold(

        // ★ 각 탭을 눌렀을 때 보여줄 화면
        body: TabBarView(
          children: [

            // 0번 : 홈
            Center(
              child: Text('Home'),
            ),

            // 1번 : 할일
            Center(
              child: Text('Today'),
            ),

            // 2번 : 캘린더
            Center(
              child: Text('Calendar'),
            ),

            // 3번 : 지도
            Center(
              child: Text('Map'),
            ),

            // 4번 : 카메라
            Center(
              child: Text('Camera'),
            ),
          ],
        ),


        // =====================================================
        // ★★★ 여기부터 TabBar 디자인 ★★★
        // =====================================================

        bottomNavigationBar: Container(
          height: 85,
          color: Colors.white,

          child: TabBar(

            // ★ 선택된 아이콘 + 글자 색
            labelColor: Color(0xFF4A5DBB),

            // ★ 선택되지 않은 아이콘 + 글자 색
            unselectedLabelColor: Color(0xFFADB5C2),

            // ★ 기본적으로 생기는 TabBar 밑줄 색깔
            indicatorColor: Color(0xFF4A5DBB),

            // ★ 글자 디자인
            labelStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),

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

        // =====================================================
        // ★★★ TabBar 끝 ★★★
        // =====================================================
      ),
    );
  }
}

class TodoList {
  // ---------------- Property ----------------

  String todoText;        // 할 일 내용
  DateTime date;          // 할 일 날짜
  boold  isImportant;     // 중요 여부
  bool isDone;            // 완료 여부


  // ---------------- Constructor ----------------

  TodoList({
    required this.todoText,
    required this.date,
    required this.isImportant,
    required this.isDone,
  });
}



/////
*/