import 'dart:collection';

class Cstack<T>{
  final _stack = Queue<T>();

  void push(T element) {
    _stack.addLast(element);
  }

  T pop() {
    final T lastElement = _stack.last;
    _stack.removeLast();
    return lastElement;
  }
  
  void clear() {
    _stack.clear();
  }

  T get peak => _stack.last;

  bool get isEmpty => _stack.isEmpty;
}