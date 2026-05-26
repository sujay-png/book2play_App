import 'package:flutter/material.dart';

class Kpiboxes extends StatelessWidget {
  final String title;
  final Color textcolor;
  final String subtile;
  final IconData? icon;
  final Color? iconcolor;
  const Kpiboxes({
    super.key,
    required this.title,
    required this.textcolor,
    required this.subtile,
    this.icon,
    this.iconcolor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 50,

        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          // Darker, more transparent color to match the image
          color: const Color(0xFF161B1B).withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white70, width: 1),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon,color: iconcolor,),
            Text(title, style: TextStyle(color: textcolor, fontSize: 25, fontWeight: FontWeight.bold)),

              ],
            ),
            Text(subtile,style: TextStyle(color: Colors.white70, fontSize: 15),),
          ],
        ),
      ),
    );
  }
}
