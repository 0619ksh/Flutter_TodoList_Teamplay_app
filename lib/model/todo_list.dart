class TodoList {
  // Properties
  String todoText;   // 할 일 내용
  DateTime date;     // 날짜 및 시간
  bool isImportant;  // 중요 할 일 체크
  bool isCompleted;  // 완료 여부
  String category;   // 카테고리 (업무, 일상 등 - UI 디자인 요구사항 반영)

  // Constructor
  TodoList({
    required this.todoText,
    required this.date,
    required this.isImportant,
    required this.isCompleted,
    this.category = '일상', // 기본값 지정 가능
  });

  // 시간을 화면 표시용 텍스트(예: "오전 11:00")로 변환해주는 헬퍼 getter
  String get formattedTime {
    final hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = hour < 12 ? '오전' : '오후';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    return '$period $displayHour:$minute';
  }
}