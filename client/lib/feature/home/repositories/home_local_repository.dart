import 'package:client/feature/home/models/song_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_local_repository.g.dart';

@riverpod
HomeLocalRepository homeLocalRepository(Ref ref) {
  final Box box = Hive.box("hi");
  return HomeLocalRepository(box);
}

class HomeLocalRepository {
  final Box box;
  HomeLocalRepository(this.box);

  void uploadLocalSong(SongModel song) {
    box.put(song.id, song.toJson());
  }

  List<SongModel> loadSongs() {
    return box.values.map((e) => SongModel.fromJson(e)).toList();
  }
}
