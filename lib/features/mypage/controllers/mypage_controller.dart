import 'package:flutter_riverpod/flutter_riverpod.dart';

final myPageControllerProvider = NotifierProvider<MyPageController, int>(
  MyPageController.new,
);

class MyPageController extends Notifier<int> {
  @override
  int build() => 0;

  void setTabIndex(int index) {
    state = index;
  }
}
