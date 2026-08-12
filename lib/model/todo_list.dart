class TodoList {
  // Properties
  String todoText;  // 할 일
  DateTime date;    // 날짜
  bool isImportant; // 중요 할 일 체크
  bool isCompleted; // 완료 여부

  // Constructor
  TodoList(
    {
      required this.todoText,
      required this.date,
      required this.isImportant,
      required this.isCompleted
    }
  );
}