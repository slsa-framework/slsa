---
language: ja
---
# slsa.devソースコード

このディレクトリには、https：//slsa.dev のソースが含まれており、GitHub ページを介して提供され、Jekyll でレンダリングされます。

## ローカルでのテスト

[github/pages-gem](https://github.com/github/pages-gem)を使用して、ローカル Web を生成します。
次のように Docker による方法をお勧めします。

1.  Docker をインストールします。

2.  Docker イメージのクローンを作成してビルドします。

    ```bash
    git clone https://github.com/github/pages-gem
    cd pages-gem
    make image
    ```

3.  `PATH_TO_SLSA_REPO` が存在する pages-gem ディレクトリからサーバーを実行します。

    ```bash
    SITE=PATH_TO_SLSA_REPO/docs make server
    ```

4.  http://localhost:4000 にアクセスします。
