import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:flutter_application_1/pages/thermal_imaging.dart';

class SelectModelPage extends StatelessWidget {
  const SelectModelPage({super.key});
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Lifecycle Stage Prediction',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            actions: [
              IconButton(
                onPressed: signUserOut,
                icon: const Icon(Icons.logout),
                color: Colors.white,
              )
            ],
            backgroundColor: Colors.orange[400],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0), // Required padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.orangeAccent, // Orange accent color
                    child: const Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Center(
                        child: Text(
                          'Pre-harvest',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Text color
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40), // Spacing between cards
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PostHarvest()),
                    );
                  },
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.orangeAccent, // Orange accent color
                    child: const Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Center(
                        child: Text(
                          'Post-harvest',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Text color
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
