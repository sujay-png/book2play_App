import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class AccountDetailsScreen extends StatelessWidget {
  final String email;
  final String uid;

  const AccountDetailsScreen({
    super.key, 
    required this.email, 
    required this.uid
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161B1B),
      appBar: AppBar(
        leading: IconButton(onPressed: (){
         context.go('/profile');

        }, 
        
        icon:Icon( Icons.arrow_back,color: Colors.white,)),
        title: const Text('Account Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            const Divider(color: Colors.white24),
            ListTile(
              title: const Text('Email Address', style: TextStyle(color: Colors.grey)),
              subtitle: Text(email, style: const TextStyle(color: Colors.white, fontSize: 18)),
            ),
            const Divider(color: Colors.white24),
            ListTile(
              title: const Text('Password', style: TextStyle(color: Colors.grey)),
              subtitle: const Text('••••••••••••', style: TextStyle(color: Colors.white, fontSize: 18)),
              trailing: TextButton(
                onPressed: () async {
                  try {
                    // Send a secure reset link to the user's email registered in Firebase Auth
                    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Password reset link sent to $email')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${e.toString()}')),
                    );
                  }
                },
                child: const Text('Reset', style: TextStyle(color: Colors.cyan)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}