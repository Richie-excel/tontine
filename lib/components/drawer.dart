import 'package:flutter/material.dart';
import 'package:tontine/components/build_list_tile.dart';
import 'package:tontine/screens/all_users.dart';
import 'package:tontine/screens/auth/register_screen.dart';

class DrawerComponent extends StatelessWidget {
  const DrawerComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Top Image Section
          DrawerHeader(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40, // Adjust size as needed
                  backgroundImage: AssetImage(
                      "assets/images/profile1.jpeg"), // Replace with your image
                ),
                const SizedBox(height: 10),
                const Text(
                  "Welcome User",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                
              ],
            ),
          ),

          // Drawer Items
          CustomListTile(
            icon: Icons.person_2,
            title: "Users",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UsersScreen()),
            ),
          ),

          CustomListTile(
            icon: Icons.person_add,
            title: "Register",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterScreen()),
            ),
          ),

          CustomListTile(
            icon: Icons.login,
            title: "Login",
            onTap: () => Navigator.pushNamed(context, '/login'),
          ),

          CustomListTile(
            icon: Icons.attach_money_outlined,
            title: "Contributions",
            onTap: () => Navigator.pushNamed(context, '/session-contributions'),
          ),

          CustomListTile(
            icon: Icons.attach_money,
            title: "Contribute",
            onTap: () => Navigator.pushNamed(context, '/contribute'),
          ),

          CustomListTile(
            icon: Icons.timelapse,
            title: "Sessions",
            onTap: () => Navigator.pushNamed(context, '/sessions'),
          ),

          CustomListTile(
            icon: Icons.settings,
            title: "Settings",
            onTap: () {
              // Handle navigation
            },
          ),

          CustomListTile(
            icon: Icons.logout,
            title: "Logout",
            onTap: () {
              // Handle logout logic
            },
          ),
        ],
      ),
    );
  }
}

