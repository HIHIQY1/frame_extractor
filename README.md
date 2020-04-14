# frame_extractor
Extracts frames from APNGs or GIFs


## Usage
1. [Download](https://github.com/HIHIQY1/frame_extractor/releases/download/1/frame_extractor.exe) or [build](#building) the executable
2. Find some APNG of GIF file on your device.
3. Drag the file(s) over the executable.
4. ???
5. Profit! The frames are exported as PNG to a folder `{FILE_NAME}_frames`


## <a name="building">Building</a>
#### Prerequisites:
- [Dart SDK](https://dart.dev/get-dart)
- [dart2native](https://dart.dev/tools/dart2native)
- [pub](https://dart.dev/tools/pub)

#### Steps
1. Clone this repository
2. `cd` into the locally cloned repository
3. Run `pub get`
4. Run `dart2native main.dart -o ./frame_extractor`
