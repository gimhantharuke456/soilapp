import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soilapp/providers/user.provider.dart';
import 'package:soilapp/services/app.user.service.dart';
import 'package:soilapp/views/forum/create.forum.view.dart';
import 'package:soilapp/views/home/home.view.dart';
import 'package:soilapp/views/profile/profile.view.dart';
import 'package:soilapp/widgets/custom_filled_button.dart';

class ViewContainer extends StatefulWidget {
  const ViewContainer({super.key});

  @override
  State<ViewContainer> createState() => _ViewContainerState();
}

class _ViewContainerState extends State<ViewContainer> {
  int activeIndex = 0;
  final _userService = UserService();
  List<Widget> get views =>
      [const HomeView(), const CreateForum(), const UserProfileView()];

  @override
  void initState() {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    _userService.getCurrentUser().then((value) {
      if (value != null) {
        userProvider.setCurrentUser = value;
      }
      if (userProvider.currentUser == null) {
        showDialog(
            context: context,
            builder: (context) => Dialog(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 32),
                        const Text(
                          "Let's complete your profile first",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: 300,
                          child: CustomFilledButton(
                            text: "Go to Profile",
                            onPressed: () {
                              setState(() {
                                activeIndex = 2;
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
            barrierDismissible: false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: views[activeIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: activeIndex,
        onTap: (value) {
          debugPrint("cled");
          setState(() {
            activeIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Post Something',
            icon: Icon(Icons.post_add),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
