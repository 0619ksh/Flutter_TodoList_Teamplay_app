import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/todo_list.dart';

class TodayView extends StatefulWidget {
  const TodayView({super.key});

  @override
  State<TodayView> createState() => _TodayViewState();
}

class _TodayViewState extends State<TodayView> {
  // 현재 선택된 날짜 (기본값: 오늘)
  DateTime selectedDate = DateTime.now();

  // 원본 전체 할 일 목록
  List<TodoList> todoItems = [
    TodoList(
      todoText: '디자인 시스템 시안 정리',
      date: DateTime(2026, 8, 12, 11, 0),
      isImportant: false,
      isCompleted: false,
      category: '업무',
    ),
    TodoList(
      todoText: '메일 및 피드백 회신',
      date: DateTime(2026, 8, 12, 13, 30),
      isImportant: false,
      isCompleted: true,
      category: '일상',
    ),
    TodoList(
      todoText: '마트에서 장보기 (우유, 과일)',
      date: DateTime(2026, 8, 12, 17, 0),
      isImportant: false,
      isCompleted: false,
      category: '일상',
    ),
    TodoList(
      todoText: '내일 일정 준비하기',
      date: DateTime(2026, 8, 13, 10, 0),
      isImportant: false,
      isCompleted: false,
      category: '업무',
    ),
  ];

  // 배운 where 메소드로 selectedDate와 (년, 월, 일)이 일치하는 항목만 추출
  List<TodoList> get filteredTodoItems {
    return todoItems.where((todo) {
      return todo.date.year == selectedDate.year &&
          todo.date.month == selectedDate.month &&
          todo.date.day == selectedDate.day;
    }).toList();
  }

  // 날짜 선택 팝업 함수 (showDatePicker 활용)
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    // 날짜가 선택되었으면 상태 갱신
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 선택된 날짜를 "YYYY-MM-DD" 형태로 표현
    String dateTitle =
        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')} 할 일';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // 헤더 영역
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E2022),
                    ),
                  ),
                  // 날짜 선택 달력 팝업을 호출하는 필터 버튼
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF1F8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.calendar_month_rounded,
                        color: Color(0xFF7A8299),
                        size: 20,
                      ),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Sub Title
              Row(
                children: const [
                  Icon(Icons.west, size: 14, color: Color(0xFFA0A7BA)),
                  SizedBox(width: 6),
                  Text(
                    '왼쪽으로 밀어서 할 일을 삭제할 수 있습니다.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFA0A7BA),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 필터링된 할 일 목록
              Expanded(
                child: filteredTodoItems.isEmpty
                    ? const Center(
                        child: Text(
                          '해당 날짜에 등록된 할 일이 없습니다.',
                          style: TextStyle(color: Color(0xFFA0A7BA)),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredTodoItems.length,
                        itemBuilder: (context, index) {
                          final todo = filteredTodoItems[index];
                          return _buildTodoCard(todo);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),

      // 플로팅 버튼
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTodo = await Get.toNamed('/add');
          if (newTodo != null && newTodo is TodoList) {
            setState(() {
              todoItems.add(newTodo);
            });
          }
        },
        backgroundColor: const Color(0xFF5363CE),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  // 할 일 카드 위젯
  Widget _buildTodoCard(TodoList todo) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFFF6B6B),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        setState(() {
          todoItems.remove(todo);
        });

        Get.snackbar(
          "삭제 완료",
          '${todo.todoText} 항목이 삭제되었습니다.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.black87,
          colorText: Colors.white,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // 체크박스
            GestureDetector(
              onTap: () {
                setState(() {
                  todo.isCompleted = !todo.isCompleted;
                });
              },
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: todo.isCompleted
                      ? const Color(0xFF818CCB)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: todo.isCompleted
                        ? const Color(0xFF818CCB)
                        : const Color(0xFFD0D5E2),
                    width: 2,
                  ),
                ),
                child: todo.isCompleted
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(width: 14),

            // 텍스트 및 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.todoText,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: todo.isCompleted
                          ? const Color(0xFFC0C5D6)
                          : const Color(0xFF2C303E),
                      decoration: todo.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        todo.formattedTime,
                        style: TextStyle(
                          fontSize: 12,
                          color: todo.isCompleted
                              ? const Color(0xFFC0C5D6)
                              : const Color(0xFFA0A7BA),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '•',
                        style: TextStyle(
                          fontSize: 12,
                          color: todo.isCompleted
                              ? const Color(0xFFC0C5D6)
                              : const Color(0xFFA0A7BA),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        todo.category,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: todo.isCompleted
                              ? const Color(0xFFC0C5D6)
                              : const Color(0xFF5A669D),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}