import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'weather_selection_screen.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class PhotoCaptureScreen extends StatefulWidget {
  final String userName; // 사용자 이름
  final String selectedCharacter; // 선택된 캐릭터 ID
  
  const PhotoCaptureScreen({super.key, required this.userName, required this.selectedCharacter});

  @override
  State<PhotoCaptureScreen> createState() => _PhotoCaptureScreenState();
}

class _PhotoCaptureScreenState extends State<PhotoCaptureScreen> {
  File? _image; // 이미지를 담을 변수 선언
  final picker = ImagePicker(); // ImagePicker 초기화

  Future<File?> _processImage(File imageFile) async {
    try {
      // 이미지 읽기
      final bytes = await imageFile.readAsBytes();
      
      // 이미지 디코딩
      img.Image? image = img.decodeImage(bytes);
      if (image == null) return null;
      
      // JPEG로 인코딩 (색상 공간 정규화)
      final processedBytes = img.encodeJpg(image, quality: 85);
      
      // 새 파일로 저장
      final processedFile = File('${imageFile.path}_processed.jpg');
      await processedFile.writeAsBytes(processedBytes);
      
      return processedFile;
    } catch (e) {
      print('Image processing error: $e');
      return null;
    }
  }

  // getImage 함수 수정
  Future getImage(ImageSource imageSource) async {
    final image = await picker.pickImage(
      source: imageSource,
      imageQuality: 85,
    );
    if (image != null) {
      final processedImage = await _processImage(File(image.path));
      setState(() {
        _image = processedImage ?? File(image.path);
      });
    }
  }

  void _retakePhoto() {
    setState(() {
      _image = null;
    });
  }

  Future<void> _nextStep() async {
    if (_image != null) {
      try {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF87CEEB)),
              ),
            );
          },
        );

        // Upload image to storage
        final uploadResult = await _uploadImage(_image!);
        
        // Hide loading indicator
        Navigator.pop(context);

        if (uploadResult != null && uploadResult.containsKey('fileUrl')) {
          // Success - navigate to weather selection screen with actual fileUrl
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => WeatherSelectionScreen(
                imageUrl: uploadResult['fileUrl'],
                text: null,
                userName: widget.userName,
                selectedCharacter: widget.selectedCharacter,
              ),
            ),
          );
        } else {
          throw Exception('Invalid response format: missing fileUrl');
        }
      } catch (e) {
        // Hide loading indicator if still showing
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('이미지 업로드 실패: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('먼저 사진을 촬영해주세요.')),
      );
    }
  }

  Future<Map<String, dynamic>?> _uploadImage(File imageFile) async {
    try {
      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://ilgijjan.store/api/storage/upload'),
      );

      // Add image file to request
      request.files.add(
        await http.MultipartFile.fromPath(
          'file', // Field name for the file
          imageFile.path,
        ),
      );

      // Send request
      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        try {
          final jsonResponse = json.decode(responseData);
          return jsonResponse;
        } catch (jsonError) {
          throw Exception('Invalid JSON response: $responseData');
        }
      } else {
        throw Exception('Upload failed with status: ${response.statusCode}, response: $responseData');
      }
    } catch (e) {
      throw Exception('Upload error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFF87CEEB),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main Content Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image Display Area
                    _buildPhotoArea(),
                    
                    const SizedBox(height: 24),
                    
                    // Action Buttons - moved here to be right below the image
                    _image != null ? _buildActionButtons() : _buildCameraButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoArea() {
    return _image != null
        ? Container(
            width: double.infinity,
            height: 400,
            child: Image.file(File(_image!.path), fit: BoxFit.contain), // 가져온 이미지를 화면에 띄워주는 코드
          )
        : Container(
            width: double.infinity,
            height: 400,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'image',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // Retake Photo Button
        Expanded(
          child: ElevatedButton(
            onPressed: _retakePhoto,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEEEEEE),
              foregroundColor: const Color(0xAA424242),
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '다시 찍기',
              style: TextStyle(
                fontFamily: 'Katuri',
                fontSize: 24,
                // fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Next Button
        Expanded(
          child: ElevatedButton(
            onPressed: _nextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF91CCFF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '다음',
              style: TextStyle(
                fontFamily: 'Katuri',
                fontSize: 24,
                // fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCameraButtons() {
    return Row(
      children: [
        // Camera Button
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              getImage(ImageSource.camera); // getImage 함수를 호출해서 카메라로 찍은 사진 가져오기
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF91CCFF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '카메라',
              style: TextStyle(
                fontFamily: 'Katuri',
                fontSize: 24,
                // fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Gallery Button
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              getImage(ImageSource.gallery); // getImage 함수를 호출해서 갤러리에서 사진 가져오기
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF91CCFF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '갤러리',
              style: TextStyle(
                fontFamily: 'Katuri',
                fontSize:24,
                // fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
