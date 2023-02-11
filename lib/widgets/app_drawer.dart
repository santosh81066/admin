import '../controller/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('My profile'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.luggage),
            title: const Text("Packages"),
            onTap: () {
              Navigator.of(context).pushNamed('createPackage');
              //Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.location_city),
            title: const Text("location"),
            onTap: () {
              Navigator.of(context).pushNamed('location');
              //Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.handshake),
            title: const Text("Catagories"),
            onTap: () {
              Navigator.of(context).pushNamed('insertCat');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text("Users"),
            onTap: () {
              //Navigator.pop(context);
              // Navigator.of(context).pushReplacementNamed('/');
              Navigator.of(context).pushNamed('users');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text("Contact Us"),
            onTap: () {
              // Navigator.of(context)
              //     .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Logout"),
            onTap: () async {
              //Navigator.pop(context);
              // Navigator.of(context).pushReplacementNamed('/');
              await Provider.of<Auth>(context, listen: false).logout().then(
                  (value) => Navigator.of(context).pushNamedAndRemoveUntil(
                      '/', (Route<dynamic> route) => false));
            },
          ),
        ],
      ),
    );
  }
}
