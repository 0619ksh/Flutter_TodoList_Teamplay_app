import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // Property
  late List<IconData> gridIcon;
  late List<String> gridTitle;
  late List<String> gridContent;

  final box = GetStorage();
  late String userId;

  // 오늘 날짜에 해당하는 todo 전체 개수
  late int todayCount;

  // 오늘 완료한 todo 개수
  late int doneCount;

  // 오늘 남은 todo 개수
  late int remainingCount;

  // 오늘 할 일 달성률
  // 완료 개수 / 전체 개수 * 100 -> 소수점 없이
  late double percent;

  @override
  void initState() {
    super.initState();

    // ★ Stashed changes에서 가져온 초기값
    todayCount = 0;
    doneCount = 0;
    remainingCount = 0;
    percent = 0;

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
      '포토 메뉴',
    ];

    // ★ null일 경우 빈 문자열 사용
    userId = box.read('p_userId') ?? '';

    // ★ 저장된 오늘의 전체 todo 개수
    todayCount = box.read('todayCount') ?? 0;

    // ★ 저장된 오늘의 완료 todo 개수
    doneCount = box.read('doneCount') ?? 0;

    // 남은 todo 계산
    remainingCount = todayCount - doneCount;

    // 달성률 계산
    percent = todayCount == 0
        ? 0
        : doneCount / todayCount * 100;

    // ★ 계산이 끝난 다음 gridContent 생성
    gridContent = [
      '$remainingCount개 남음',
      '이번 달 5개',
      '최근 위치 2곳',
      '신규 등록 가능',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FF),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ★ 기존 feature 브랜치에 있던
            // SizedBox(height: 60)는 제거

            Text(
              '안녕하세요, $userId 님 👋',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Text(
              '오늘도 한 걸음 가벼운 하루를 설계해보세요.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(
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
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '오늘의 할 일 달성률',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '  ${percent.toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            const Text(
              '   바로가기',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Theme.of(context).colorScheme.tertiary,
              child: SizedBox(
                height: 450,
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,

                    // ★ 네가 마지막에 수정했던 값
                    childAspectRatio: 0.75,
                  ),
                  itemCount: gridTitle.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).colorScheme.tertiary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                gridIcon[index],
                                size: 35,
                                color:
                                    Theme.of(context).colorScheme.primary,
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            Text(
                              gridTitle[index],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            Text(
                              gridContent[index],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}