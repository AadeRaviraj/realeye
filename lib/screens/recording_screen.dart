import 'package:flutter/material.dart';


class RecordingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recording Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/aiwork.gif',
              width: 300,
              height: 300,
            ),
            //Icon(Icons.videocam, size: 100),
            SizedBox(height: 10),
            Text(
              'Module training is Work  in progress...',
              style: TextStyle(
                color: Colors.purple, // First part in teal
                // fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                overflow: TextOverflow.ellipsis,

                //fontStyle: FontStyle.italic,
                // color: Colors.deepPurple,
                //  letterSpacing: 1.2,
                //  wordSpacing: 2.0,
                //  height: 1.5,
                // decoration: TextDecoration.underline,
                // decorationColor: Colors.red,
                //  decorationStyle: TextDecorationStyle.dashed,
                // backgroundColor: Colors.yellow,
              ),
            ),
            SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.pop(context);  // Close the recording screen
            //   },
            //   child: Text('Stop Recording'),
            // ),
          ],
        ),
      ),
    );
  }

}
