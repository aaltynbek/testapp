import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.67),
        child: Container(
          color: Colors.black.withOpacity(0.5),
          width: 75,
          height: 75,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.transparent,
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 1,
              )
            ),
          )
        ),
      )
    );
  }
}