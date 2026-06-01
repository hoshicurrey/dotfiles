# Global Claude Code Settings

## Obsidian Vault

Vault path: `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/main`

Folder structure:
- `daily/` — daily notes (`YYYY-MM-DD.md`)
- `weekly/` — weekly notes (`weekly-YYYY-MM-DD.md`)
- `courses/{年度}/` — course notes (`YYYY-MM-DD_科目名.md`、年度は4月始まり翌年3月終わり)
- `meetings/` — meeting notes (`YYYY-MM-DD_タイトル.md`)
- `projects/` — project notes（ファイル名は **kebab-case 英語**、例 `spread1000-application.md`。研究プロジェクトの場合は `projects/{プロジェクト名}/` サブディレクトリを作成し、解析レポート等を格納）
- `notes/` — misc notes, workflow docs, ideas
- `references/literature/` — 文献ノート（Zotero連携、ファイル名はcitekey）
- `goals.md` — 長期目標・方針（/morningで毎朝表示）

## ノート・タスク管理の使い分け

| ツール | 役割 |
|--------|------|
| **Todoist** | 実行管理（期日・チェック）。細部のタスク |
| **Project note** (`projects/`) | 全体把握。どこまでやったかの確認 |
| **Meeting note** (`meetings/`) | 会議の文脈・決定事項の記録 |

- Meeting noteのアクションアイテムは「決定した事実」の記録（担当者・アクション・期限）。ステータス管理はしない
- テンプレート: `templates/meeting-agenda-template.md`、`templates/project-note-template.md`
- 詳細: `notes/meeting-project-workflow.md`

## User

Course owner name: 星川（coursesディレクトリのフロントマター `owner` フィールドで使用）

勤務時間: 8:00–16:45（月〜金）、昼休み 11:30–13:00

## Git リポでの作業ルール

職場 PC と自宅 PC の 2 台で同じリポジトリを並行操作することがあるため、編集・コミット系の作業を始める前に必ず remote の divergence を確認する。

1. まず `git status` で作業ツリーをチェック
2. Clean なら `git pull --rebase`
3. Dirty なら `git fetch` で状況確認 → 既存変更を活かす方針（commit / stash）を決めてから pull
4. Upstream 未設定ブランチでは `git fetch` のみで divergence を判定
5. 読み取り専用セッションでは省略可

衝突が起きた場合は force push せず rebase で解消。両端末のどちらが authoritative かを個別判断する。

## データ分析コーディング規約

@data-analysis-coding-conventions.md

## 研究プロジェクト規約

新規研究プロジェクトは以下 4 点を組み合わせて構成する。詳細・判断基準は Obsidian Vault の `notes/research-project-setup.md` を参照。

### 場所の使い分け

| 性質 | 場所 |
|------|------|
| 作業領域（ソース、git） | `~/work/projects/{kebab-case名}/`（**非 iCloud**） |
| 提出物アーカイブ | `~/Documents/grant/{YYYYMMDD}_{種別}_{略称}/`（iCloud） |
| Obsidian プロジェクトノート | Vault の `projects/{kebab-case名}.md` |
| データ実体（巨大） | git 管理外（外部 HDD・S3 等） |

**iCloud と git/.claude/ は相性が悪い**ため、ソースは必ず `~/work/projects/` に置く。提出物（.docx, .pdf）のみ iCloud `Documents/grant/` にコピーしてアーカイブする。

### 標準ディレクトリ構造

```
~/work/projects/{name}/
├── CLAUDE.md
├── README.md
├── .gitignore
├── proposals/{YYYY}-{種別}/    # 申請書フェーズ（drafts/*.md, 様式/, figures/, refs/, budget/, output/）
├── data/                       # gitignore（実体は外部）
├── src/                        # 解析コード
├── notebooks/                  # 探索的実験
├── reports/                    # 中間・最終報告（採択後）
└── papers/                     # 論文ドラフト（将来）
```

### ワークフロー

1. **申請書執筆**: `proposals/{YYYY}-{種別}/drafts/*.md` を真のソースとし、pandoc で .docx 生成 → 提出版を `~/Documents/grant/...` にコピー
2. **採択後**: `data/`・`src/`・`notebooks/` で本研究、`reports/`・`papers/` で成果物
3. **GitHub remote**: 長期/多端末/将来の共有が見込まれるプロジェクトは private repo を推奨

### .gitignore 雛形


```
.DS_Store
data/raw/
data/processed/
*.las
*.laz
*.ply
*.pcd
proposals/**/output/
~$*
.venv/
__pycache__/
.Rhistory
.RData
.Rproj.user/
renv/library/
.claude/local/
```

## Obsidian vault の取り扱い

Vault: `~/vault`（実体: `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/main`）

`additionalDirectories` でホームから起動したまま vault 全体に読み書きできる。CWD は常にホーム。

### 役割分担

| 操作 | 担当 |
|------|------|
| 本文を読む・要約・下書き・本文を編集 | 通常のファイルアクセス（Read / Edit / Grep / Glob）でよい |
| 移動・リネーム・削除・テンプレ作成・daily・properties・tag 操作 | **必ず `obsidian` CLI 経由**（wikilink 保護） |

vault 内で `mv` / `rm` / `rmdir` を直接使わない（PreToolUse hook でブロックされる）。

### 前提

- `obsidian` は起動中の Obsidian アプリを操作するリモコン。アプリが起動していること（未起動でも自動起動するが、完了を待つ）。
- 構文に不安があれば必ず `obsidian help <command>` で確認してから使う。引数は `key=value` 形式。
- 学習カットオフ以降にリリースされたコマンドがあるため、使う前に `obsidian help` で一覧を確認する。

### よく使うコマンド

```bash
obsidian help                                        # コマンド一覧
obsidian daily                                       # 今日の daily note を開く
obsidian daily:append content="- [ ] タスク"         # daily note に追記
obsidian daily:read                                  # daily note を読む
obsidian read file="path/to/note"                    # 指定ノートを読む
obsidian search query="検索語"                        # vault を全文検索
obsidian search query="status::active" format=json   # JSON 出力
obsidian create name="フォルダ/新規ノート" template=テンプレ名   # テンプレから作成
obsidian create name="フォルダ/新規ノート" content="# 見出し"   # 内容指定で作成
obsidian files sort=modified limit=5                 # 更新順ノート一覧
obsidian move file="old.md" name="new.md"            # 移動/リネーム（リンク自動修正）
obsidian delete file="path/to/note"                  # 削除
obsidian property:set file="path" key="status" value="active"  # プロパティ設定
obsidian tags counts                                 # タグと頻度
obsidian tasks daily                                 # daily note のタスク一覧
```

### 定型ワークフローとの分担

daily-report / check-in / morning のような繰り返し処理は各スキル内に obsidian コマンドを直書きする。本ルールは ad-hoc な作業向け。
