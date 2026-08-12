import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_ex_app/view/home_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Property
  late TextEditingController userIdController;
  late TextEditingController passwordController;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    userIdController = TextEditingController();
    passwordController = TextEditingController();
    initStorage(); // 함수 따로 만듦 박스는 개인금고
  }
  void initStorage(){ // 개인금고의 항목을 정해줌
    box.write('p_userId', "");
    box.write('p_password', "");
  }

  @override
  void dispose() {
    disposeStorage(); //  나가면 정보 다 버리는 거
    super.dispose();
  }
  
  void disposeStorage(){
    box.erase();
  }
  


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            // 상단 타이틀         
                  SizedBox(height: 50),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text('HARU PLAN',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    "반가워요!\n"
                    "오늘도 한 걸음 더",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "하루플랜과 함께 정돈된 하루를 설계해보세요",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 100),
            // 아이디/ 비번입력란            
                  Text(
                    "아이디",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: userIdController,
                      decoration: InputDecoration(
                        hintText: "apple", 
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12,),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color:Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.blue, width: 1.5),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8,),
                  Text(
                    "비밀번호",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: "········", 
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12,),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color:Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.blue, width: 1.5),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('비밀번호를 잊으셨나요?',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 120),
            // 로그인 버튼                        
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => checkData(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(8),
                        ),
                      ),  
                      child: Text(
                        '로그인',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '아직 회원이 아니신가요?',
                          style: TextStyle(
                            color: Colors.grey, 
                            fontWeight: FontWeight.bold,
                            fontSize: 10),
                            ),
                        Text(
                          '회원가입',
                          style: TextStyle(
                            color: Colors.blueAccent, 
                            fontWeight: FontWeight.bold,
                            fontSize: 10),
                        ),
                      ],
                    ),
                  )
                ],
              ),
          ),
        ),
      ),      
    );
  } // build

  //-------Function--------
  void checkData(){
    if(userIdController.text.trim().isEmpty || passwordController.text.trim().isEmpty){
      errorSnackBar();
    }else{
      if(userIdController.text.trim() == 'apple' && passwordController.text.trim() == "1234"){
        _showDialog();
      }else{
        checkSnackBar();
      }
    }
  }

  void _showDialog(){
    Get.defaultDialog(
      title: "반갑습니다",
      middleText: "확인되었습니다.",
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            saveStorage();
            Get.back();
            // Get.to(HomeView()); // 아규먼트 안 쓰고 겟을 쓰는 건 나중에나중에 그 정보를 쓸때 이용함.
          }, 
          child: Text("Exit"),
        ),
      ]
    );
  }
  void saveStorage(){
    box.write("p_userId", userIdController.text.trim());
    box.write("p_password", passwordController.text.trim());
  }
  
  
  

  void errorSnackBar(){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content : Text('사용자의 아이디와 비밀번호를 모두 입력하세요'),
        duration : Duration(seconds: 2),
        backgroundColor: Colors.red,
      )
    );
  }

  void checkSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('사용자 ID나 암호가 올바르지 않습니다.'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }
}