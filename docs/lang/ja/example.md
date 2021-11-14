---
language: ja
---
# 例

<a id="motivating-example"></a>

## 動機となる例

[curl](https://curl.se)を[公式dockerイメージ][curlimages/curl]を通じてを使用する例を考えてみましょう。
ソフトウェアのサプライチェーンにおいて、私たちはどのような脅威にさらされているのでしょうか？
(curlを選んだのは、単に人気のあるオープンソースパッケージだからで、特定するためではありません)。

最初の問題は、実際のサプライチェーンを把握することです。
これには多大な手作業、推測、そして盲目的な信頼が必要です。
逆算してみると

-   Docker Hubの "latest" タグは[7.72.0](https://hub.docker.com/layers/curlimages/curl/7.72.0/images/sha256-3c3ff0c379abb1150bb586c7d55848ed4dcde4a6486b6f37d6815aed569332fe?context=explore)を指しています。
-   これは、[curl/curl-docker](https://github.com/curl/curl-docker/blob/d6525c840a62b398424a78d792f457477135d0cf/alpine/latest/Dockerfile)のGitHubリポジトリにあるDockerfileから来ていると主張しています。
-   そのDockerfileは、ビルド時にそれ以上のフェッチがないと仮定して、以下のアーティファクトを読み込みます。
    -   Docker Hubイメージ。
        [registry.hub.docker.com/library/alpine:3.11.5](https://hub.docker.com/layers/alpine/library/alpine/3.11.5/images/sha256-cb8a924afdf0229ef7515d9e5b3024e23b3eb03ddbba287f4a19c6ac90b8d221?context=explore)
    -   Alpineのパッケージ： libssh2 libssh2-dev libssh2-static autoconf automake build-base groff openssl curl-dev python3 python3-dev libtool curl stunnel perl nghttp2
    -   参考ファイル： https://curl.haxx.se/ca/cacert.pem
-   それぞれの依存関係には独自のサプライチェーンがありますが、実際の"curl"のソースコードを含む[curl-dev]を見てみましょう。
-   このパッケージは、他のAlpineのパッケージと同様に、ビルドスクリプトがAlpineのgit repo内の[APKBUILD](https://git.alpinelinux.org/aports/tree/main/curl/APKBUILD?id=166f72b36f3b5635be0d237642a63f39697c848a)に定義されています。
    ビルドにはいくつかの依存関係があります。
    -   参考ファイル： <https://curl.haxx.se/download/curl-7.72.0.tar.xz>。
        -   APKBUILDには、このファイルのsha256ハッシュが含まれています。
            このハッシュがどこから来たのかは不明です。
    -   Alpineのパッケージ: openssl-dev nghttp2-dev zlib-dev brotli-dev autoconf automake groff libtool perl
-   このソースtarボールは、実際のアップストリームGitHubリポジトリ[curl/curl@curl-7_72_0](https://github.com/curl/curl/tree/curl-7_72_0)から、`./buildconf && ./configure && make && ./maketgz 7.72.0`のコマンドを実行してビルドされたものと思われます。
    このコマンドには一連の依存関係があり、それらは十分に文書化されていません。
-   最後に、上記のビルドを実際に実行したシステムがあります。このシステムのソフトウェア、構成、ランタイムの状態については何もわかりません。

例えば、ある開発者のマシンが侵害されたとします。
その開発者の認証情報だけで、どのような攻撃が一方的に実行できる可能性があるでしょうか？
(いずれも確認されていません。)

-   悪意のあるイメージをDocker Hubに直接アップロードする。
-   CI/CDシステムに非公式のDockerfileからのビルドを指示する。
-   [curl/curl-docker](https://github.com/curl/curl-docker/blob/d6525c840a62b398424a78d792f457477135d0cf/alpine/latest/Dockerfile)のgit repoに悪意のあるDockerfile(またはその他のファイル)をアップロードします。
-   悪意のある https://curl.haxx.se/ca/cacert.pem をアップロードします。
-   Alpineのgit repoに悪意のあるAPKBUILDをアップロードします。
-   悪意のある [curl-dev] Alpine パッケージを Alpine リポジトリにアップロードします。
    (これが可能かどうかは不明です)
-   悪意のある https://curl.haxx.se/download/curl-7.72.0.tar.xz をアップロードします。
    (APKBUILD のハッシュが計算される前にアップロードされた場合、ハッシュでは検出されません。)
-   [curl/curl](https://github.com/curl/curl/) のgit repoに悪意のある変更をアップロードします。
-   [SolarWinds attack](https://www.crowdstrike.com/blog/sunspot-malware-technical-analysis/)のように、サプライチェーンに関わるシステムを攻撃すること。

SLSA はこれらの脅威をすべてカバーすることを意図しています。
サプライチェーン上のすべてのアーティファクトが十分なSLSAレベルを持つようになれば、消費者はこれらの攻撃のほとんどが緩和されているという確信を得ることができます。
これは、まず自己証明によって、そして最終的には自動検証によって実現されます。

最後に、これらはすべてcurl自身のファーストパーティのサプライチェーンのステップに限った話であることに注意してください。
依存関係にあるAlpineベースイメージやパッケージにも、同様の脅威があります。
また、依存関係には依存関係があり、その依存関係にはまた別の依存関係がある、といった具合です。
それぞれの依存関係には、[独自のSLSAレベル](#scope-of-slsa)があり、[SLSAレベルの構成](#composition-of-slsa-levels)がサプライチェーン全体のセキュリティを表します。

Dockerのサプライチェーンのセキュリティについては、[Who's at the Helm?](https://dlorenc.medium.com/whos-at-the-helm-1101c37bf0f1)を参照してください。
これらの問題やその他多くの問題を含む、オープンソースのセキュリティについてのより広範な考察については、[Threats, Risks, and Mitigations in the Open Source Ecosystem]を参照してください。

## ビジョン: ケーススタディ

SLSAフレームワークを使用して、[動機となる例](#motivating-example)の[curlimages/curl]をどのように保護するかを考えてみましょう。

### SLSA 4への漸進的な到達

まずは、最終的なDockerイメージにSLSAの原則をインクリメンタルに適用してみましょう。

#### SLSA 0: 初期状態

![slsa0](../../images/slsa-0.svg)

初期状態のDockerイメージはSLSA 0です。
実績はありません。
誰がこのアーティファクトを構築したのか、どのようなソースや依存関係を使用したのかを判断することは困難です。

この図では、可変(mutable)ロケータ `curlimages/curl:7.72.0` が不変(immutable)アーティファクト `sha256:3c3ff…` を指していることがわかります。

#### SLSA 1: 来歴

![slsa1](../../images/slsa-1.svg)

ビルドをスクリプト化し、[来歴](https://github.com/in-toto/attestation)を生成することで、SLSA 1に到達することができます。
ビルドスクリプトはすでに `make` で自動化されているので、シンプルなツールを使ってリリースごとに来歴を生成します。
来歴には、出力されたアーティファクトのハッシュ、ビルダー(ここでは、私たちのローカルマシン)、そしてビルドスクリプトを含むトップレベルのソースが記録されます。

更新された図では、来歴認証は、アーティファクト `sha256:3c3ff…` が [curl/curl-docker@d6525…](https://github.com/curl/curl-docker/blob/d6525c840a62b398424a78d792f457477135d0cf/alpine/latest/Dockerfile) からビルドされたことを示しています。

SLSA 1では、来歴は改ざんや偽造から保護するものではありませんが、脆弱性管理には有用でしょう。

#### SLSA 2 and 3: ビルドサービス

![slsa2](../../images/slsa-2.svg)

SLSA 2（そして後のSLSA 3）に到達するためには、我々のために来歴を生成するホストされたビルドサービスに切り替える必要があります。
この更新された実績には、ベストエフォートベースの依存関係も含まれているはずです。
SLSA 3 ではさらに、ソースおよびビルドプラットフォームに追加のセキュリティ制御を実装する必要があり、これを有効にする必要があるかもしれません。

更新された図では、来歴にベースイメージ (`alpine:3.11.5`) や apk パッケージ (例: `curl-dev`) など、いくつかの依存関係が記載されています。

SLSA 3では、証明書の信頼性は以前よりも大幅に向上しています。
高度な技術を持った敵だけがこの証明書を偽造できるでしょう。

#### SLSA 4: 密封性と2者レビュー

![slsa4](../../images/slsa-4.svg)

SLSA 4 [requirements](requirements.md) 二者間のソースコントロールと密閉性の高いビルド。
特に密封性(hermeticity)は、依存関係が完全(complete)であることを保証します。
これらの制御が有効になると、DockerイメージはSLSA 4になります。

更新された図では、証明書が密閉性を証明するようになり、以前はなかった`cacert.pem`の依存関係が含まれています。

SLSA 4では、来歴が完全で信頼できる(complete and trustworthy)ものであり、1人の人間がトップレベルのソースを一方的に変更することはできないという高い自信(high confidence)があります。

### フルグラフ

![フルグラフ](../../images/slsa-full-graph.svg)

上記と同じ手順を再帰的に適用して、依存関係をロックすることができます。
ソースではない依存関係はそれぞれ独自の証明書を取得し、それがさらに依存関係をリストアップする、といった具合です。

最後の図は、グラフのサブセットを示しており、上流のソースリポジトリへのパス（[curl/curl](https://github.com/curl/curl)）と証明書ファイル（[cacert.pem](https://curl.se/docs/caextract.html)）を強調しています。

実際には、依存関係が四散し、グラフは手に負えないほど大きくなっています。
最も重要なコンポーネントに集中するために、グラフを切り詰める方法が必要です。
これは手作業でもできますが、スケーラブルで汎用的、かつ自動化された方法でこれを行う最善の方法については、まだ確固たるビジョンがありません。
1つのアイデアは、エコシステム特有のヒューリスティックを使用することです。
例えば、Debian のパッケージは非常に統一された方法で構築・整理されているので、Debian 固有のヒューリスティクスが使えるかもしれません。

<a id="composition-of-slsa-levels"></a>

### SLSAレベルの構成

アーティファクトのSLSAレベルは推移的ではないので、サプライチェーン全体のセキュリティリスクを示す何らかの集約的な尺度が必要です。
言い換えれば、グラフの各ノードは、それぞれ独立したSLSAレベルを持っています。
あるアーティファクトのレベルがNであるからといって、その依存関係のレベルについては何も意味しません。

この例では、最終的な[curlimages/curl]のDockerイメージがSLSA 4で、その依存関係である[curl-dev]がSLSA 0だったとします。
これは重大なセキュリティ・リスクを意味します。
敵対者は、[curl-dev]パッケージに含まれるソース・コードを修正することで、最終的なイメージに悪意のある動作を持ち込む可能性があります。
とはいえ、SLSA 0 に依存していることを特定できるだけでも、取り組みに集中できるという点で非常に大きな価値があります。

この集約的なリスク指標の形成は、今後の課題とします。
実際のデータがない状態でこのような指標を開発するのは、おそらく時期尚早でしょう。
SLSAがより広く採用されるようになれば、パターンが現れ、作業が少し楽になることを期待しています。

### 認定と委譲

SLSAのフレームワークでは、認定と委任が大きな役割を果たします。
すべてのソフトウェア消費者が、すべてのプラットフォームを完全に検証し、すべての成果物のグラフ全体を完全に把握することは現実的ではありません。
監査人や認定機関は、ある方法で構成されたプラットフォームやベンダーがSLSAの要件を満たしていることを検証し、主張することができます。
同様に、依存関係を分析せずに成果物を「信頼」する方法があるかもしれません。これは、特にクローズドソースのソフトウェアに有効です。

<!-- Links -->

[Threats, Risks, and Mitigations in the Open Source Ecosystem]: https://github.com/Open-Source-Security-Coalition/Open-Source-Security-Coalition/blob/master/publications/threats-risks-mitigations/v1.1/Threats%2C%20Risks%2C%20and%20Mitigations%20in%20the%20Open%20Source%20Ecosystem%20-%20v1.1.pdf
[curl-dev]: https://pkgs.alpinelinux.org/package/edge/main/x86/curl-dev
[curlimages/curl]: https://hub.docker.com/r/curlimages/curl
