#!/usr/bin/env python

ANDROID_GITHUB = "https://api.github.com/repos/imobile-maio/maio-Android-SDK/"
IOS_GITHUB = "https://api.github.com/repos/imobile-maio/maio-iOS-SDK/"


def isValidPythonVersion():
    """
    Python のバージョンを確認します。
    バージョンが 3.6 以上出ない場合動作させません。

    このコードは古い Python からでも実行される可能性があるため、
    改修の際に型アノテーションなどは追加しないでください。
    """
    import sys
    python_version = sys.version
    vers = python_version.split(".")
    if int(vers[0]) < 3 or int(vers[1]) < 6:
        print("expected version greater than 3.6")
        return False
    return True


def getLatestAndroidSdk() -> None:
    """
    最新の Android SDK を GitHub のリリースページよりダウンロードし、
    必要な場所に配置します。
    """
    import urllib.request
    import json
    import os
    import tarfile
    import shutil

    url = ANDROID_GITHUB + "releases/latest"
    try:
        print("Updating Android SDK...")

        # 最新のリリースを取得
        result = urllib.request.urlopen(url, timeout=1000)

        # 最新のリリースの内容を取得できるURLを抽出
        result_json = json.load(result)
        tarball_url = result_json["tarball_url"]

        if not os.path.exists("tmp"):
            os.mkdir("tmp")

        # 最新のリリースをダウンロード
        urllib.request.urlretrieve(tarball_url, filename="tmp/tmp.tar")

        # 解凍
        output_file_name = ""
        with tarfile.open("tmp/tmp.tar") as content_tar:
            output_file_name = content_tar.getmembers()[0].name
            content_tar.extractall(path="tmp")

        # jar ファイル移動
        shutil.copy("tmp/{}/maio.jar".format(output_file_name),
                    "./Extension/build/android/maio.jar")

        # tmp ディレクトリ削除
        shutil.rmtree("tmp")

        print("Update new Android SDK: {}".format(result_json["tag_name"]))
    except Exception as e:
        print("failed to update Android SDK")
        print(e)
        raise


def getLatestIosSdk() -> None:
    """
    最新の iOS SDK を GitHub のリリースページよりダウンロードし、
    必要な場所に配置します。
    """

    import urllib.request
    import json
    import os
    import zipfile
    import shutil

    url = IOS_GITHUB + "releases/latest"
    try:
        print("Updating iOS SDK...")

        # 最新のリリースを取得
        result = urllib.request.urlopen(url, timeout=1000)

        # 最新の framework をダウンロード
        result_json = json.load(result)
        assets = result_json["assets"]
        first_asset = assets[0]
        download_url = first_asset["browser_download_url"]

        if not os.path.exists("tmp"):
            os.mkdir("tmp")

        # 最新のリリースをダウンロード
        file_name = first_asset["name"]
        urllib.request.urlretrieve(
            download_url, filename="tmp/{}".format(file_name))

        # 解凍
        with zipfile.ZipFile("tmp/{}".format(file_name)) as content_zip:
            content_zip.extractall(path="tmp")

        # framework ファイル移動
        sdk_framework_path = "./Extension/build/ios/Maio.framework"
        if os.path.exists(sdk_framework_path):
            shutil.rmtree(sdk_framework_path)
        shutil.copytree("tmp/Maio.framework", sdk_framework_path)

        # tmp ディレクトリ削除
        shutil.rmtree("tmp")
        print("Update new iOS SDK: {}".format(result_json["tag_name"]))
    except Exception as e:
        print("failed to update iOS SDK")
        print(e)
        raise


if __name__ == '__main__':
    import os
    import shutil

    if not isValidPythonVersion():
        exit()

    try:
        getLatestAndroidSdk()
        getLatestIosSdk()
    except Exception:
        if os.path.exists("tmp"):
            shutil.rmtree("tmp")
        exit()

    from subprocess import call
    call("./Extension/build.sh")
