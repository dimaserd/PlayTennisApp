# Play tennis

## Для андроида

```bash
flutter build apk --split-per-abi --release --no-sound-null-safety
```

## Для айфона

```bash
flutter run --release --no-sound-null-safety
```

## Swagger

<https://api.play-tennis.online/swagger/index.html>

## Для публикации в AppStore
Поднять версию в файле pubspec.yaml
параметр version: 3.0.0+1

flutter build ipa --release
должно поднять версию

через Xcode необходимо выбрать Runner any device
затем Product -> Archive

Публикация посредством нажатия кнопок далее
Потом надо зайти на developer выбрать свою прилагу создать к ней новую версию
такую же как в параметре

Дождаться пока в раздел сборка попадет файл со сборкой

И после этого дождаться что файл пришел и протыкать далее