import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:story_app/providers/custom_image_provider.dart';
import 'package:story_app/providers/preference_provider.dart';
import 'package:story_app/providers/stories_provider.dart';
import 'package:story_app/utils/location_handler.dart';
import 'package:story_app/utils/placemark_widget.dart';

class AddNewStoryPage extends StatefulWidget {
  const AddNewStoryPage({super.key});

  @override
  State<AddNewStoryPage> createState() => _AddNewStoryPageState();
}

class _AddNewStoryPageState extends State<AddNewStoryPage> {
  final TextEditingController descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final LocationHandler _locationHandler = LocationHandler();

  LatLng inputLang = const LatLng(0.0, 0.0);
  geo.Placemark? placemark;
  bool isLoadingLocation = false;

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Story'),
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
              _buildInputLocationButton(),
              const SizedBox(height: 12),
              if (placemark == null)
                const SizedBox()
              else
                PlacemarkWidget(placemark: placemark!),
              _buildUploadButton(),
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
          _buildElevatedButton("Gallery", _onGalleryView),
          const SizedBox(width: 16),
          _buildElevatedButton("Camera", _onCameraView),
        ],
      ),
    );
  }

  Widget _buildElevatedButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildDescriptionTextField() {
    return TextField(
      controller: descriptionController,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: const InputDecoration(
        hintText: 'Enter your story description...',
        labelText: 'Description',
        border: OutlineInputBorder(),
        hintStyle: TextStyle(color: Colors.grey),
        contentPadding: EdgeInsets.all(16.0),
      ),
    );
  }

  Widget _buildInputLocationButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: ElevatedButton(
        onPressed: _onMyLocationButtonPress,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: isLoadingLocation
            ? const SizedBox(
                width: 24.0,
                height: 24.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                "Input Location",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildUploadButton() {
    final isUploading = context.watch<StoriesProvider>().isLoading;

    return Consumer<PreferenceProvider>(builder: (context, provider, child) {
      return Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: ElevatedButton(
          onPressed: isUploading ? null : _onUpload(provider.authToken),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: isUploading
              ? const SizedBox(
            width: 24.0,
            height: 24.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
              : const Text(
            "Upload",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
    });
  }

  void _onMyLocationButtonPress() async {
    setState(() {
      isLoadingLocation = true;
    });

    try {
      final LatLng? latLng = await _locationHandler.getCurrentLocation();

      if (latLng != null) {
        final geo.Placemark? place = await _locationHandler.getPlacemark(
            latLng.latitude, latLng.longitude);

        setState(() {
          inputLang = latLng;
          placemark = place;
        });
      }
    } catch (e) {
      log("Error getting location: $e");

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error getting location!"),
        ),
      );
      // Handle error if needed
    } finally {
      setState(() {
        isLoadingLocation = false;
      });
    }
  }

  _onUpload(String token) async {
    final ScaffoldMessengerState scaffoldMessengerState =
        ScaffoldMessenger.of(context);

    final uploadProvider = context.read<StoriesProvider>();

    final homeProvider = context.read<CustomImageProvider>();
    final imagePath = homeProvider.imagePath;
    final imageFile = homeProvider.imageFile;

    if (imagePath == null || imageFile == null) return;

    final fileName = imageFile.name;
    final bytes = await imageFile.readAsBytes();
    final newBytes = await homeProvider.compressImage(bytes);

    await uploadProvider.addNewStory(
      token: token,
      bytes: newBytes,
      description: descriptionController.text.isNotEmpty
          ? descriptionController.text
          : 'No Description',
      fileName: fileName,
      lat: inputLang.latitude,
      lon: inputLang.longitude,
    );

    if (!uploadProvider.addNewStoryResponse.error) {
      homeProvider.setImageFile(null);
      homeProvider.setImagePath(null);
      if (!context.mounted) return;
      context.pop(true);
    }

    scaffoldMessengerState.showSnackBar(
      SnackBar(content: Text(uploadProvider.message)),
    );
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
