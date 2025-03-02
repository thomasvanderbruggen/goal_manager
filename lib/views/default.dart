import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:goal_manager/main.dart';

class DefaultPage extends StatelessWidget {
  const DefaultPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the app state
    var appState = context.watch<MyAppState>();

    // Define dimensions based on screen size
    var buttonHeight = MediaQuery.of(context).size.height * 0.25;
    var buttonWidth = MediaQuery.of(context).size.width * 0.8;

    // Color variables from your specified scheme
    final Color backgroundColor = Colors.black87!; // Deep dark background
    final Color cardGradientStart =
        Colors.black54; // Start of gradient for cards (lighter black/grey)
    final Color cardGradientEnd = Colors.grey[700]!; // End of gradient for cards (darker grey)
    final Color cardTextColor =
        Color.fromARGB(255, 233, 193, 108); // Amber text for buttons
    final Color cardShadowColor =
        Colors.grey.withOpacity(0.2); // Shadow color for buttons

    return Scaffold(
      backgroundColor: backgroundColor, // Deep dark background
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(
                  16.0), // Increased padding for modern spacing
              child: SizedBox(
                height: buttonHeight,
                width: buttonWidth,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        cardGradientStart, // Colors.black54
                        cardGradientEnd, // Colors.grey[700]!
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: cardShadowColor, // Colors.grey.withOpacity(0.2)
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      appState.setSelectedPage(1);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors
                          .transparent, // Transparent to show Container gradient
                      foregroundColor:
                          cardTextColor, // Amber text for consistency
                      elevation: 0, // No elevation, handled by Container shadow
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    label: Text(
                      'Tasks',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: cardTextColor, // Amber text for consistency
                      ),
                    ),
                    icon: Icon(
                      Icons.task,
                      size: 24, // Larger icon for better visibility
                      color: cardTextColor, // Amber icon for consistency
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(
                  16.0), // Increased padding for modern spacing
              child: SizedBox(
                height: buttonHeight,
                width: buttonWidth,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        cardGradientStart, // Colors.black54
                        cardGradientEnd, // Colors.grey[700]!
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: cardShadowColor, // Colors.grey.withOpacity(0.2)
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      appState.setSelectedPage(2);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors
                          .transparent, // Transparent to show Container gradient
                      foregroundColor:
                          cardTextColor, // Amber text for consistency
                      elevation: 0, // No elevation, handled by Container shadow
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    label: Text(
                      'Goals',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: cardTextColor, // Amber text for consistency
                      ),
                    ),
                    icon: Icon(
                      Icons.sports_score,
                      size: 24, // Larger icon for better visibility
                      color: cardTextColor, // Amber icon for consistency
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
