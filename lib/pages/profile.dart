import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile Page',
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Color(0xffffffff),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor: const Color(0xff292735),
            title: const Text('Profile Page'),
          ),
          body: const Center(child: Text('This is Profile Page')),
        ),
      ),
    );
  }
}
