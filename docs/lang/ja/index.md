---
title: Overview
language: ja
---
# サプライチェーン全体でアーティファクトの整合性を改善する

<!--{% if false %}-->

**注:このサイトは https://slsa.dev で表示するのが最適です。**

<!--{% endif %}-->

<span class="subtitle">

SLSA("[salsa](https://www.google.com/search?q=how+to+pronounce+salsa)")は、**ソフトウェア成果物のサプライチェーンレベル**です。

ソースからサービスまでのセキュリティフレームワーク。ソフトウェアを使用するすべての人に、ソフトウェアのセキュリティとサプライチェーンの整合性のレベルを高めるための共通言語を提供します。

</span>

<!-- Levels overview -->
<section class="breakout">

<div class="wrapper">
<span class="subtitle flushed">Overview</span>

## セキュリティレベル

各レベルは、ソフトウェアへの信頼を高めるための要件、プロセス、およびベストプラクティスを提供します。
これらは、ソースサービスとビルドサービスの整合性、コードに関する利用可能な情報、改ざんや人為的エラーに対する再現性と回復力に注目しています。

<div class="level-icons m-b-l m-t-xl">

<div class="level">

<div class="level-badge">

![Level 1](../../images/levelBadge1.svg)

</div>

### 基本的な保護

リスクとセキュリティの評価に役立つ来歴チェック

</div>

<div class="level">

<div class="level-badge">

![Level 2](../../images/levelBadge2.svg)

</div>

### 中程度の保護

ソフトウェアの起源に対するさらなるチェック

</div>

<div class="level">

<div class="level-badge">

![Level 3](../../images/levelBadge3.svg)

</div>

### 高度な保護

特定の脅威クラスに対する追加の耐性

</div>
<div class="level">

<div class="level-badge">

![Level 4](../../images/levelBadge4.svg)

</div>

### 最大の保護

厳格な監査能力と信頼性のチェック

</div>

</div>

<div class="buttons-horizontal">

<div class="pseudo-button">

[詳細](levels.md)

</div>

</div>

</div>

</section>

</section>

<!-- Supply chain diagram -->
<section class="content-block">
<span class="subtitle flushed">The supply chain</span>

## 開発の各ステージを保護する

<div class="m-b-l">

### 脅威とリスクをどのように軽減しますか？

どのソフトウェアもサプライチェーンに脆弱性をもたらす可能性があり、最近注目を集めている事例は、攻撃のコストがどれほど高くなるかを証明しています。
SLSA フレームワークを構成するステップは、開発者と消費者が、[既知のサプライチェーン攻撃](levels.md#threats)に直接対応して開発されたソフトウェア成果物の整合性を簡単かつ自動的にチェックできるようにすることを目的としています。

</div>

<!-- System threats diagram -->
<div class="diagram-wrapper">

<div class="diagram">

![サプライチェーンの脅威](../../images/supply-chain-threats.svg)

</div>

<div class="annotation m-t-s">
サプライチェーンにおける脅威とリスクの発生箇所
</div>

</div>

<div class="m-t-xl">

### 拡張可能なセキュリティガイドライン標準

SLSA レベルは、現在のセキュリティ体制をよりよく理解し、潜在的な脅威から身を守り、将来の計画を立てる方法です。
ソフトウェアを利用している場合は、サプライチェーン内のソフトウェアのセキュリティ情報が正確であるかどうか、必要なレベルのセキュリティが提供されているかどうかを確認し、プロセスを自動化するツールの開発、共有、促進に役立てることができます。

<div class="pseudo-button m-t-l">

[要件を読む](requirements.md)

</div>

</div>

</section>
<!-- Future -->
<section class="breakout">

<div class="wrapper">
<span class="subtitle flushed">Ethos</span>

## 将来に向けた構築

<span class="subtitle">
今日のプロジェクト、製品、およびサービスはますます複雑になり、攻撃を受けやすくなっています。
その傾向が続く中、私たちは、使用するソフトウェアの開発、配布、消費、およびその背後にあるすべての影響を受けるコミュニティを保護するための、より安全でアクセス可能な方法を提供するための取り組みを拡大する必要があります。
</span>

<div class="pseudo-button m-t-l">

[参加する](getinvolved.md)

</div>

</div>

</section>

<!-- Two column wrap-up -->
<section class="col-2 content-block">
<span>

## 現在アルファ版

フレームワークは絶えず改善されており、今では試してテストする準備ができています。
Google は 2013 年から SLSA の内部バージョンを使用しており、すべての本番ワークロードに SLSA を必要としています。

<div class="pseudo-button m-t-l">

[ロードマップを見る](roadmap.md)

</div>
</span>

<span>

## 参加する

改善のために他の組織からのフィードバックに依存しており、皆様からのご意見をお待ちしております。
プロジェクトで達成可能なレベルはありますか？フレームワークに何かを追加または削除しますか？

<div class="pseudo-button m-t-l">

[対話に参加する](getinvolved.md)

</div>

</span>
</section>

<!-- Future -->
<section class="breakout">

<div class="wrapper">
<span class="subtitle flushed">Get started</span>

## GitHub Actionsのデモを見る

[GitHub Actionsの来歴ジェネレーター](https://github.com/slsa-framework/github-actions-demo)を使用して、SLSA レベル 1 のデモを確認してください。

</div>

</section>
