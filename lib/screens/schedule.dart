import 'package:flutter/material.dart';

class Schedule extends StatelessWidget {
  const Schedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Container(),
            Container(),
            Container(),
            ListView()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){}),
    );
  }
}
