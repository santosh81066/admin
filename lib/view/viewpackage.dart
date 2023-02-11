import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purohithulu_admin/controller/apicalls.dart';

import '../utlis/purohitapi.dart';
import '../widgets/app_drawer.dart';

class ViewPackage extends StatefulWidget {
  const ViewPackage({super.key});

  @override
  State<ViewPackage> createState() => _ViewPackageState();
}

class _ViewPackageState extends State<ViewPackage> {
  @override
  void initState() {
    Provider.of<ApiCalls>(context, listen: false).getPackages(context);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var apiCalls = Provider.of<ApiCalls>(context);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              physics: const ScrollPhysics(parent: null),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Dismissible(
                  background: Container(
                    color: Theme.of(context).errorColor,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 4,
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) {
                    return showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Are you sure?'),
                        content: const Text(
                          'Do you want to remove the package?',
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('No'),
                            onPressed: () {
                              Navigator.of(ctx).pop(false);
                            },
                          ),
                          TextButton(
                            child: const Text('Yes'),
                            onPressed: () {
                              Navigator.of(ctx).pop(true);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (direction) {
                    apiCalls.deletePackage(
                        apiCalls.packages![index]['id'], context);
                  },
                  key: UniqueKey(),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: apiCalls.package == null
                        ? Container(child: const Text("no data"))
                        : Column(
                            children: [
                              Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        "${PurohitApi().baseUrl}${PurohitApi().packageId}${apiCalls.packages![index]['id']}${PurohitApi().imageId}${apiCalls.packages![index]['vehicleid']}",
                                        headers: {
                                          "Authorization": apiCalls.token!
                                        }),
                                  ),
                                  title: Text(
                                      apiCalls.packages![index]['packageName']),
                                  trailing: Text(
                                      'amount: ${apiCalls.packages![index]['amount'].toString()} Rs'),
                                  subtitle: Text(
                                      'minutes: ${apiCalls.packages![index]['hours'].toString()}'),
                                ),
                              ),
                            ],
                          ),
                  ),
                );
              },
              itemCount:
                  apiCalls.packages == null ? 0 : apiCalls.packages!.length,
            ),
          ],
        ),
      ),
    );
  }
}
