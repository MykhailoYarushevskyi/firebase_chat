import 'package:flutter/material.dart';

class ImageChooser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    return Container(
        child: FlatButton(
      child: Text(
        'BottomSheet',
      ),
      onPressed: () {
        Scaffold.of(context).showBottomSheet<void>(
          (context) => Container(
            height: deviceHeight * 0.33,
            child: Center(child: Text('BottomSheet'),),
          ),
        );
      },
    ));
  }
}
