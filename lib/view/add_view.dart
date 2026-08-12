import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddView extends StatefulWidget {
  const AddView({super.key});

  @override
  State<AddView> createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {
  // Properties
  late TextEditingController todoController;  // 할 일
  late DateTime selectedDate;                     // 날짜
  DateTime? selectedTime;                     // 시간
  late String selectedDateText;               // 선택된 날짜 표시 텍스트

  // 카테고리
  late List<String> categoryList;
  late String categoryValue;

  late bool _isImportant;                     // 중요 여부

  @override
  void initState() {
    super.initState();

    todoController = TextEditingController();
    selectedDate = DateTime.now();
    selectedDateText = '';
    categoryList = ["일상", "업무", "건강"];
    categoryValue = "일상";
    _isImportant = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("할 일 추가"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 할 일 입력 TextField
              TextField(
                controller: todoController,
                decoration: InputDecoration(
                  labelText: "할 일을 입력하세요"
                ),
                maxLines: 1,
              ),
              // 날짜 선택 버튼 -> showDatePicker
              ElevatedButton(
                onPressed: () => displayDatePicker(),
                child: Text("날짜 선택")
              ),
              Text(selectedDateText),
              // 시간 선택
              Text("시간 선택"),
              SizedBox(
                width: 300,
                height: 200,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: DateTime.now(),
                  use24hFormat: false,
                  onDateTimeChanged: (value) {
                    selectedTime = value;
                    setState(() {});
                    // print(chosenDateTime);
                  },
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
              // 할 일 추가
              ElevatedButton(
                onPressed: () {
                  //
                },
                child: Text("추가하기")
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
    final lastYear = DateTime(firstSelectable.year + 5);

    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,      // 현재 날짜로 초기값 설정
      firstDate: firstSelectable,
      lastDate: lastYear,   // 선택 가능한 년도 범위
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      locale: Locale('ko', 'KR')      // 언어 설정
    );

    if(date != null) {
      selectedDateText = "선택하신 일자는 ${date.toString().substring(0, 10)} 입니다.";
      setState(() {});
    }
  }
}