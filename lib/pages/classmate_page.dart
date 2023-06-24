import 'package:flutter/material.dart';

class Classmate extends StatefulWidget {
  const Classmate({super.key});

  @override
  State<Classmate> createState() => _ClassmateState();
}

class _ClassmateState extends State<Classmate> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Classmate Page',
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
            title: const Text('Classmate Page'),
          ),
          body: const Center(
            child: Text('This is classmate page'),
          ),
        ),
      ),
    );
  }
}
