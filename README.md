![](https://github.com/imobile-maio/maio-iOS-SDK/blob/wiki/doc/images/logo.png)

# maio Adobe AIR Extension

* Adobe AIR Extension version 1.0.0β
* 同梱しているSDK
    * iOS SDK Version 1.2.11
    * Android SDK Versios 1.0.4

## Download
[releases](https://github.com/imobile-maio/maio-Adobe-AIR-Extension/releases)

## Get Started
[wiki/Get-Started](https://github.com/imobile-maio/maio-Adobe-AIR-Extension/wiki/Get-Started)

## API Reference
[wiki/API-Reference](https://github.com/imobile-maio/maio-Adobe-AIR-Extension/wiki/API-Reference)

## 既知の不具合

* `StageWebView` が表示されている最中に広告を表示しようとした場合、画面が真っ黒のまま表示されません。
    - `StageWebView` のインスタンスを破棄した後に広告を再生することで、この不具合を回避できます。

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

1. 更新の必要がある、以下のいずれかのファイルを差し替えます。
    * `Extension/build/android/maio.jar`
    * `Extension/build/ios/Maio.framework`
2. `Extension/build.sh`を実行します。
3. ビルドされたファイルがルートディレクトリに`MaioExtension.ane`として保存されます。
