@echo off
echo Copying icon to Android drawable directories...
copy "assets\images\icon.png" "android\app\src\main\res\drawable\launcher_icon.png"
copy "assets\images\icon.png" "android\app\src\main\res\mipmap-mdpi\ic_launcher.png"
copy "assets\images\icon.png" "android\app\src\main\res\mipmap-hdpi\ic_launcher.png"
copy "assets\images\icon.png" "android\app\src\main\res\mipmap-xhdpi\ic_launcher.png"
copy "assets\images\icon.png" "android\app\src\main\res\mipmap-xxhdpi\ic_launcher.png"
copy "assets\images\icon.png" "android\app\src\main\res\mipmap-xxxhdpi\ic_launcher.png"
copy "assets\images\icon.png" "android\app\src\main\res\drawable-v21\launcher_icon.png"
echo Icon files copied successfully!
echo Now running flutter_launcher_icons to generate proper icons...
flutter pub run flutter_launcher_icons
echo Done!
pause
