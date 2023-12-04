

import 'package:state_manage/subject/publisher.dart';

typedef ChangeFunction<T> = T Function(T? oldData);

abstract class ProviderModel<T> {

  /// 共享数据
  T? data;

  /// 通知更新
  void changeNotify(T newData);

  /// 通知更新
  void getAndChangeNotify(ChangeFunction<T> map);
}

class PublisherProviderModel<T> extends ProviderModel<T> {

  final Publisher<T>? _publisher;

  PublisherProviderModel(this._publisher);

  Publisher<T>? get publisher => _publisher;

  @override
  void changeNotify(T newData) {
    data = newData;
    _publisher?.notify(data);
  }

  @override
  void getAndChangeNotify(ChangeFunction<T> map) {
    changeNotify(map(data));
  }

}

