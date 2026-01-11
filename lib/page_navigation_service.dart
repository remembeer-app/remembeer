import 'package:remembeer/common/constants.dart';
import 'package:rxdart/rxdart.dart';

class PageNavigationService {
  final _pageIndexController = BehaviorSubject<int>.seeded(drinkPageIndex);

  Stream<int> get pageIndexStream => _pageIndexController.stream;

  int get currentPageIndex => _pageIndexController.value;

  void setPageIndex(int index) {
    _pageIndexController.add(index);
  }

  void dispose() {
    _pageIndexController.close();
  }
}
