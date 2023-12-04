

import 'package:flutter/material.dart';
import 'package:state_manage/state_manage.dart';

class MsgBusDemo extends StatefulWidget {

  const MsgBusDemo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MsgBusDemoState();
  }

}

class _MsgBusDemoState extends State<MsgBusDemo> {

  String? _eventText;


  @override
  void initState() {
    super.initState();
    MsgBus.register(this, _onEvent);
  }

  @override
  void dispose() {
    MsgBus.unRegister(this);
    super.dispose();
  }

  void _onEvent(TestEvent event) {
    setState(() {
      _eventText = event.data;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("消息总线测试"),
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
              child: Text("接收到的消息 $_eventText", style: const TextStyle(fontSize: 20),),
            ),
            TextButton(
                onPressed: () {
                  MsgBus.post(TestEvent(DateTime.now().toString()));
                },
                child: const Icon(Icons.send)
            ),
          ],
        ),
      ),
    );

  }

}

class TestEvent {

  String data;

  TestEvent(this.data);

}