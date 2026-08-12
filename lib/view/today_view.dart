import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../model/todo_list.dart';

class TodayView extends StatefulWidget {
  const TodayView({super.key});

  @override
  State<TodayView> createState() => _TodayViewState();
}

class _TodayViewState extends State<TodayView> {
  DateTime selectedDate = DateTime.now();
  final box = GetStorage();

  // 샘플 데이터 삭제 후 빈 리스트로 초기화
  List<TodoList> todoItems = [];

  List<TodoList> get filteredTodoItems {
    String formattedSelectedDate =
        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
    return todoItems.where((todo) => todo.date == formattedSelectedDate).toList();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // GetStorage에서 저장된 데이터를 읽어와 TodoList 객체 생성
  void _loadSavedTodoFromStorage() {
    final String? todoText = box.read('_todo');
    final String? date = box.read('_date');
    final String? time = box.read('_time');
    final String? category = box.read('_category');
    final bool? isImportant = box.read('_important');

    if (todoText != null && todoText.isNotEmpty) {
      final newTodo = TodoList(
        todoText: todoText,
        date: date ?? '',
        time: time ?? '',
        category: category ?? '일상',
        isImportant: isImportant ?? false,
        isCompleted: false,
      );

      setState(() {
        todoItems.add(newTodo);
      });

      // 읽어온 뒤에는 저장소 값 초기화 (중복 추가 방지)
      box.remove('_todo');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    String dateTitle =
        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')} 할 일';

    return Scaffold(
      backgroundColor: colorScheme.tertiary,
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
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.calendar_month_rounded,
                        color: colorScheme.primary,
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
                children: [
                  Icon(Icons.west, size: 14, color: colorScheme.outline),
                  const SizedBox(width: 6),
                  Text(
                    '왼쪽으로 밀어서 할 일을 삭제할 수 있습니다.',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.outline,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 필터링된 할 일 목록
              Expanded(
                child: filteredTodoItems.isEmpty
                    ? Center(
                        child: Text(
                          '해당 날짜에 등록된 할 일이 없습니다.',
                          style: TextStyle(color: colorScheme.outline),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredTodoItems.length,
                        itemBuilder: (context, index) {
                          final todo = filteredTodoItems[index];
                          return _buildTodoCard(todo, colorScheme);
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
          // AddView 화면으로 이동 후 돌아올 때까지 대기
          await Get.toNamed('/add');
          // 복귀 후 GetStorage 데이터 확인 및 추가
          _loadSavedTodoFromStorage();
        },
        backgroundColor: colorScheme.primary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Icon(Icons.add, color: colorScheme.onPrimary, size: 28),
      ),
    );
  }

  // 할 일 카드 위젯
  Widget _buildTodoCard(TodoList todo, ColorScheme colorScheme) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: colorScheme.error,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(Icons.delete, color: colorScheme.onError),
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
          backgroundColor: colorScheme.inverseSurface,
          colorText: colorScheme.onInverseSurface,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
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
                      ? colorScheme.secondary
                      : colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: todo.isCompleted
                        ? colorScheme.secondary
                        : colorScheme.outlineVariant,
                    width: 2,
                  ),
                ),
                child: todo.isCompleted
                    ? Icon(Icons.check, size: 16, color: colorScheme.onSecondary)
                    : null,
              ),
            ),
            const SizedBox(width: 14),

            // 텍스트 및 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (todo.isImportant) ...[
                        Icon(Icons.star, size: 16, color: colorScheme.primary),
                        const SizedBox(width: 4),
                      ],
                      Expanded(
                        child: Text(
                          todo.todoText,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: todo.isCompleted
                                ? colorScheme.outline
                                : colorScheme.onSurface,
                            decoration: todo.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        todo.time,
                        style: TextStyle(
                          fontSize: 12,
                          color: todo.isCompleted
                              ? colorScheme.outline
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '•',
                        style: TextStyle(
                          fontSize: 12,
                          color: todo.isCompleted
                              ? colorScheme.outline
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        todo.category,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: todo.isCompleted
                              ? colorScheme.outline
                              : colorScheme.primary,
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