import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomErrorBuilder extends StatelessWidget {
  const CustomErrorBuilder({super.key, required this.errorDetails});

  final FlutterErrorDetails errorDetails;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/icons/frame_error-page.png'),
                Text(
                  kDebugMode
                      ? errorDetails.summary.toString()
                      : 'Oups! Something went wrong!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: kDebugMode ? Colors.red : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  kDebugMode
                      ? errorDetails.exception.toString()
                      : "We encountered an error and we've notified our engineering team about it. Sorry for the inconvenience caused.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                SizedBox(height: 20),
                // ElevatedButton(
                //   onPressed: () {
                //     if (kDebugMode) {
                //       FlutterError.dumpErrorToConsole(errorDetails);
                //     }
                //     Navigator.of(context).pop();
                //   },
                //   child: const Text('Back'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
