class TodoList {
  // Properties

  String todoText;  // 할 일
  String date;      // 날짜
  String time;      // 시간
  String category;  // 카테고리
  bool isImportant; // 중요 여부
  bool isCompleted; // 완료 여부

  // Constructor
  TodoList(
    {
      required this.todoText,
      required this.date,
      required this.time,
      required this.category,
      required this.isImportant,
      required this.isCompleted
    }
  );
}