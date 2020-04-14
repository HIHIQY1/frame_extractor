import 'dart:io';
import 'package:image/image.dart';
import 'package:path/path.dart' as path;

void main(List<String> args) async {
  int startingTime = DateTime.now().millisecondsSinceEpoch;
  print("----------Qy's frame extractor----------");
  print(args.length.toString() + " args detected.");
  if (args.length > 0) {
    List<File> files = [];
    for (int i = 0; i < args.length; i++) {
      File w = File(args[i]);
      if (w.existsSync()) {
        print("File " + (i + 1).toString() + " exists.");
        files.add(w);
      } else {
        print("File " + (i + 1).toString() + " does not exist. Ignoring.");
      }
    }

    print("Total files to process: " + files.length.toString());

    if (files.length > 0) {
      for (int i = 0; i < files.length; i++) {
        print("Starting processing of file " + (i + 1).toString() + "...");
        try {
          await processImage(files[i]);
        } catch (err) {
          print("There was an error while processing file " +
              (i + 1).toString() +
              " (path: \"" +
              files[i].path +
              "\"). Is the file formatted correctly?");
          enterFileMessage();
        }
      }
    } else {
      enterFileMessage();
    }
  } else {
    enterFileMessage();
  }
  print("\nTask completed. Took " +
      (DateTime.now().millisecondsSinceEpoch - startingTime).toString() +
      " ms.");
  print("Press enter to close this window.");
  stdin.readLineSync();
}

void enterFileMessage() {
  print(
      "\n>>> Drag an APNG or GIF over this executable file in your file explorer, and I'll convert every frame to individual PNGs.\n");
}

void processImage(File theFile) async {
  List<int> imgBytes = theFile.readAsBytesSync();
  Decoder decodering = findDecoderForData(imgBytes);
  Animation anim = decodering.decodeAnimation(imgBytes);
  Directory finalDirectory = Directory(path.joinAll(
      [path.dirname(theFile.path), path.basename(theFile.path) + "_frames"]));
  if (anim.frames.length > 1) {
    print("This file is an animation (it has " +
        anim.frames.length.toString() +
        " frames). Starting extraction...");

    if (!finalDirectory.existsSync()) {
      finalDirectory.createSync();

      for (int i = 0; i < anim.frames.length; i++) {
        int convertStart = DateTime.now().millisecondsSinceEpoch;

        Encoder png = PngEncoder();
        List<int> pngBytes = png.encodeImage(anim.frames[i]);

        print("Converted frame " +
            (i + 1).toString() +
            "/" +
            anim.frames.length.toString() +
            " (" +
            anim.frames[i].width.toString() +
            "x" +
            anim.frames[i].height.toString() +
            ") to png. Writing to disk...");

        File(
          path.joinAll(
            [
              path.dirname(theFile.path),
              path.basename(theFile.path) + "_frames",
              "frame" + i.toString() + ".png",
            ],
          ),
        ).writeAsBytesSync(pngBytes);

        print("Written frame " +
            (i + 1).toString() +
            "/" +
            anim.frames.length.toString() +
            " to disk. (convert+write took " +
            (DateTime.now().millisecondsSinceEpoch - convertStart).toString() +
            " ms)");
      }
    } else {
      print(
          "This file seems to already be processed. If you wish to reconvert it, please delete the following directory: \"" +
              finalDirectory.path +
              "\"");
    }
  } else {
    print(
        "This file is not an animation (it only has 1 frame). Skipping extraction.");
  }
}
