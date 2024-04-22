import 'package:flutter/material.dart';

class NavBarProvider extends ChangeNotifier{

    int navBarIndex =0;

    void setIndex(index){
      navBarIndex =index;
      notifyListeners();
    }

}