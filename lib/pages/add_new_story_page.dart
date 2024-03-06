import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:story_app/layouts/custom_image_button.dart';
import 'package:story_app/providers/stories_provider.dart';
import 'package:story_app/utils/state_activity.dart';
import '../layouts/custom_pop_menu.dart';
import '../utils/common.dart';
import '../utils/platform_widget.dart';

class AddNewStoryPage extends StatefulWidget {
  const AddNewStoryPage({super.key});

  @override
  _AddNewStoryPageState createState() => _AddNewStoryPageState();
}

class _AddNewStoryPageState extends State<AddNewStoryPage> {
  final TextEditingController _descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoadingLocation = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  final loading = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.red : Colors.green,
        ),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildList() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildImagePreview(),
                  _buildImageButtons(),
                  _buildDescriptionTextField(),
                  const SizedBox(height: 12),
                  Consumer<StoriesProvider>(
                      builder: (context, storiesProvider, child) {
                    return storiesProvider.isLoading
                        ? loading
                        : Container(
                            padding: const EdgeInsets.only(top: 3, left: 3),
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  _onUpload();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: Colors.blueAccent,
                              ),
                              child: Text(
                                AppLocalizations.of(context)?.upload ??
                                    'Upload',
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ));
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildList(),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        transitionBetweenRoutes: false,
      ),
      child: _buildList(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      title: Text(
        AppLocalizations.of(context)!.addNewStory,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.blueAccent,
      actions: const [
        CustomPopMenu(),
      ],
    );
  }

  Widget _buildImagePreview() {
    final imagePath = context.watch<StoriesProvider>().imagePath;

    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: imagePath == null
          ? const Center(
              child: Icon(
                Icons.image,
                size: 80,
                color: Colors.grey,
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: kIsWeb
                  ? Image.network(
                      imagePath.toString(),
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(imagePath.toString()),
                      fit: BoxFit.cover,
                    ),
            ),
    );
  }

  Widget _buildImageButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageButton(
            label: AppLocalizations.of(context)!.gallery,
            onPressed: _onGalleryView,
            colorButton: Colors.purple,
            icon: const Icon(Icons.image_rounded, color: Colors.white),
          ),
          const SizedBox(width: 16),
          CustomImageButton(
            label: AppLocalizations.of(context)!.camera,
            onPressed: _onCameraView,
            colorButton: Colors.deepPurple,
            icon: const Icon(Icons.camera, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionTextField() {
    return TextField(
      controller: _descriptionController,
      keyboardType: TextInputType.multiline,
      maxLines: 6,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.hintDescription,
        labelText: AppLocalizations.of(context)!.description,
        border: const OutlineInputBorder(),
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.all(16.0),
      ),
    );
  }

  _onUpload() async {
    final storiesProvider = context.read<StoriesProvider>();
    await storiesProvider.addNewStory(
      description: _descriptionController.text.isNotEmpty
          ? _descriptionController.text
          : 'No Description',
    );

    if (storiesProvider.state == StateActivity.hasData) {
      Fluttertoast.showToast(
          msg: storiesProvider.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      storiesProvider.clear();
      context.pop();
      setState(() {
        context.read<StoriesProvider>().getAllStories();
      });
    } else {
      Fluttertoast.showToast(
          msg: storiesProvider.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      storiesProvider.clear();
    }
  }

  _onGalleryView() async {
    final provider = context.read<StoriesProvider>();

    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;

    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  _onCameraView() async {
    final provider = context.read<StoriesProvider>();

    final ImagePicker picker = ImagePicker();

    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotMobile = !(isAndroid || isiOS);
    if (isNotMobile) return;

    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }
}
