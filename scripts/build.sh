rm -rf build
mkdir build
dart compile exe bin/ifba_bot.dart -o build/ifba_bot
cp -r image_creator build/image_creator
