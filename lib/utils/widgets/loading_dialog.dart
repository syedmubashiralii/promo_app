import 'package:flutter/material.dart';
import 'package:flutter_ui/utils/extensions.dart';

import '../color_helper.dart';

class LoadingDialog extends StatelessWidget {
  final String? text;
  const LoadingDialog({
    Key? key,
    this.text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: Colors.transparent,
            width: 35,
            height: 35,
            child: const CircularProgressIndicator(color: ColorHelper.primaryColor,)
          ),
          5.SpaceX,
          if(text!=null)
          Material(
            
            child: Text(text??"",style: TextStyle(fontSize: 15),))
        ],
      ),
    );
  }
}
