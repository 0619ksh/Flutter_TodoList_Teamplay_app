import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  //Property
  XFile? imageFile;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    getImageFromDevice(ImageSource.camera);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: imageFile == null?
        Text('카메라를 실행합니다.',
        style: TextStyle(
          color: Colors.white,
          ),
        )
        : Image.file(File(imageFile!.path),
        ),
      ),
    );
  }//build

   // ---------------- Function ----------------

  void getImageFromDevice(ImageSource imageSource) async {

    // ★ 스마트폰 카메라 실행
    final XFile? pickedFile = 
      await picker.pickImage(
        source: imageSource
        );

    // ★ 촬영을 취소한 경우
    if (pickedFile == null) {
      imageFile = null;

    // ★ 사진을 촬영한 경우
    } else {
      imageFile = XFile(
        pickedFile.path,
      );
    }

    setState(() {});
  }
}//class

/*
 // ---------------- Function ---------------- 
    사진 촬영을 안하는 경우 다시 뒤로 돌아가게 만드는...
    대신 isPicking => 카메라가 실행중인지 저장해야함
    bool isPicking = false; 넣기

  void getImageFromDevice(ImageSource imageSource) async {

    if (isPicking == true) {
      return;
    }

    isPicking = true;


    final XFile? pickedFile =
        await picker.pickImage(
          source: imageSource,
        );


    // ★ 카메라에서 X 버튼 / 뒤로가기 눌렀을 때
    if (pickedFile == null) {

      isPicking = false;

      // ★ 이전 화면으로 돌아가기
      Get.back();

      return;
    }


    // ★ 사진을 실제로 촬영했을 때
    imageFile = XFile(
      pickedFile.path,
    );


    isPicking = false;

    setState(() {});
  }
*/