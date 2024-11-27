import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Cloudinary
{


 static Future<void>uploadProfileImage(String filePath, String userId) async {
    final cloudName = 'dcgmlqblo';
    final apiKey = '384134893529286';
    final apiSecret = '0uneZBOUxAS-qqgrXvDPbx_7y_E';
    final uploadUrl = 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

    final file = File(filePath);

    // Create a unique folder and public ID
    final publicId = 'users/$userId/profile_image';

    // Create the request
    final request = http.MultipartRequest('POST', Uri.parse(uploadUrl))
      ..fields['upload_preset'] = 'mzqoqs9v' // Optional, if using unsigned uploads
      ..fields['public_id'] = publicId
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    // Add Basic Authentication if needed
    final headers = {
      'Authorization': 'Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}'
    };
    request.headers.addAll(headers);

    final response = await request.send();
    while(response.statusCode != 200)
      {
        CircularProgressIndicator();
      }
    if (response.statusCode == 200) {
      print('Image uploaded successfully');
    } else {
      print('Failed to upload image: ${response.statusCode}');
    }
  }




  static Future<void> pickAndUploadImage(String userId) async {
   final ImagePicker picker = ImagePicker();

   // Pick an image
   final XFile? image = await picker.pickImage(source: ImageSource.gallery);

   if (image != null) {
     // Get the file path
     String filePath = image.path;

     // Call the function to upload the image
     await uploadProfileImage(filePath, userId);
   } else {
     print('No image selected');
   }
 }

 static String getProfileImageUrl(String userId) {
   final cloudName = 'dcgmlqblo'; // Replace with your Cloudinary cloud name
   return 'https://res.cloudinary.com/$cloudName/image/upload/users/$userId/profile_image';
 }

}
