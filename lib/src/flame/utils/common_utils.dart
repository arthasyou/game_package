import 'package:flame/components.dart';
import 'package:flame/flame.dart';

Future<Sprite> loadSprite(String path) async {
  return await Flame.images.load(path).then((image) => Sprite(image));
}
