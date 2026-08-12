import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AddView extends StatefulWidget {
  const AddView({super.key});

  @override
  State<AddView> createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {
  // Properties
  late TextEditingController todoController;  // 할 일
  late DateTime selectedDate;                 // 날짜
  late String selectedDateText;               // 선택된 날짜 표시 텍스트
  late DateTime selectedTime;                 // 시간
  late String selectedTimeText;               // 선택된 날짜 표시 텍스트

  // 카테고리
  late List<String> categoryList;
  late String categoryValue;

  late bool _isImportant;                     // 중요 여부
  final box = GetStorage();

  @override
  void initState() {
    super.initState();

    todoController = TextEditingController();
    selectedDate = DateTime.now();
    selectedDateText = selectedDate.toString().substring(0, 10);
    selectedTime = DateTime.now();
    selectedTimeText = selectedTime.toString().substring(11, 16);
    categoryList = ["일상", "업무", "건강"];
    categoryValue = "일상";
    _isImportant = false;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.tertiary,
      appBar: AppBar(
        title: Text(
          "할 일 추가",
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onSecondary,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),

              // 할 일 입력 TextField
              TextField(
                controller: todoController,
                decoration: InputDecoration(
                  labelText: "할 일을 입력하세요"
                ),
                maxLines: 1,
              ),
              SizedBox(height: 30),

              // 날짜 선택 버튼 -> showDatePicker
              ElevatedButton(
                onPressed: () => displayDatePicker(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  minimumSize: Size(110, 45)
                ),
                child: Text(
                  "날짜 선택",
                  style: TextStyle(
                    fontSize: 17
                  ),
                )
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  selectedDateText,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),

              // 시간 선택
              Text(
                "시간 선택",
                style: TextStyle(
                  fontSize: 20
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey
                    ),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: SizedBox(
                    width: 300,
                    height: 200,
                    child: CupertinoDatePicker(
                      backgroundColor: colorScheme.secondaryContainer,
                      mode: CupertinoDatePickerMode.time,
                      initialDateTime: DateTime.now(),
                      use24hFormat: false,
                      onDateTimeChanged: (value) {
                        selectedTime = value;
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 카테고리 선택
                  DropdownButton(
                    value: categoryValue,
                    icon: Icon(Icons.keyboard_arrow_down),
                    items: categoryList.map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item)
                      );
                    },).toList(), 
                    onChanged: (value) {
                      categoryValue = value.toString();
                      setState(() {});
                    },
                  ),
                  SizedBox(width: 50.0),
                  // 중요 여부 선택
                  Text("중요"),
                  Checkbox(
                    value: _isImportant,
                    onChanged: (value) {
                      _isImportant = value!;
                      setState(() {});
                    },
                  )
                ],
              ),

              // 추가 버튼
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: ElevatedButton(
                  onPressed: () {
                    if(todoController.text.trim().isEmpty) {
                      showErrorSnackbar(colorScheme);
                      return;
                    }
                    
                    saveTodo();
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    minimumSize: Size(200, 50)
                  ),
                  child: Text(
                    "추가하기",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                    ),
                  )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Functions
  // DatePicker로 날짜 선택
  void displayDatePicker() async {
    final firstSelectable = DateTime(
      selectedDate.year, selectedDate.month, selectedDate.day
    );
    final lastYear = DateTime(firstSelectable.year + 10);

    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: firstSelectable,
      lastDate: lastYear,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      locale: Locale('ko', 'KR')
    );

    if(date != null) {
      selectedDateText = date.toString().substring(0, 10);
      setState(() {});
    }
  }

  // 할 일을 입력하지 않았을 때 Snackbar 출력
  void showErrorSnackbar(ColorScheme colorScheme) {
    Get.snackbar(
      "경고", "할 일을 입력하세요",
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
      backgroundColor: colorScheme.error,
      colorText: colorScheme.onError
    );
  }

  // 입력한 데이터 저장
  void saveTodo() {
    selectedTimeText = selectedTime.toString().substring(11, 16);

    box.write("_todo", todoController.text.trim());
    box.write("_date", selectedDateText);
    box.write("_time", selectedTimeText);
    box.write("_category", categoryValue);
    box.write("_important", _isImportant);
  }
}