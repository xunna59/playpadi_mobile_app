import 'dart:convert';
import 'dart:io';
import 'package:PlayPadi/src/services/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../controllers/user_Profile_controller.dart';
import '../../../../core/activity_overlay.dart';
import '../../../../core/constants.dart';
import '../../../../models/user_profile_model.dart';
import '../../../../routes/app_routes.dart';
import 'package:mime/mime.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();

  final _emailCtrl = TextEditingController(text: 'tunde@example.com');
  final _phoneCtrl = TextEditingController(text: '(+234) 08033021547');
  String _gender = 'Male';
  DateTime? _dob = DateTime(2025, 2, 4);
  final _descCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();

  XFile? _pickedImage;
  final _picker = ImagePicker();

  UserProfile? _profile;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await UserProfileController().fetchUserProfile();

      if (!mounted) return;

      setState(() {
        _profile = profile;
        _loading = false;
        _firstNameCtrl.text = profile?.firstName ?? '';
        _lastNameCtrl.text = profile?.lastName ?? '';

        _emailCtrl.text = profile?.email ?? '';
        _phoneCtrl.text = profile?.phone ?? '';
        if (profile?.gender != null) {
          final gender = profile!.gender!.toLowerCase();
          final validGenders = ['male', 'female', 'prefer not to say'];
          _gender =
              validGenders.contains(gender)
                  ? gender[0].toUpperCase() + gender.substring(1)
                  : 'prefer not to say';
        }

        _descCtrl.text = profile?.bio ?? '';

        if (profile?.dob != null) {
          _dob = profile!.dob!;
        }
      });
    } on NetworkErrorException catch (_) {
      _showSnackBar('No Internet connection. Please check your network.');
    } on HttpException catch (e) {
      _showSnackBar('Server error: ${e.message}');
    } on FormatException catch (_) {
      _showSnackBar('Bad response format.');
    } catch (e) {
      _showSnackBar('Something went wrong: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  final controller = UserProfileController();

  void _showSnackBar(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message, style: TextStyle(color: Colors.white)),
          ),
        );
      }
    });
  }

  // Future<void> _pickImage() async {
  //   final img = await _picker.pickImage(source: ImageSource.gallery);
  //   if (img != null) {
  //     setState(() => _pickedImage = img);
  //   }
  // }

  Future<void> _pickDob() async {
    final today = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _dob ?? today,
      firstDate: DateTime(1900),
      lastDate: today,
    );
    if (date != null) setState(() => _dob = date);
  }

  // Future<void> _pickImage() async {
  //   final img = await _picker.pickImage(source: ImageSource.gallery);
  //   if (img != null) {
  //     setState(() => _pickedImage = img);

  //     try {
  //       // Read and convert image to base64
  //       final bytes = await File(img.path).readAsBytes();

  //       final extension = img.path.split('.').last.toLowerCase();
  //       final mimeType =
  //           extension == 'png'
  //               ? 'image/png'
  //               : extension == 'jpg' || extension == 'jpeg'
  //               ? 'image/jpeg'
  //               : 'application/octet-stream';

  //       final base64Image = 'data:$mimeType;base64,' + base64Encode(bytes);

  //       // Upload image immediately
  //       await controller.updateDisplayPicture({'display_picture': base64Image});

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Profile picture updated successfully'),
  //           backgroundColor: Colors.green,
  //         ),
  //       );
  //     } catch (e, stacktrace) {
  //       print(stacktrace);

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Failed to update image: ${stacktrace.toString()}'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   }
  // }

  Future<void> _pickImage() async {
    final img = await _picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() => _pickedImage = img);

      try {
        final file = File(img.path);
        await controller.updateDisplayPicture(file);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e, stacktrace) {
        print(stacktrace);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _save() async {
    if (_formKey.currentState?.validate() ?? false) {
      final updates = {
        'first_name': _firstNameCtrl.text,
        'last_name': _lastNameCtrl.text,
        'dob': _dob != null ? DateFormat('yyyy-MM-dd').format(_dob!) : null,
        'gender': _gender,
        'bio': _descCtrl.text,
      };

      LoadingOverlay.show(context);
      try {
        final updatedProfile = await controller.updateUserProfile(updates);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        LoadingOverlay.hide();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Edit Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text(
              'Save',
              style: TextStyle(color: Color.fromRGBO(199, 3, 125, 1)),
            ),
          ),
        ],
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                _pickedImage != null
                                    ? FileImage(File(_pickedImage!.path))
                                    : (_profile?.displayPicture != null
                                        ? NetworkImage(
                                          '${display_picture}${_profile!.displayPicture!}',
                                        )
                                        : const AssetImage(
                                              'assets/images/default_avatar.png',
                                            )
                                            as ImageProvider),
                          ),

                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: _pickImage,
                            child: const Text(
                              'Change profile picture',
                              style: TextStyle(
                                color: Color.fromRGBO(199, 3, 125, 1),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _firstNameCtrl,
                      decoration: inputDecoration.copyWith(
                        labelText: 'First name',
                      ),
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _lastNameCtrl,
                      decoration: inputDecoration.copyWith(
                        labelText: 'Last name',
                      ),
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailCtrl,
                      decoration: inputDecoration.copyWith(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator:
                          (v) =>
                              v!.contains('@') ? null : 'Enter a valid email',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneCtrl,
                      decoration: inputDecoration.copyWith(
                        labelText: 'Phone number',
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _gender,
                      decoration: inputDecoration.copyWith(labelText: 'Gender'),
                      dropdownColor: colorScheme.tertiary,
                      items:
                          ['Male', 'Female', 'Prefer Sot To Say']
                              .map(
                                (g) =>
                                    DropdownMenuItem(value: g, child: Text(g)),
                              )
                              .toList(),
                      onChanged: (v) => setState(() => _gender = v!),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _pickDob,
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: inputDecoration.copyWith(
                            labelText: 'Date of birth',
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                          controller: TextEditingController(
                            text:
                                _dob == null
                                    ? ''
                                    : DateFormat('MM/dd/yyyy').format(_dob!),
                          ),
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descCtrl,
                      decoration: inputDecoration.copyWith(
                        labelText: 'Description',
                      ),
                      maxLines: 3,
                    ),
                    // const SizedBox(height: 16),
                    // TextFormField(
                    //   controller: _locationCtrl,
                    //   decoration: inputDecoration.copyWith(
                    //     labelText: 'Where do you play?',
                    //   ),
                    //   textInputAction: TextInputAction.done,
                    // ),
                    const SizedBox(height: 32),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Edit your preferences'),
                      subtitle: const Text(
                        'Best hand, court side, match type, …',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.playerPrefernces,
                        );
                      },
                    ),
                  ],
                ),
              ),
    );
  }
}
