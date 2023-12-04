

import 'package:flutter/material.dart';
import 'package:state_manage/state_manage.dart';

class ProviderDemo extends StatefulWidget {

  const ProviderDemo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProviderDemoState();
  }

}

class _ProviderDemoState extends State<ProviderDemo> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("provider测试"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: const TestChildWidget(),
            ),
            TextButton(onPressed: (){
              Provider.of<int>(context)?.getAndChangeNotify((oldData){
                return (oldData ?? 0) + 1;
              });
            }, child: const Icon(Icons.plus_one)),
          ],
        ),
      ),
    );

  }

}

class TestChildWidget extends StatelessWidget {

  const TestChildWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 监听数据变化
    return Consumer<int>(builder: (context, value){
      return Text(
        'Provider共享的数据是： $value',
        style: Theme.of(context).textTheme.headline4,
      );
    });
  }

}