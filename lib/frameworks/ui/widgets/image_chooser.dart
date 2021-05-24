import 'package:flutter/material.dart';

class ImageChooser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    const String imageUrl =
         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg';
    return TextButton(
      onPressed: () {
    // Scaffold.of(context).showBottomSheet<void>()
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: deviceHeight * 0.33,
        child: Center(
          // child: Text('BottomSheet'),
          child: Image.network(imageUrl),
        ),
      ),
    );
      },
      child: const Text(
    'BottomSheet',
      ),
    );
  }
}
