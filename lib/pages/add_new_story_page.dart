import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:story_app/providers/custom_image_provider.dart';
import 'package:story_app/providers/preference_provider.dart';
import 'package:story_app/providers/stories_provider.dart';

import '../layouts/custom_pop_menu.dart';
import '../layouts/loading_animation.dart';
import '../utils/snack_message.dart';
import '../utils/state_activity.dart';

class AddNewStoryPage extends StatefulWidget {
  const AddNewStoryPage({super.key});

  @override
  State<AddNewStoryPage> createState() => _AddNewStoryPageState();
}

class _AddNewStoryPageState extends State<AddNewStoryPage> {
  final TextEditingController descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoadingLocation = false;

  @override
  void dispose() {
    descriptionController.dispose();
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
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Add New Story',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        actions: const [
          CustomPopMenu(),
        ],
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImagePreview(),
              _buildImageButtons(),
              _buildDescriptionTextField(),
              const SizedBox(height: 12),
              Consumer<StoriesProvider>(
                  builder: (context, storiesProvider, child) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (storiesProvider.message != "") {
                        if (storiesProvider.addNewStoryResponse.error) {
                          showMessage(
                              message: storiesProvider.message,
                              context: context);
                          storiesProvider.clear();
                        } else {
                          showMessage(
                              message: storiesProvider.message,
                              context: context);
                          storiesProvider.clear();
                          context.go('/');
                        }
                      }
                    });
                return storiesProvider.isLoading
                    ? loading
                    : _buildUploadButton();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    final imagePath = context.watch<CustomImageProvider>().imagePath;

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
          _buildElevatedButton(
              "Gallery",
              _onGalleryView,
              Colors.purple,
              const Icon(
                Icons.image_rounded,
                color: Colors.white,
              )),
          const SizedBox(width: 16),
          _buildElevatedButton("Camera", _onCameraView, Colors.deepPurple,
              const Icon(Icons.camera, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildElevatedButton(
      String label, VoidCallback onPressed, Color colorButton, Icon icon) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        backgroundColor: colorButton,
      ),
      icon: icon,
      label: Text(
        label,
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }

  Widget _buildDescriptionTextField() {
    return TextField(
      controller: descriptionController,
      keyboardType: TextInputType.multiline,
      maxLines: 6,
      decoration: const InputDecoration(
        hintText: 'Enter your story description...',
        labelText: 'Description',
        border: OutlineInputBorder(),
        hintStyle: TextStyle(color: Colors.grey),
        contentPadding: EdgeInsets.all(16.0),
      ),
    );
  }

  Widget _buildUploadButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: ElevatedButton(
        onPressed: () {
          _onUpload();
        },
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.blueAccent,
        ),
        child: const Text(
          "Upload",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  _onUpload() async {
    final storiesProvider = context.read<StoriesProvider>();

    final customImageProvider = context.read<CustomImageProvider>();
    final imagePath = customImageProvider.imagePath;
    final imageFile = customImageProvider.imageFile;

    if (imagePath == null || imageFile == null) return;

    final fileName = imageFile.name;
    final bytes = await imageFile.readAsBytes();
    final newBytes = await customImageProvider.compressImage(bytes);

    await storiesProvider.addNewStory(
      bytes: newBytes,
      description: descriptionController.text.isNotEmpty
          ? descriptionController.text
          : 'No Description',
      fileName: fileName,
    );

    // if (!storiesProvider.addNewStoryResponse.error) {
    //   // customImageProvider.setImageFile(null);
    //   // customImageProvider.setImagePath(null);
    //   // if (!context.mounted) return;
    //   showMessage(message: storiesProvider.message, context: context);
    //   context.pop(true);
    // } else {
    //   showMessage(message: storiesProvider.message, context: context);
    // }
  }

  _onGalleryView() async {
    final provider = context.read<CustomImageProvider>();

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
    final provider = context.read<CustomImageProvider>();

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
