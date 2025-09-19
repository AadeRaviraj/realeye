// import 'package:flutter/material.dart';
//
// class FaceDetectionScreen extends StatelessWidget {
//   final VoidCallback onBackToHome;
//
//   const FaceDetectionScreen({Key? key, required this.onBackToHome}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final brightness = Theme.of(context).brightness;
//     final isDark = brightness == Brightness.dark;
//     return WillPopScope(
//       onWillPop: () async {
//         onBackToHome(); // Set index to Home when back button is pressed
//         return false; // Prevent default back action
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: RichText(
//             text: TextSpan(
//               children: [
//                 TextSpan(
//                   text: 'Real',
//                   style: TextStyle(
//                     color: Colors.orange,
//                     fontStyle: FontStyle.italic,
//                     fontSize: 20,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 TextSpan(
//                   text: 'Eye',
//                   style: TextStyle(
//                     color: Colors.purple,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           centerTitle: false,
//           leading: IconButton(
//             icon: Icon(
//               Icons.arrow_back,
//               color: isDark ? Colors.white : Colors.black,
//             ),
//           //  onPressed: () => Navigator.pop(context),
//             onPressed: (){
//               onBackToHome();
//
//             },
//
//           ),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(
//                 'assets/images/aiwork.gif',
//                 width: 300,
//                 height: 300,
//               ),
//               //Icon(Icons.videocam, size: 100),
//               SizedBox(height: 10),
//               Text(
//                   'Module training is Work  in progress...',
//                 style: TextStyle(
//                 color: Colors.purple, // First part in teal
//                 // fontWeight: FontWeight.bold,
//                 fontStyle: FontStyle.italic,
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//                 overflow: TextOverflow.ellipsis,
//
//                 //fontStyle: FontStyle.italic,
//                 // color: Colors.deepPurple,
//                 //  letterSpacing: 1.2,
//                 //  wordSpacing: 2.0,
//                 //  height: 1.5,
//                 // decoration: TextDecoration.underline,
//                 // decorationColor: Colors.red,
//                 //  decorationStyle: TextDecorationStyle.dashed,
//                 // backgroundColor: Colors.yellow,
//               )),
//               SizedBox(height: 20),
//               // ElevatedButton(
//               //   onPressed: () {
//               //     Navigator.pop(context);  // Close the recording screen
//               //   },
//               //   child: Text('Stop Recording'),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// // }
// import 'package:flutter/material.dart';
//
// class FaceDetectionScreen extends StatelessWidget {
//   final VoidCallback onBackToHome;
//
//   const FaceDetectionScreen({Key? key, required this.onBackToHome}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final brightness = Theme.of(context).brightness;
//     final isDark = brightness == Brightness.dark;
//
//     return WillPopScope(
//       onWillPop: () async {
//         onBackToHome();
//         return false;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: RichText(
//             text: const TextSpan(
//               children: [
//                 TextSpan(
//                   text: 'Real',
//                   style: TextStyle(
//                     color: Colors.orange,
//                     fontStyle: FontStyle.italic,
//                     fontSize: 20,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 TextSpan(
//                   text: 'Eye',
//                   style: TextStyle(
//                     color: Colors.purple,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           centerTitle: false,
//           leading: IconButton(
//             icon: Icon(
//               Icons.arrow_back,
//               color: isDark ? Colors.white : Colors.black,
//             ),
//             onPressed: () {
//               onBackToHome();
//             },
//           ),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Image.asset(
//                 'assets/images/safe_girl.png', // <-- Replace with your image
//                 width: 250,
//                 height: 250,
//                 fit: BoxFit.contain,
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'कृपया कोणत्याही AI आपले फोटो अपलोड करू नका.\n\n'
//                     'आपल्या चेहर्‍याचा गैरवापर होऊ शकतो.\n\n'
//                     'ही विनंती विशेषतः तरुण मुलींसाठी आहे –\n'
//                     'स्वतःच्या गोपनीयतेची आणि सुरक्षेची काळजी घ्या.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 18,
//                   color: Colors.deepPurple,
//                   fontWeight: FontWeight.w600,
//                   height: 1.5,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
//
// class FaceDetectionScreen extends StatelessWidget {
//   final VoidCallback onBackToHome;
//
//   const FaceDetectionScreen({Key? key, required this.onBackToHome}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final brightness = Theme.of(context).brightness;
//     final isDark = brightness == Brightness.dark;
//
//     return WillPopScope(
//       onWillPop: () async {
//         onBackToHome();
//         return false;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: RichText(
//             text: const TextSpan(
//               children: [
//                 TextSpan(
//                   text: 'Real',
//                   style: TextStyle(
//                     color: Colors.orange,
//                     fontStyle: FontStyle.italic,
//                     fontSize: 20,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 TextSpan(
//                   text: 'Eye',
//                   style: TextStyle(
//                     color: Colors.purple,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           centerTitle: false,
//           leading: IconButton(
//             icon: Icon(
//               Icons.arrow_back,
//               color: isDark ? Colors.white : Colors.black,
//             ),
//             onPressed: () {
//               onBackToHome();
//             },
//           ),
//         ),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // 3 symbolic girl images
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Image.asset('assets/images/girl1.png', width: 90, height: 90, fit: BoxFit.cover),
//                   Image.asset('assets/images/girl2.png', width: 90, height: 90, fit: BoxFit.cover),
//                   Image.asset('assets/images/girl3.png', width: 90, height: 90, fit: BoxFit.cover),
//                 ],
//               ),
//               const SizedBox(height: 30),
//
//               Image.asset(
//                 'assets/images/safe_girl.png',
//                 width: 200,
//                 height: 200,
//                 fit: BoxFit.contain,
//               ),
//               const SizedBox(height: 25),
//
//               const Text(
//                 'जे तुम्हाला साडी घालू शकते,\nतेच तुमची साडी काढू पण शकते...\n\n'
//                     'आजकाल काही AI प्लॅटफॉर्म्सवर फोटो दिल्यावर ते फोटो बदलले, एडिट केले किंवा नकली बनवले जाऊ शकतात.\n'
//                     'कोणीतरी तुमच्या चेहर्‍याचा वापर करून चुकीच्या, अश्लील किंवा अपमानास्पद गोष्टी तयार करू शकतो.\n\n'
//                     '➡ म्हणूनच, **कृपया कोणत्याही AI प्लॅटफॉर्मवर आपले खरे फोटो अपलोड करू नका.**\n\n'
//                     'ही विनंती विशेषतः तरुण मुलींसाठी आहे —\n'
//                     'स्वतःच्या गोपनीयतेची आणि सुरक्षेची काळजी घ्या.\n\n'
//                     '⚠️ तुमचा चेहरा हा तुमची ओळख आहे.\nतो एकदा इंटरनेटवर गेला की परत आणता येत नाही.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 17,
//                   color: Colors.deepPurple,
//                   fontWeight: FontWeight.w600,
//                   height: 1.6,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class FaceDetectionScreen extends StatelessWidget {
  final VoidCallback onBackToHome;

  const FaceDetectionScreen({Key? key, required this.onBackToHome}) : super(key: key);

  // 🖼 Widget to build framed photo with name
  Widget buildImageFrame(String imagePath, String name) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.deepPurple, width: 3),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: const Offset(2, 4),
              ),
            ],
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.deepPurple,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async {
        onBackToHome();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Real',
                  style: TextStyle(
                    color: Colors.orange,
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: 'Eye',
                  style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          centerTitle: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () {
              onBackToHome();
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 👩‍🎓 3 framed images
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildImageFrame('assets/images/img_1.jpg', '.'),
                  buildImageFrame('assets/images/img_2.jpg', '.'),
                  buildImageFrame('assets/images/img_3.jpg', '.'),
                ],
              ),
              const SizedBox(height: 10),

              // Central Safe Image
              Image.asset(
                'assets/images/img_1.jpg',
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 15),

              // ⚠️ Safety Message
              // const Text(
              //   'जे तुम्हाला साडी घालू शकते,  तेच ती काढूही शकते.\n'
              //       'आजकाल काही AI प्लॅटफॉर्म्सवर फोटो दिल्यावर ते फोटो बदलले, एडिट केले किंवा नकली बनवले जाऊ शकतात.\n'
              //       'कोणीतरी तुमच्या चेहर्‍याचा वापर करून चुकीच्या, अश्लील किंवा अपमानास्पद गोष्टी तयार करू शकतो.\n'
              //       '📸 म्हणूनच, फोटो अपलोड करताना १० वेळा विचार करा\n'
              //       'ही विनंती विशेषतः मुलींसाठी आहे —\n'
              //       'स्वतःच्या गोपनीयतेची आणि सुरक्षेची काळजी घ्या.\n'
              //       '⚠ तुमचा चेहरा हा तुमची ओळख आहे.\nतो एकदा इंटरनेटवर गेला की परत आणता येत नाही.\n'
              //       'स्वतःचं काय योग्य, काय अयोग्य — हे तुम्ही तुमच्या Realeye ने पाहा',
              //   textAlign: TextAlign.left,
              //   style: TextStyle(
              //     fontSize: 15,
              //     color: Colors.black,
              //     fontWeight: FontWeight.w600,
              //     height: 1.6,
              //   ),
              // ),
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    height: 1.6,
                  ),
                  children: [
                    TextSpan(
                      text: '❗ जे तुम्हाला साडी घालू शकते, तेच ती काढूही शकते.\n',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
                      text:
                      'आजकाल काही AI प्लॅटफॉर्म्सवर फोटो दिल्यावर ते फोटो बदलले, एडिट केले किंवा नकली बनवले जाऊ शकतात.\n'
                          'कोणीतरी तुमच्या चेहर्‍याचा वापर करून चुकीच्या, अश्लील किंवा अपमानास्पद गोष्टी तयार करू शकतो.\n'
                          '📸 म्हणून, फोटो अपलोड करताना १० वेळा विचार करा,\n'
                          'स्वतःच्या गोपनीयतेची आणि सुरक्षेची काळजी घ्या.\n'
                          '⚠ तुमचा चेहरा हा तुमची ओळख आहे.\nतो एकदा इंटरनेटवर गेला की परत आणता येत नाही.\n'
                          'स्वतःचं काय योग्य, काय अयोग्य — हे तुम्ही तुमच्या Realeye ने पाहा',
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
