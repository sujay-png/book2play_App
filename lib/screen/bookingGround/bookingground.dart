import 'package:booktoplay_app/components/sports.dart';
import 'package:booktoplay_app/screen/bookingGround/grounddetails.dart';
import 'package:booktoplay_app/screen/bookingGround/sportsformpage.dart';
import 'package:flutter/material.dart';

class Bookingground extends StatelessWidget {
  const Bookingground({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  spacing: 15,
                  children: [
                    Text(
                      'Book2Play',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'What sport would you like to play?',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: Sports(
                        imageUrl:
                            'https://i.pinimg.com/736x/57/d9/30/57d930e4e78eb016ca7347e9d71aca10.jpg',
                        title: 'Turf Cricket',
                        ontap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GroundsResultPage(sportsname: 'Turf Cricket'),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Sports(
                        imageUrl:
                            'https://cdn3d.iconscout.com/3d/premium/thumb/badminton-racket-3d-icon-png-download-8500225.png',
                        title: 'Batminton',
                        ontap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GroundsResultPage(sportsname: 'Batminton'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: Sports(
                        imageUrl:
                            'https://img.freepik.com/premium-psd/isolated-soccer-ball-with-light-dark-blue-hexagonal-pentagonal-panels_1296892-1258.jpg?w=360',
                        title: 'Turf Soccer',
                        ontap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GroundsResultPage(sportsname: 'Turf Soccer'),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Sports(
                        imageUrl:
                            'https://cdn.creativefabrica.com/2023/03/21/Basketball-3D-Icon-and-Logo-Design-Graphics-64864759-1-312x208.jpg',
                        title: 'Basketball',
                        ontap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GroundsResultPage(sportsname: 'Basketball'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: Sports(
                        imageUrl:
                            'https://img.freepik.com/premium-vector/tennis-rackets-balls-outdoor-sports-equipment_68708-2767.jpg?semt=ais_hybrid&w=740&q=80',
                        title: 'Tennis',
                        ontap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GroundsResultPage(sportsname: 'Tennis'),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Sports(
                        imageUrl:
                            'https://images.emojiterra.com/microsoft/fluent-emoji/15.1/512px/1f3d0_color.png',
                        title: 'volleyball',
                        ontap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GroundsResultPage(sportsname: 'volleyball'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
