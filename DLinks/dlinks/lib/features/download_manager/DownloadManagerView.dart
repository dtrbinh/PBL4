import 'dart:io';

import 'package:dlinks/features/home/HomeViewModel.dart';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:open_file/open_file.dart';

import '../../utils/AppColor.dart';
import 'DownloadManagerViewModel.dart';

class DownloadManagerView extends StatefulWidget {
  const DownloadManagerView({Key? key}) : super(key: key);

  @override
  State<DownloadManagerView> createState() => _DownloadManagerViewState();
}

class _DownloadManagerViewState extends State<DownloadManagerView> {
  final viewModel = Get.put(DownloadManagerViewModel());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel.initData();
  }

  @override
  Widget build(BuildContext context) {
    return ControlBackButton(
      controller: viewModel.controller,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () => createFolder(context),
              icon: const Icon(Icons.create_new_folder_outlined),
            ),
            IconButton(
              onPressed: () => sort(context),
              icon: const Icon(Icons.sort_rounded),
            ),
            IconButton(
              onPressed: () => selectStorage(context),
              icon: const Icon(Icons.sd_storage),
            )
          ],
          title: GetBuilder<DownloadManagerViewModel>(
            builder: (model) {
              return Text(viewModel.title.value);
            },
          ),
          leadingWidth: 40,
          leading: IconButton(
            padding: const EdgeInsets.only(left: 20),
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () async {
              debugPrint(viewModel.controller.getCurrentPath);
              if (viewModel.controller.getCurrentPath == "/storage/emulated/0/Download/DLinks/" ||
                  await viewModel.controller.isRootDirectory()) {
                Get.find<HomeViewModel>().changeTab(0);
              } else {
                await viewModel.controller.goToParentDirectory();
              }
            },
          ),
        ),
        body: FileManager(
          controller: viewModel.controller,
          emptyFolder: const Center(
            child: Text('Empty Folder'),
          ),
          loadingScreen: Center(
            child: SpinKitFadingCircle(
              size: MediaQuery.of(context).size.width / 5,
              color: AppColor.BLACK,
            ),
          ),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: snapshot.length,
              itemBuilder: (context, index) {
                FileSystemEntity entity = snapshot[index];
                return Container(
                  clipBehavior: Clip.hardEdge,
                  height: 80,
                  margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 15)],
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ListTile(
                    leading: Icon(viewModel.getIcon(entity)),
                    title: Text(
                      FileManager.isFile(entity) ? viewModel.getFilename(entity) : FileManager.basename(entity),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: subtitle(entity),
                    onLongPress: () {
                      //TODO: implements some things about action longpress

                      if (FileManager.isFile(entity)) {
                      } else {}
                    },
                    onTap: () async {
                      if (FileManager.isDirectory(entity)) {
                        // open the folder
                        viewModel.controller.openDirectory(entity);

                        // delete a folder
                        // await entity.delete(recursive: true);

                        // rename a folder
                        // await entity.rename("newPath");

                        // Check weather folder exists
                        // entity.exists();

                        // get date of file
                        // DateTime date = (await entity.stat()).modified;
                      } else {
                        var fileSize = (await entity.stat()).size;
                        var lastModified = (await entity.stat()).modified;
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('File Information'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("File name: ${viewModel.getFilename(entity)}"),
                                    Text("File size: ${FileManager.formatBytes(fileSize)}"),
                                    Text("Last modified: ${lastModified.toString()}"),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Center(
                                      child: ElevatedButton(
                                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black)),
                                          onPressed: () {
                                            Get.back();
                                            // debugPrint(entity.path);
                                            OpenFile.open(entity.path);
                                          },
                                          child: const Text(
                                            'Open in File Explorer',
                                            style: TextStyle(color: Colors.white),
                                          )),
                                    )
                                  ],
                                ),
                              );
                            });
                        // delete a file
                        // await entity.delete();

                        // rename a file
                        // await entity.rename("newPath");

                        // Check weather file exists
                        // entity.exists();

                        // get date of file
                        // DateTime date = (await entity.stat()).modified;

                        // get the size of the file
                        // int size = (await entity.stat()).size;
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget subtitle(FileSystemEntity entity) {
    return FutureBuilder<FileStat>(
      future: entity.stat(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (entity is File) {
            int size = snapshot.data!.size;

            return Text(
              FileManager.formatBytes(size),
            );
          }
          return Text(
            "${snapshot.data!.modified}".substring(0, 10),
          );
        } else {
          return const Text("");
        }
      },
    );
  }

  selectStorage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: FutureBuilder<List<Directory>>(
          future: FileManager.getStorageList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<FileSystemEntity> storageList = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: storageList
                        .map((e) => ListTile(
                              title: Text(
                                FileManager.basename(e),
                              ),
                              onTap: () {
                                viewModel.controller.openDirectory(e);
                                Navigator.pop(context);
                              },
                            ))
                        .toList()),
              );
            }
            return const Dialog(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  sort(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                  title: const Text("Name"),
                  onTap: () {
                    viewModel.controller.sortBy(SortBy.name);
                    Navigator.pop(context);
                  }),
              ListTile(
                  title: const Text("Size"),
                  onTap: () {
                    viewModel.controller.sortBy(SortBy.size);
                    Navigator.pop(context);
                  }),
              ListTile(
                  title: const Text("Date"),
                  onTap: () {
                    viewModel.controller.sortBy(SortBy.date);
                    Navigator.pop(context);
                  }),
              ListTile(
                  title: const Text("Type"),
                  onTap: () {
                    viewModel.controller.sortBy(SortBy.type);
                    Navigator.pop(context);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  createFolder(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController folderName = TextEditingController();
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: TextField(
                    controller: folderName,
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                      foregroundColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: () async {
                    try {
                      // Create Folder
                      await FileManager.createFolder(viewModel.controller.getCurrentPath, folderName.text);
                      // Open Created Folder
                      viewModel.controller.setCurrentPath = "${viewModel.controller.getCurrentPath}/${folderName.text}";
                    } catch (e) {}

                    Get.back();
                  },
                  child: const Text('Create Folder'),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
