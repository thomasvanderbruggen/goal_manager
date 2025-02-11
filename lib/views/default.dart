
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:goal_manager/main.dart';

class DefaultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var buttonHeight = MediaQuery.of(context).size.height * .25;
    var buttonWidth = MediaQuery.of(context).size.width * .8; 

    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: buttonHeight, 
            width: buttonWidth,
            child: ElevatedButton.icon(
              onPressed: ()  {
                appState.setSelectedPage(1); 
              },
              label: Text('Tasks'), 
              icon: Icon(Icons.task)),
        )), 
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: buttonHeight, 
            width: buttonWidth,
            child: ElevatedButton.icon(
              onPressed: () {
                appState.setSelectedPage(2); 
              }, 
              label: Text('Goals'), 
              icon: Icon(Icons.sports_score)
          ),
        ))
      ],);

    // TODO: implement build
    throw UnimplementedError();
  }
}