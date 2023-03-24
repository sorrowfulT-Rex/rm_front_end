import 'dart:async';

import 'package:flutter/widgets.dart';

class InputManager<T> extends ChangeNotifier {
  /// The text controller for the input field.
  final textController = TextEditingController();

  /// Whether the input field has any input.
  bool _hasInput = false;

  /// The current searched input.
  String? _currentSearchedInput;

  /// The data returned from the callback.
  T? _data;

  /// The timestamp of the latest request.
  int _timestamp = DateTime.now().millisecondsSinceEpoch;

  bool get hasInput => _hasInput;
  String? get currentSearchedInput => _currentSearchedInput;
  T? get data => _data;

  /// Initialise the internal [textController] and add a listener that triggers
  /// when the emptyness of the input text changes.
  void initState() {
    textController.addListener(() {
      final hasInput =
          textController.text.isNotEmpty || _currentSearchedInput != null;
      if (hasInput != _hasInput) {
        _hasInput = hasInput;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  /// Query using the callback with the input text.
  Future<void> onQuery(FutureOr<T?> Function(String) callback) async {
    final inputText = textController.text;

    // If the input text is empty, use the current searched input.
    if (inputText.isEmpty) {
      final curInput = _currentSearchedInput;
      if (curInput == null) {
        return;
      }
      textController.text = curInput;
    } else {
      final curTimestamp = DateTime.now().millisecondsSinceEpoch;
      _timestamp = curTimestamp;

      final response = await callback(inputText);

      // If the response is not the latest one, ignore it.
      if (curTimestamp < _timestamp) {
        return;
      }

      _currentSearchedInput = inputText;
      _data = response;
    }

    notifyListeners();
  }

  /// Clear the input text and reset the data.
  void onReset() {
    textController.clear();
    _hasInput = false;
    _currentSearchedInput = null;
    _data = null;
    notifyListeners();
  }
}
