import 'package:dlinks/architecture/BaseViewModel.dart';

class SplashViewModel extends BaseViewModel {
  int count = 0;

  void increment() {
    count++;
    notifyListeners();
  }

  void decrement() {
    count--;
    notifyListeners();
  }
}
