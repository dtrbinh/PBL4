import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/ChatUser.dart';
import 'ContactTabViewModel.dart';

class ContactTabView extends StatefulWidget {
  const ContactTabView({Key? key}) : super(key: key);

  @override
  State<ContactTabView> createState() => _ContactTabViewState();
}

class _ContactTabViewState extends State<ContactTabView> {
  final ContactTabViewModel viewModel = Get.put(ContactTabViewModel());

  @override
  void initState() {
    viewModel.getContact();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(8.0),
      height: MediaQuery.of(context).size.height,
      child: RefreshIndicator(
        onRefresh: () async {
          await viewModel.getContact();
        },
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
                children: <Widget>[
                      const SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          controller: viewModel.textEditingController.value,
                          decoration: InputDecoration(
                              hintText: "Search other user",
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black45, width: 1),
                                  borderRadius: BorderRadius.circular(6))),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ] +
                    viewModel.contacts.map((e) => _userCard(e)).toList()),
          ),
        ),
      ),
    ));
  }

  Widget _userCard(ChatUser user) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 12,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.black45, width: 1),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
            )
          ],
          color: Colors.white),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black45, width: 0.5),
                image: DecorationImage(
                  image: NetworkImage(user.photoURL!),
                ),
                shape: BoxShape.circle),
          ),
          const SizedBox(
            width: 30,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(user.displayName!),
              Text(user.email!),
            ],
          ),
          const Spacer(),
          IconButton(onPressed: () {}, icon: const Icon(Icons.add))
        ],
      ),
    );
  }
}
