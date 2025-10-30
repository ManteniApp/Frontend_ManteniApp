import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend_manteniapp/core/services/profile_image_service.dart';

class ProfileAvatar extends StatefulWidget {
  final double size;
  final VoidCallback? onTap;
  final bool editable;

  const ProfileAvatar({
    Key? key,
    this.size = 100,
    this.onTap,
    this.editable = false,
  }) : super(key: key);

  @override
  ProfileAvatarState createState() => ProfileAvatarState(); // Cambiado a pública
}

// Cambiar a clase pública (sin _)
class ProfileAvatarState extends State<ProfileAvatar> {
  String? _currentImagePath;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final imagePath = await ProfileImageService.getProfileImage();
    if (mounted) {
      setState(() {
        _currentImagePath = imagePath;
      });
    }
  }

  Widget _buildImage() {
    if (_currentImagePath == null || _currentImagePath!.isEmpty) {
      return CircleAvatar(
        radius: widget.size / 2,
        backgroundColor: Colors.grey[300],
        child: Icon(
          Icons.person,
          size: widget.size * 0.6,
          color: Colors.grey[600],
        ),
      );
    }

    if (_currentImagePath!.startsWith('assets/')) {
      return CircleAvatar(
        radius: widget.size / 2,
        backgroundImage: AssetImage(_currentImagePath!),
      );
    } else {
      return CircleAvatar(
        radius: widget.size / 2,
        backgroundImage: FileImage(File(_currentImagePath!)),
      );
    }
  }

  // Método público para refrescar
  void refreshImage() {
    _loadProfileImage();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        children: [
          _buildImage(),
          if (widget.editable)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E88E5),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
        ],
      ),
    );
  }
}