import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/image_upload_service.dart';

class ImageUploadWidget extends StatefulWidget {
  final List<String> initialImages;
  final Function(List<String>) onImagesChanged;
  final String folder;
  final bool allowMultiple;
  final String? placeholder;
  final double? height;
  final double? width;

  const ImageUploadWidget({
    super.key,
    required this.initialImages,
    required this.onImagesChanged,
    required this.folder,
    this.allowMultiple = true,
    this.placeholder,
    this.height,
    this.width,
  });

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  List<String> _images = [];
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _images = List.from(widget.initialImages);
  }

  Future<void> _addImages() async {
    setState(() {
      _isUploading = true;
    });

    try {
      if (widget.allowMultiple) {
        final newImages = await ImageUploadService.pickAndUploadMultipleImages(
          context,
          folder: widget.folder,
        );
        setState(() {
          _images.addAll(newImages);
        });
      } else {
        final newImage = await ImageUploadService.pickAndUploadSingleImage(
          context,
          folder: widget.folder,
        );
        if (newImage != null) {
          setState(() {
            _images = [newImage];
          });
        }
      }
      widget.onImagesChanged(_images);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في رفع الصورة: $e')),
        );
      }
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
    widget.onImagesChanged(_images);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عرض الصور الموجودة
        if (_images.isNotEmpty)
          SizedBox(
            height: widget.height ?? 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: _images[index],
                          width: widget.width ?? 100,
                          height: widget.height ?? 120,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: widget.width ?? 100,
                            height: widget.height ?? 120,
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) {
                            return Container(
                              width: widget.width ?? 100,
                              height: widget.height ?? 120,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        
        const SizedBox(height: 8),
        
        // زر إضافة صور
        GestureDetector(
          onTap: _isUploading ? null : _addImages,
          child: Container(
            width: widget.width ?? 100,
            height: widget.height ?? 120,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey[400]!,
                style: BorderStyle.solid,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[100],
            ),
            child: _isUploading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        size: 40,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.placeholder ?? 'إضافة صورة',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}