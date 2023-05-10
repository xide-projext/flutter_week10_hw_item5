import 'dart:convert'; // JSON 인코딩 및 디코딩을 위한 라이브러리
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 로컬 데이터 저장을 위한 라이브러리

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyDataWidget()); // 앱의 루트 위젯 설정
  }
}

class MyDataWidget extends StatefulWidget {
  @override
  _MyDataWidgetState createState() =>
      _MyDataWidgetState(); // 상태를 가지는 위젯의 상태 클래스 반환
}

class _MyDataWidgetState extends State<MyDataWidget> {
  MyData? _data; // 사용자 데이터 저장을 위한 변수

  @override
  void initState() {
    super.initState();
    _loadData(); // 사용자 데이터 로드
  }

  Future<void> _loadData() async {
    MyData? loadedData = await MyData.readInstance(); // 저장된 데이터 불러오기
    print(loadedData?.toJson()); // 로그 출력
    if (loadedData != null) {
      setState(() {
        _data = loadedData; // 로드된 데이터로 상태 업데이트
      });
    } else {
      setState(() {
        _data = MyData(name: 'my name', age: 1); // 초기 데이터 생성
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SharedPreferences Demo'), // 상단바 제목 설정
      ),
      body: _data == null
          ? CircularProgressIndicator() // 데이터 로딩 중일 때 로딩 아이콘 출력
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Name: ${_data!.name}'), // 사용자 이름 출력
                  Text('Age: ${_data!.age}'), // 사용자 나이 출력
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {
            _data!.age = _data!.age + 1; // 나이 증가
          });
          await _data?.saveInstance(); // 데이터 저장
        },
        tooltip: 'saveInstance',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MyData {
  String name;
  int age;

  MyData({required this.name, required this.age});

  String toJson() => json.encode({'name': name, 'age': age}); // JSON 형태로 인코딩

  factory MyData.fromJson(String str) {
    final jsonData = json.decode(str); // JSON 디코딩
    return MyData(
        name: jsonData['name'], age: jsonData['age']); // MyData 인스턴스 생성
  }

  static Future<MyData?> readInstance() async {
    final prefs =
        await SharedPreferences.getInstance(); // SharedPreferences 인스턴스 생성
    final jsonString =
        prefs.getString('myData'); // SharedPreferences에서 key가 'myData'인 값을 불러옴

    if (jsonString == null) {
      // 저장된 값이 없으면 null 반환
      return null;
    }

    return MyData.fromJson(jsonString); //
  }

  Future<void> saveInstance() async {
    final prefs =
        await SharedPreferences.getInstance(); // SharedPreferences 인스턴스 생성
    prefs.setString(
        'myData', toJson()); // key가 'myData'인 값에 MyData 인스턴스를 JSON으로 인코딩하여 저장
  }
}
