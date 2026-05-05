import '../models/clue_model.dart';
import '../models/level_model.dart';

class GameData {
  static final List<LevelData> allLevels = [
    // MUDAH - LEVEL 1
    LevelData(
      levelNumber: 1,
      difficulty: Difficulty.mudah,
      gridSize: 8,
      clues: [
        Clue(id: 'h1', text: 'Pengajar di sekolah', answer: 'GURU', x: 0, y: 0, direction: ClueDirection.horizontal),
        Clue(id: 'h2', text: 'Mengasah kemampuan', answer: 'LATIH', x: 0, y: 2, direction: ClueDirection.horizontal),
        Clue(id: 'h3', text: 'Tempat makan di sekolah', answer: 'KANTIN', x: 1, y: 4, direction: ClueDirection.horizontal),
        Clue(id: 'v1', text: 'Sebutan kelulusan', answer: 'GELAR', x: 0, y: 0, direction: ClueDirection.vertical),
        Clue(id: 'v2', text: 'Tes kemampuan siswa', answer: 'UJIAN', x: 3, y: 0, direction: ClueDirection.vertical),
      ],
    ),
    // MUDAH - LEVEL 2
    LevelData(
      levelNumber: 2,
      difficulty: Difficulty.mudah,
      gridSize: 8,
      clues: [
        Clue(id: 'h1', text: 'Pengajar di universitas', answer: 'DOSEN', x: 0, y: 1, direction: ClueDirection.horizontal),
        Clue(id: 'h2', text: 'Tanda pengenal mahasiswa', answer: 'KARTU', x: 0, y: 3, direction: ClueDirection.horizontal),
        Clue(id: 'h3', text: 'Pengetahuan yang dipelajari', answer: 'ILMU', x: 2, y: 4, direction: ClueDirection.horizontal),
        Clue(id: 'v1', text: 'Pemimpin fakultas', answer: 'DEKAN', x: 0, y: 1, direction: ClueDirection.vertical),
        Clue(id: 'v2', text: 'Tugas akhir mahasiswa S1', answer: 'SKRIPSI', x: 2, y: 1, direction: ClueDirection.vertical),
      ],
    ),
    // MUDAH - LEVEL 3
    LevelData(
      levelNumber: 3,
      difficulty: Difficulty.mudah,
      gridSize: 8,
      clues: [
        Clue(id: 'h1', text: 'Orang yang belajar di sekolah', answer: 'SISWA', x: 0, y: 1, direction: ClueDirection.horizontal),
        Clue(id: 'h2', text: 'Penghapus dari bahan kenyal', answer: 'KARET', x: 0, y: 3, direction: ClueDirection.horizontal),
        Clue(id: 'h3', text: 'Alat untuk berpikir', answer: 'OTAK', x: 0, y: 4, direction: ClueDirection.horizontal),
        Clue(id: 'v1', text: 'Tempat menuntut ilmu', answer: 'SEKOLAH', x: 0, y: 1, direction: ClueDirection.vertical),
        Clue(id: 'v2', text: 'Pakaian resmi siswa', answer: 'SERAGAM', x: 2, y: 1, direction: ClueDirection.vertical),
      ],
    ),
    // MENENGAH - LEVEL 1
    LevelData(
      levelNumber: 1,
      difficulty: Difficulty.menengah,
      gridSize: 10,
      clues: [
        Clue(id: 'h1', text: 'Belajar di perguruan tinggi', answer: 'KULIAH', x: 0, y: 1, direction: ClueDirection.horizontal),
        Clue(id: 'h2', text: 'Karya tulis ilmiah mahasiswa', answer: 'SKRIPSI', x: 0, y: 5, direction: ClueDirection.horizontal),
        Clue(id: 'v1', text: 'Tempat kuliah', answer: 'KAMPUS', x: 0, y: 1, direction: ClueDirection.vertical),
        Clue(id: 'v2', text: 'Bantuan biaya pendidikan', answer: 'BEASISWA', x: 4, y: 1, direction: ClueDirection.vertical),
      ],
    ),
    // SULIT - LEVEL 1
    LevelData(
      levelNumber: 1,
      difficulty: Difficulty.sulit,
      gridSize: 12,
      clues: [
        Clue(id: 'h1', text: 'Ilmu tentang pendidikan dan pengajaran', answer: 'PEDAGOGIK', x: 1, y: 2, direction: ClueDirection.horizontal),
        Clue(id: 'h2', text: 'Rencana pelajaran dalam pendidikan', answer: 'KURIKULUM', x: 0, y: 5, direction: ClueDirection.horizontal),
        Clue(id: 'v1', text: 'Pertukaran pikiran untuk belajar', answer: 'DISKUSI', x: 3, y: 0, direction: ClueDirection.vertical),
        Clue(id: 'v2', text: 'Guru besar di universitas', answer: 'PROFESOR', x: 7, y: 2, direction: ClueDirection.vertical),
      ],
    ),
  ];

  static List<LevelData> getLevelsByDifficulty(Difficulty difficulty) {
    return allLevels.where((l) => l.difficulty == difficulty).toList();
  }
}
