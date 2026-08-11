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
  // Get.argument나 String userId = GetStorage().read('userId'); 로 받기
  // 
  // late String userId

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
                color:  Color(0xFF4A5DBB),
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
               color:  Color(0xFFF4F7FF),
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
                                color: Color(0xFFF4F7FF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                gridIcon[index],
                                size: 35,
                                color: Color(0xFF4A5DBB),
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
                                fontSize: 12,
                                color: Color(0xFF4A5DBB),
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