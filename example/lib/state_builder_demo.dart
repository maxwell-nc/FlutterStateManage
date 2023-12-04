



import 'package:flutter/material.dart';
import 'package:state_manage/state_manage.dart';

class StateBuilderDemo extends StatefulWidget {

  const StateBuilderDemo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StateBuilderDemoState();
  }

}

class _StateBuilderDemoState extends State<StateBuilderDemo> {

  StatePublisher? _statePublisher;
  Publisher<String>? _stringPublisher;

  late Publisher<int> _mergePublisher1;
  late Publisher<int> _mergePublisher2;

  @override
  void initState() {
    super.initState();
    _statePublisher = StatePublisher(BuildState.loading);
    _stringPublisher = Publisher();

    _mergePublisher1 = Publisher();
    _mergePublisher2 = Publisher();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("状态构建器测试"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStatePublish(),
          _buildSimplePublish(),
          _buildMergePublish(),
        ],
      ),
    );

  }


  /// 简单局部刷新示例
  Widget _buildSimplePublish() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StateBuilder<String>(
              publisher: _stringPublisher,
              builder: (context, data) {
                return Text(data ?? "无数据", style: const TextStyle(fontSize: 20));
              }
          ),
          TextButton(
              onPressed: () {
                _stringPublisher?.notify("新文本1");
              },
              child: const Icon(Icons.publish_sharp)
          ),
          TextButton(
              onPressed: () {
                _stringPublisher?.notify("新文本2");
              },
              child: const Icon(Icons.publish_outlined)
          ),
        ],
      ),
    );
  }


  /// 多状态示例
  Widget _buildStatePublish() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          StateBuilder.fromState(
            publisher: _statePublisher,
            loading: (context) => const Text("加载中状态", style: TextStyle(fontSize: 20)),
            data: (context) => const Text("数据状态", style: TextStyle(fontSize: 20)),
            empty: (context) => const Text("空白状态", style: TextStyle(fontSize: 20)),
            error: (context) => const Text("错误状态", style: TextStyle(fontSize: 20)),
          ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    _statePublisher?.notify(BuildState.loading);
                  },
                  child: const Icon(Icons.downloading)
              ),
              TextButton(
                  onPressed: () {
                    _statePublisher?.notify(BuildState.error);
                  },
                  child: const Icon(Icons.error)
              ),
              TextButton(
                  onPressed: () {
                    _statePublisher?.notify(BuildState.empty);
                  },
                  child: const Icon(Icons.hourglass_empty)
              ),
              TextButton(
                  onPressed: () {
                    _statePublisher?.notify(BuildState.data);
                  },
                  child: const Icon(Icons.data_array)
              ),
            ],
          )
        ],
      );
  }


  /// 合并多个Publisher刷新示例
  Widget _buildMergePublish() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StateBuilder<int>(
              publisher: Publisher.merge([_mergePublisher1, _mergePublisher2], initData: 99999),
              builder: (context, data) {
                return Text( "$data", style: const TextStyle(fontSize: 20));
              }
          ),
          TextButton(
              onPressed: () {
                _mergePublisher1.notify(11111);
              },
              child: const Icon(Icons.nat)
          ),
          TextButton(
              onPressed: () {
                _mergePublisher2.notify(22222);
              },
              child: const Icon(Icons.nature)
          ),
        ],
      ),
    );
  }


}
