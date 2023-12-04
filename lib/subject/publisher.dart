
import 'package:flutter/widgets.dart';
import 'package:state_manage/subject/build_state.dart';

/// 生产者
class Publisher<T> extends ChangeNotifier {

  /// 当前状态
  T? _currentData;

  T? get currentData => _currentData;

  bool _isClose = false;

  Publisher([T? initData]){
    _currentData = initData;
  }

  /// 合并多个操作
  static Publisher<T> merge<T>(Iterable<Publisher<T>> publishers, {T? initData}) {
    return MergePublisher<T>(publishers, initData);
  }

  /// 通知刷新
  /// 如果[data]为null，表示只发送通知刷新，不修改状态
  void notify([T? data]) {
    if (!_isClose) {
      if (data != null) {
        _currentData = data;
      }
      notifyListeners();
    }
  }


  @override
  void dispose() {
    _isClose = true;
    super.dispose();
  }

}


/// 页面状态用
class StatePublisher extends Publisher<BuildState> {

  /// [initState] 初始状态，不设置为data
  StatePublisher([BuildState? initState]) : super(initState ?? BuildState.data);

  /// 软通知刷新
  /// 如果当前状态还在Loading则不会刷新页面，等待变成其他状态后合并刷新
  /// 主要用于一个页面多个请求同时刷新界面
  void softNotify() {
    if (_currentData == BuildState.loading) {
      return;
    }

    notify();
  }

}


/// 合并多个Publisher状态用
class MergePublisher<T> extends Publisher<T> {

  final Iterable<_PublisherBind<T>> _publisherBinds;

  MergePublisher(Iterable<Publisher<T>> publishers, [T? initData])
      : _publisherBinds = publishers.map((publisher) => _PublisherBind(publisher)),
        super(initData);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    for (var publisherBind in _publisherBinds) {
      publisherBind.setListener((){
        // 每个子Publisher收到通知后，用MergePublisher重新发送通知
        notify(publisherBind.publisher._currentData);
      });
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
    for (var publisherBind in _publisherBinds) {
      // 直接移除全部即可
      publisherBind.removeListener();
    }
  }

}


/// 绑定用
class _PublisherBind<T> {

  final Publisher<T> publisher;

  /// 绑定用的，只支持一个Listener
  VoidCallback? listener;

  _PublisherBind(this.publisher);

  void setListener(VoidCallback listener) {
    if (this.listener != null) {
      removeListener();
    }
    this.listener = listener;
    publisher.addListener(listener);
  }

  void removeListener() {
    if (listener != null) {
      publisher.removeListener(listener!);
      listener = null;
    }
  }

}
