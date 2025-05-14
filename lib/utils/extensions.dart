
import 'package:flutter/material.dart';


enum AccountType { referrer, business, client }

extension CustomSpacing on num {
  SizedBox get SpaceX {
    return SizedBox(height: toDouble());
  }

  SizedBox get SpaceY {
    return SizedBox(width: toDouble());
  }
}


