import 'package:flutter_vibrate/flutter_vibrate.dart';

Future<void> triggerHapticFeedback() async {
  if (await Vibrate.canVibrate) {
    Vibrate.feedback(FeedbackType.medium);
  }
}