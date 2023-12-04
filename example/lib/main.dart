import 'package:example/msgbus_demo.dart';
import 'package:example/provider_demo.dart';
import 'package:example/state_builder_demo.dart';
import 'package:flutter/material.dart';
import 'package:state_manage/state_manage.dart';

void main() {
  int counter = 0;

  // 共享数据
  runApp(Provider(data: counter, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '状态管理测试',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '状态管理测试'),
    );
  }
}

class MyHomePage extends StatefulWidget {

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: _providerTest,
              child: const Text("Provider测试页面", style: TextStyle(fontSize: 20),),
            ),
            const SizedBox(height: 20,),
            TextButton(
              onPressed: _providerAdd,
              child: const Text("Provider数据重置", style: TextStyle(fontSize: 20),),
            ),
            const SizedBox(height: 20,),
            TextButton(
              onPressed: _msgBusTest,
              child: const Text("MsgBus测试页面", style: TextStyle(fontSize: 20),),
            ),
            const SizedBox(height: 20,),
            TextButton(
              onPressed: _stateBuilderTest,
              child: const Text("状态构建器页面", style: TextStyle(fontSize: 20),),
            ),
          ],
        ),
      ),
    );
  }


  void _providerTest() {
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return const ProviderDemo();
    }));
  }

  void _providerAdd() {
    Provider.of<int>(context)?.changeNotify(0);
  }

  void _msgBusTest() {
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return const MsgBusDemo();
    }));
  }

  void _stateBuilderTest() {
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return const StateBuilderDemo();
    }));
  }

}


