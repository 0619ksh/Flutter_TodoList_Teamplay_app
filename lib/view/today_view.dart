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

  // 할 일 객체 리스트
  List<TodoList> todoItems = [];

  @override
  void initState() {
    super.initState();

    _loadSavedTodoFromStorage();

    // 오늘 할 일 개수 저장
    saveTodayCount();
  }

  // 날짜 필터링
  List<TodoList> get filteredTodoItems {
    String formattedSelectedDate =
        '${selectedDate.year}-'
        '${selectedDate.month.toString().padLeft(2, '0')}-'
        '${selectedDate.day.toString().padLeft(2, '0')}';

    List<TodoList> result = [];

    for (int i = 0; i < todoItems.length; i++) {
      if (todoItems[i].date == formattedSelectedDate) {
        result.add(todoItems[i]);
      }
    }
    return result;
  }
  // 날짜 선택
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
  // GetStorage에서 저장된 Todo 읽어오기
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
      // Todo 추가 후 개수 다시 저장
      saveTodayCount();
      // 중복 추가 방지
      box.remove('_todo');
    }
  }
  // 오늘 할 일 개수 / 완료 개수 계산
  void saveTodayCount() {
    DateTime now = DateTime.now();
    String today =
        '${now.year}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
    int todayCount = 0;
    int doneCount = 0;
    for (int i = 0; i < todoItems.length; i++) {
      // 오늘 날짜인지 확인
      if (todoItems[i].date == today) {
        todayCount++;
        // 완료된 할 일인지 확인
        if (todoItems[i].isCompleted == true) {
          doneCount++;
        }
      }
    }
    // HomeView에서 사용할 값 저장
    box.write('todayCount', todayCount);
    box.write('doneCount', doneCount);
  }
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    String dateTitle =
        '${selectedDate.year}-'
        '${selectedDate.month.toString().padLeft(2, '0')}-'
        '${selectedDate.day.toString().padLeft(2, '0')} 할 일';
    return Scaffold(
      backgroundColor: colorScheme.tertiary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
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
                      onPressed: () {
                        _selectDate(context);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.west,
                    size: 14,
                    color: colorScheme.outline,
                  ),
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
              Expanded(
                child: filteredTodoItems.isEmpty
                    ? Center(
                        child: Text(
                          '해당 날짜에 등록된 할 일이 없습니다.',
                          style: TextStyle(
                            color: colorScheme.outline,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredTodoItems.length,

                        itemBuilder: (context, index) {
                          final todo = filteredTodoItems[index];

                          return _buildTodoCard(
                            todo,
                            colorScheme,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Get.toNamed('/add');
          _loadSavedTodoFromStorage();
        },
        backgroundColor: colorScheme.primary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Icon(
          Icons.add,
          color: colorScheme.onPrimary,
          size: 28,
        ),
      ),
    );
  }

  // 할 일 카드
  Widget _buildTodoCard(
    TodoList todo,
    ColorScheme colorScheme,
  ) {
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
        child: Icon(
          Icons.delete,
          color: colorScheme.onError,
        ),
      ),
      onDismissed: (direction) {
        setState(() {
          todoItems.remove(todo);
        });
        // 삭제 후 개수 다시 저장
        saveTodayCount();

        Get.snackbar(
          '삭제 완료',
          '${todo.todoText} 항목이 삭제되었습니다.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          backgroundColor: colorScheme.inverseSurface,
          colorText: colorScheme.onInverseSurface,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  todo.isCompleted = !todo.isCompleted;
                });
                // 체크 후 완료 개수 다시 저장
                saveTodayCount();
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
                    ? Icon(
                        Icons.check,
                        size: 16,
                        color: colorScheme.onSecondary,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (todo.isImportant)
                        Icon(
                          Icons.star,
                          size: 16,
                          color: colorScheme.primary,
                        ),
                      if (todo.isImportant)
                        const SizedBox(width: 4),
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