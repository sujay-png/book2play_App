import 'package:flutter/material.dart';

class Sports extends StatelessWidget {
  final String imageUrl;
  final String title;
  final VoidCallback ontap;
  const Sports({super.key, required this.imageUrl, required this.title, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.greenAccent.shade100,
        ),
        child: Column(
          children: [
           Image.network(
              imageUrl,
              height: 100, // Set a fixed height so it looks like an icon
              width: 100,
              fit: BoxFit.contain,
            ),
            Text(title,style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w500),)
          ],
        ),
      ),
    );
  }
}