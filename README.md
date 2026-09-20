# Praktikum Aplikasi Mobile - Flutter

Satu project Flutter, satu folder per praktikum di dalam `lib/`.

| Folder | Isi |
|---|---|
| [`lib/praktikum1`](lib/praktikum1) | Input Widgets dan Basic Form |
| [`lib/praktikum2`](lib/praktikum2) | Pengenalan Widgets (`main1`) dan Layouting & Styling (`main2`), masing-masing ada versi modul dan `_tugas` |

## Struktur

```
praktikum-flutter/
├── lib/
│   ├── main.dart                     # titik masuk bawaan (menjalankan praktikum 1)
│   ├── praktikum1/
│   │   ├── form-textfield.dart           # modul
│   │   ├── form-textformfield.dart       # modul
│   │   ├── main.dart                     # tugas
│   │   └── user_registration_form.dart   # tugas
│   └── praktikum2/
│       ├── main1.dart                    # modul: Pengenalan Widgets
│       ├── main1_tugas.dart              # tugas
│       ├── main2.dart                    # modul: Layouting & Styling
│       └── main2_tugas.dart              # tugas
├── test/widget_test.dart
├── .vscode/launch.json
├── pubspec.yaml
└── README.md
```

## Persiapan (sekali saja)

```bash
flutter create --project-name praktikum_flutter .
flutter pub get
```

Perintah ini hanya menambah folder platform (android, ios, dll.) dan tidak menimpa file yang sudah ada.

## Menjalankan

```bash
flutter run                                  # praktikum 1 (form pendaftaran)
flutter run -t lib/praktikum2/main1.dart     # file lain: ganti path setelah -t
```

Di VS Code, pilih konfigurasi di tab Run and Debug lalu tekan F5.

## Tes

```bash
flutter test
```
