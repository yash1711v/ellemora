import 'package:flutter/material.dart';

void navigate({required BuildContext context, required Widget widget}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

void navigateReplace({required BuildContext context, required Widget widget}) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => widget),
  );
}
