import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {

  final String title;

  EmptyState({super.key, required this.title});

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRect(
            child: Image.asset(
              'images/empty_chairs.jpg',
              alignment: Alignment.topCenter,
              fit: BoxFit.cover,
              height: 280,
            ),
          ),
          SizedBox(height: 30),
          TweenAnimationBuilder(
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 19, color: Colors.black87),
                ),
              ),
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(milliseconds: 1100),
              builder: (context, _tweenValue, child) {
                return Opacity(
                    opacity: _tweenValue,
                  child: Padding(
                      padding: EdgeInsets.only(top: _tweenValue * 25),
                    child: child,
                  ),
                );
              }
          )
        ],
      ),
    );
  }
}