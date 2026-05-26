import 'package:booktoplay_app/auth/mobile_login.dart';
import 'package:booktoplay_app/auth/register.dart';
import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  bool issignup=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Auth'),
        backgroundColor: Colors.blue,
        centerTitle: true,

      ),
      body: SingleChildScrollView(
        child:Container(
          padding: EdgeInsets.symmetric(vertical: 48,horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Welcome to our App', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),),
              SizedBox(height: 16,),
             if(issignup)
             Column(
              children: [
                MobileLoging(),
                SizedBox(height: 16,),
                Text('Already have an account?', style: TextStyle(fontSize: 16,color: Colors.grey),),
                TextButton(onPressed: (){
                  setState(() {
                    issignup=false;
                  });

                }, style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                ), child: Text('sign In instead'),)
              ],
             ),
             if(!issignup)
             Column(
              children: [
                Register(),
                SizedBox(height: 16,),
                Text('Don\'t have an account?', style: TextStyle(fontSize: 16,color: Colors.grey),),
                TextButton(onPressed: (){
                  setState(() {
                    issignup=true;
                  });

                }, style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                ), child: Text('sign Up instead'),)
              ],
             ),
            
            ],
          ),
             

        ),
      ),
      
    );
  }
}