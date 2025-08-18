import 'package:flutter/material.dart';
import 'package:shakti_hormann/app_bar.dart';
import 'package:shakti_hormann/pincode_field.dart';
import 'package:shakti_hormann/widgets/buttons/app_btn.dart';

class OtpVerificationPage extends StatelessWidget {
  const OtpVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             const CustomAppBar(),
              const SizedBox(height: 30),

              const Text(
                'OTP Verification',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              const Text(
                'Enter the verification code we just sent on your email address.',
                style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
              ),
              const SizedBox(height: 30),

              PincodeTextField(
                length: 4,
                onChanged: (value) {
                  
                },
              ),
              const SizedBox(height: 20),

               AppButton(
                  label: 'Login',
                  onPressed: () {
                    
                  },
                ),
              const SizedBox(height: 20),
              Center(
                child: RichText(
                  text:  const TextSpan(
                    text: "Didn't received code? ",
                    style:  TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Resend',
                        style:  TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
