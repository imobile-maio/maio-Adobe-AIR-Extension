![](https://github.com/imobile-maio/maio-iOS-SDK/blob/wiki/doc/images/logo.png)

# maio Adobe AIR Extension

* Adobe AIR Extension version 1.0.0β
* 同梱しているSDK
    * iOS SDK Version 1.3.1
    * Android SDK Version 1.1.1

## Download
[releases](https://github.com/imobile-maio/maio-Adobe-AIR-Extension/releases)

## Get Started
[wiki/Get-Started](https://github.com/imobile-maio/maio-Adobe-AIR-Extension/wiki/Get-Started)

## API Reference
[wiki/API-Reference](https://github.com/imobile-maio/maio-Adobe-AIR-Extension/wiki/API-Reference)

## 既知の不具合

* `StageWebView` が表示されている最中に広告を表示しようとした場合、画面が真っ黒のまま表示されません。
    - `StageWebView` のインスタンスを破棄した後に広告を再生することで、この不具合を回避できます。
* プレイアブル広告の表示ができません。
    - `AndroidManifest.xml` に `HtmlBasedAdActivity` を記述しなければ動画広告のみが配信されますので、プレイアブル広告に対応するまではこちらの記述は行わないようお願いいたします。

## 自身でビルドする場合

* macOS、Animate にて動作確認をしています。
* Animate または Flash Builder の adt が利用できるようパスを通しておく必要があります。

### MaioExtension のプロジェクト構成
* Extension/IOSMaioExtension
    - Xcode で作成された iOS 向けの Extension です。
* Extension/MaioAdobeAirExtensionBase
    - Android Studio で作成された Android 向けの Extension です。
* Extension/MaioExtension
    - Flash Builder 4.7で作成された Adobe AIR 向けの Extension です。
* Extension/MaioExtensionDefault
    - Flash Builder 4.7で作成された Adobe AIR 向けのデフォルト Extension です。
    - デバッガやPC環境で実行した場合に参照されます。
* Extension/build
    - 実際にビルドするバイナリを配置しています。

### SDKの差し替え手順

- 以下の作業は macOS で行うことを想定しています。
- `update.py` を実行することで、最新の maio SDK を github より取得し、新しい ANE を `update.py` と同じディレクトリに出力します。
- `update.py` を実行するには、**Python v3.6 以上を必要とします。**

```sh
cd <このレポジトリを展開したディレクトリ>
chmod 777 ./update.py
./update.py
```
