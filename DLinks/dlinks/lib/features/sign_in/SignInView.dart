import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/AppColor.dart';
import 'SignInViewModel.dart';

class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);
  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final SignInViewModel viewModel = Get.put(SignInViewModel());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "DUT Links",
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(
                height: 50,
              ),
              TextField(
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    const BorderSide(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  labelStyle: const TextStyle(color: Colors.black),
                  label: Row(
                    children: const [
                      SizedBox(
                        width: 10,
                      ),
                      Text("Email"),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    labelStyle: const TextStyle(color: Colors.black),
                    label: Row(
                      children: const [
                        SizedBox(
                          width: 10,
                        ),
                        Text("Password"),
                      ],
                    )),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Colors.black)),
                    onPressed: () {
                      //TODO: login with account
                      viewModel.showComingSoonDialog();
                    },
                    child: const Text(
                      'Sign in',
                      style: TextStyle(color: AppColor.BACKGROUND_WHITE),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      viewModel.showComingSoonDialog();
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          decoration: TextDecoration.underline),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin:
                    const EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                    height: 1.0,
                    width: 100,
                    color: Colors.black12,
                  ),
                  const Text('  Or  '),
                  Container(
                    margin:
                    const EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                    height: 1.0,
                    width: 100,
                    color: Colors.black12,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              _loginCard(() {
                viewModel.loginGoogle();
              }, 'Sign in with Google', "assets/icons/ic_google.png"),
              _loginCard(() {
                //TODO: login with phone number
                viewModel.loginPhoneNum();
                viewModel.showComingSoonDialog();
              }, 'Sign in with Phone Number', 'assets/icons/ic_phone.png'),
            ],
          ),
        ));
  }
  Widget _loginCard(VoidCallback onTap, String title, String imageAsset) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            width: double.infinity,
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 00, vertical: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5))
                ],
                border: Border.all(color: Colors.black54),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                const SizedBox(
                  width: 50,
                ),
                Image.asset(
                  imageAsset,
                  width: 30,
                  height: 30,
                  fit: BoxFit.fill,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            )));
  }
}

