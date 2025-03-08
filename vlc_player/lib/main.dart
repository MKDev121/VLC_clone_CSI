import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? filePath = "No file selected";
  VideoPlayerController? _videoController;

  // Function to pick a video file
  Future<void> pickingFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video, // Restrict to video files
    );
    if (result != null) {
      setState(() {
        filePath = result.files.single.path;
      });

      // Initialize VideoPlayerController with the selected file
      _videoController?.dispose(); // Dispose previous controller if any
      _videoController = VideoPlayerController.file(File(filePath!))
        ..initialize().then((_) {
          setState(() {
            _videoController!.play(); // Autoplay the video after selection
          });
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose(); // Clean up the video player controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VLC Media Player Clone'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display video or a placeholder message
            _videoController != null && _videoController!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  )
                : Text(filePath ?? "No file selected"), // Placeholder message
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(pickFileCallback: pickingFile),
    );
  }
}

class BottomBar extends StatelessWidget {
  final VoidCallback pickFileCallback; // Callback to trigger file picking

  const BottomBar({super.key, required this.pickFileCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 196, 196, 196),
      width: double.infinity,
      height: 100.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: pickFileCallback, // Use the callback here
            label: const Icon(Icons.upload),
          ),
          ElevatedButton.icon(
            onPressed: () {
              print("Rewind");
            },
            label: const Icon(Icons.fast_rewind),
          ),
          ElevatedButton.icon(
            onPressed: () {
              print("Play");
            },
            label: const Icon(Icons.play_arrow),
          ),
          ElevatedButton.icon(
            onPressed: () {
              print("Forward");
            },
            label: const Icon(Icons.fast_forward),
          ),
          ElevatedButton.icon(
            onPressed: () {
              print("Volume");
            },
            label: const Icon(Icons.volume_up),
            
          ),
        ],
      ),
    );
  }
}
// class VideoPlayerWidget extends StatefulWidget {
//   final String videoPath; // Path to the video file or URL

//   const VideoPlayerWidget({super.key, required this.videoPath});

//   @override
//   _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
// }

// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize the video controller
//     _controller = VideoPlayerController.file(File(widget.videoPath))
//       ..initialize().then((_) {
//         _controller.play(); // Start playing the video automatically
//         _controller.setLooping(true); // Loop the video
//         setState(() {}); // Refresh UI once initialized
//       });
//   }

//   @override
//   void dispose() {
//     _controller.dispose(); // Clean up the controller
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _controller.value.isInitialized
//         ? AspectRatio(
//             aspectRatio: _controller.value.aspectRatio, // Maintain video's aspect ratio
//             child: VideoPlayer(_controller),
//           )
//         : Center(
//             child: CircularProgressIndicator(), // Show a spinner until the video loads
//           );
//   }
// }
