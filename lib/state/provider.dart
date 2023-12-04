


import 'package:flutter/widgets.dart';
import 'package:state_manage/state/provider_model.dart';
import 'package:state_manage/subject/publisher.dart';

class _ProviderInheritedWidget<T> extends InheritedWidget {

  /// 共享数据
  final ProviderModel<T> model;

  const _ProviderInheritedWidget({Key? key, required this.model, required child,})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant _ProviderInheritedWidget oldWidget) {
    // 通过其他方式刷新
    return model != oldWidget.model;
  }

}


/// 需要共享数据
///
/// 使用方法
///
/// 1.创建Provider：
///
/// ```dart
/// // 要共享数据
/// int counter = 0;
///
/// Provider(data: counter, child: YourFatherWidget());
/// ```
///
/// 2.需要监听子Widget：
///
/// ```dart
/// Consumer<int>(builder: (context, value) {
///   return Text(
///   'Provider共享的数据是： $value',
///   );
/// });
/// ```
///
/// 3.仅获取数据：
///
/// ```dart
/// Provider.of<int>(context)?.data;
/// ```
///
/// 4.修改数据并发送通知：
/// ```dart
/// Provider.of<int>(context)?.changeNotify(newData);
/// ```
class Provider<T> extends StatefulWidget {

  final T data;

  final Widget child;


  const Provider({Key? key, required this.data, required this.child}) : super(key: key);

  /// 仅用于获取数据或者通知更新数据
  static ProviderModel<T>? of<T> (BuildContext context){
    final inheritedWidget = context.getElementForInheritedWidgetOfExactType<_ProviderInheritedWidget<T>>()?.widget;

    if(inheritedWidget is _ProviderInheritedWidget<T>){
      return inheritedWidget.model;
    }
    return null;
  }

  /// 监听
  static ProviderModel<T>? listen<T> (BuildContext context) {
    // 仅区分用
    return of<T>(context);
  }


  @override
  State<StatefulWidget> createState() {
    return _ProviderState<T>();
  }

}


class _ProviderState<T> extends State<Provider> {

  Publisher<T>? _publisher;

  @override
  void initState() {
    super.initState();
    _publisher = Publisher(widget.data);
  }

  @override
  void dispose() {
    _publisher?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(Provider<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // provider的setState调用了，
    // 数据发生变化，需要通知
    if (oldWidget.data != widget.data) {
      _publisher?.notify(widget.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    ProviderModel<T> model = PublisherProviderModel<T>(_publisher)
      ..data = widget.data;

    return _ProviderInheritedWidget<T>(
      model: model,
      child: widget.child,
    );
  }

}


