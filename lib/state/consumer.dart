

import 'package:flutter/widgets.dart';
import 'package:state_manage/state/provider.dart';
import 'package:state_manage/state/provider_model.dart';
import 'package:state_manage/subject/publisher.dart';
import 'package:state_manage/subject/state_builder.dart';

class Consumer<T> extends StatelessWidget {

  /// 构建子Widget
  final Widget Function(BuildContext context, T? value) builder;

  const Consumer({Key? key,required this.builder,}):super(key:key);

  @override
  Widget build(BuildContext context) {
    Publisher<T>? publisher;
    var providerModel = Provider.listen<T>(context);
    if (providerModel is PublisherProviderModel<T>?) {
      publisher = providerModel?.publisher;
    }

    //绑定注册依赖关系
    return StateBuilder<T>(
        publisher: publisher,
        builder: (context, data) {
          return builder.call(context, data);
        }
    );
  }

}


