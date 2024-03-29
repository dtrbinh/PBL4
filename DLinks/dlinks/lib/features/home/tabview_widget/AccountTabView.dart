import 'package:dlinks/data/constant/AppUtils.dart';
import 'package:dlinks/data/repository/UserRepository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'AccountTabViewModel.dart';

class AccountTabView extends StatefulWidget {
  const AccountTabView({Key? key}) : super(key: key);

  @override
  State<AccountTabView> createState() => _AccountTabViewState();
}

class _AccountTabViewState extends State<AccountTabView> {
  final viewModel = Get.put(AccountTabViewModel());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(viewModel
                              .c.userProvider.value.currentUser?.photoURL ??
                          AppUtils.AVATAR_PLACEHOLDER),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Center(
                  child: Text(
                    viewModel.c.userProvider.value.currentUser!.displayName!,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              // Personal Information
              Row(
                children: const [
                  Icon(Icons.person),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Personal Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Icon(Icons.email),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'Email: ',
                    style: TextStyle(fontSize: 16),
                  ),
                  Flexible(
                    child: Text(
                      viewModel.c.userProvider.value.currentUser!.email ??
                          'Not set',
                      style: const TextStyle(fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Icon(Icons.phone),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'Phone: ',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    viewModel.c.userProvider.value.currentUser!.phoneNumber ??
                        "Not set",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Icon(Icons.location_on),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'Last sign in: ',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    DateFormat('kk:mm - dd/MM/yyyy').format(viewModel
                        .c
                        .userProvider
                        .value
                        .currentUser!
                        .metadata
                        .lastSignInTime!),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              // Account Information
              Row(
                children: const [
                  Icon(Icons.account_circle),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Account Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: const [
                  Icon(Icons.lock),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Change Password',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  //confirm dialog
                  if (!mounted) return;
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm'),
                      content: const Text('Are you sure to log out?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            viewModel.logout();
                            // Get.find<UserProvider>().reset();
                            // Get.deleteAll();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                child: Row(
                  children: const [
                    Icon(Icons.logout),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Logout',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
