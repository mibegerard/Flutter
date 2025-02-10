import 'dart:io';

void main() async {
  final envFile = File('.env');

  if (await envFile.exists()) {
    print("✅ SUCCESS: .env file found!");
  } else {
    print("❌ ERROR: .env file NOT found!");
  }
}
