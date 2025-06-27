import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:palm_code_challenge/presentation/shared/widgets/safe_cached_network_image.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PhotoViewer extends StatefulWidget {
  final String imageUrl;
  final String heroTag;

  const PhotoViewer({super.key, required this.imageUrl, required this.heroTag});

  @override
  State<PhotoViewer> createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<PhotoViewer>
    with TickerProviderStateMixin {
  late TransformationController _transformationController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onInteractionEnd(ScaleEndDetails details) {
    // Reset zoom if it's too small
    if (_transformationController.value.getMaxScaleOnAxis() < 1.0) {
      _animateResetTransformation();
    }
  }

  void _animateResetTransformation() {
    final animation = Tween<Matrix4>(
      begin: _transformationController.value,
      end: Matrix4.identity(),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    animation.addListener(() {
      _transformationController.value = animation.value;
    });

    _animationController.forward(from: 0);
  }

  void _onDoubleTap() {
    const double scale = 2.0;
    final Matrix4 matrix = _transformationController.value.clone();

    if (matrix.getMaxScaleOnAxis() < 1.5) {
      // Zoom in
      matrix.scale(scale);
    } else {
      // Zoom out
      matrix.setIdentity();
    }

    final animation = Tween<Matrix4>(
      begin: _transformationController.value,
      end: matrix,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    animation.addListener(() {
      _transformationController.value = animation.value;
    });

    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Photo Viewer',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Center(
        child: Hero(
          tag: widget.heroTag,
          child: InteractiveViewer(
            transformationController: _transformationController,
            onInteractionEnd: _onInteractionEnd,
            minScale: 0.5,
            maxScale: 4.0,
            child: GestureDetector(
              onDoubleTap: _onDoubleTap,
              child: SafeCachedNetworkImage(
                imageUrl: widget.imageUrl,
                fit: BoxFit.contain,
                width: double.infinity,
                placeholder:
                    (context, url) => Skeletonizer(
                      enabled: true,
                      child: Container(
                        width: 200.w,
                        height: 300.h,
                        color: Colors.grey[800],
                        child: const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                errorWidget: Container(
                  color: Colors.grey[800],
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image, size: 64, color: Colors.white54),
                      Gap(16),
                      Text(
                        'Failed to load image',
                        style: TextStyle(color: Colors.white54, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Function to show photo viewer as a modal
void showPhotoViewer({
  required BuildContext context,
  required String imageUrl,
  required String heroTag,
}) {
  Navigator.of(context).push(
    PageRouteBuilder<void>(
      opaque: false,
      barrierColor: Colors.black,
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: PhotoViewer(imageUrl: imageUrl, heroTag: heroTag),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 300),
    ),
  );
}
