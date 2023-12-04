

import 'package:flutter/widgets.dart';
import 'package:state_manage/subject/build_state.dart';
import 'package:state_manage/subject/publisher.dart';

/// [data] 当前数据
typedef WidgetBuilder<T> = Widget Function(BuildContext context, T? data);

typedef WidgetStateBuilder = Widget Function(BuildContext context);


///带状态的局部刷新组件
///
///使用方法
///
///1.创建Publisher
/// ```dart
/// _publisher = StatePublisher(BuildState.loading);
/// ```
///
/// 2.创建StateBuilder
/// ```dart
/// StateBuilder.fromState(
///   publisher: _publisher,
///   loading: (context) => const Text("加载中状态", style: TextStyle(fontSize: 20)),
///   data: (context) => const Text("数据状态", style: TextStyle(fontSize: 20)),
///   empty: (context) => const Text("空白状态", style: TextStyle(fontSize: 20)),
///   error: (context) => const Text("错误状态", style: TextStyle(fontSize: 20)),
/// );
/// ```
///
/// 3.修改状态
/// ```dart
/// _publisher?.notify(BuildState.data);
/// ```
class StateBuilder<T> extends StatefulWidget {

  final Publisher<T>? publisher;

  final WidgetBuilder<T>? builder;

  const StateBuilder({
    Key? key,
    this.publisher,
    required this.builder,
  }) : assert(builder != null),
        super(key: key);


  /// 页面多状态创建
  static StateBuilder<BuildState> fromState({Key? key,
    StatePublisher? publisher,
    WidgetStateBuilder? loading,
    WidgetStateBuilder? data,
    WidgetStateBuilder? empty,
    WidgetStateBuilder? error,
  }) {
    var builder = _buildStateBuilder(
        loading: loading,
        data: data,
        empty: empty,
        error: error
    );

    return StateBuilder<BuildState>(
        key: key,
        publisher: publisher,
        builder: builder
    );
  }


  /// 页面状态builder构建
  static WidgetBuilder<BuildState?> _buildStateBuilder({
    WidgetStateBuilder? loading,
    WidgetStateBuilder? data,
    WidgetStateBuilder? empty,
    WidgetStateBuilder? error
  }) {
    return (context, state) {
      Widget? result;
      if (state != null) {
        switch (state) {
          case BuildState.loading:
            result = loading?.call(context);
            break;
          case BuildState.data:
            result = data?.call(context);
            break;
          case BuildState.empty:
            result = empty?.call(context);
            break;
          case BuildState.error:
            result = error?.call(context);
            break;
        }
      }
      if(result == null) {
        return Container();
      }
      return result;
    };
  }

  @override
  State<StatefulWidget> createState() {
    return _StateBuilderState<T>();
  }


}

class _StateBuilderState<T> extends State<StateBuilder> {

  StateBuilder<T> get widgetT => (super.widget as StateBuilder<T>);

  @override
  void initState() {
    super.initState();
    widgetT.publisher?.addListener(_onRebuildEvent);
  }

  @override
  void dispose() {
    widgetT.publisher?.removeListener(_onRebuildEvent);
    super.dispose();
  }

  void _onRebuildEvent() {
    if (widgetT.publisher == null ||  !mounted) {
      return;
    }
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    var content = widgetT.builder?.call(context, widgetT.publisher?.currentData);
    return content ?? Container();
  }

}
