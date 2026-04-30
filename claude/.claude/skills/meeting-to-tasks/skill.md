---
name: meeting-to-tasks
description: ミーティングノートのアクションアイテムをTodoistタスクに登録
args:
  note:
    description: ミーティングノートのファイル名（拡張子なし、省略時は最新）
    required: false
---

ミーティングノートを読み取り、星川担当のアクションアイテムをTodoistタスクとして登録します。

## 手順

1. **ミーティングノートの特定**
   - 引数 `note` が指定されている場合：vault の `meetings/{note}.md` を読み込む
   - 指定がない場合：Bashで以下を実行して最新ファイルを特定する
     ```bash
     ls -t "/Users/takeshi/Library/Mobile Documents/iCloud~md~obsidian/Documents/main/meetings/" | head -5
     ```
   - 最新ファイルのフルパスをReadツールで読み込む

2. **アクションアイテムの抽出**
   - `## アクションアイテム` または `## 次のアクション` セクションを探す
   - 以下フォーマットの行を解析する：
     ```
     - 【担当者名】アクション内容（期限: MM/DD または YYYY-MM-DD）
     ```
   - 担当者が「星川」の行、または担当者指定なし（`【】`なし）の行を星川担当とみなす
   - 他の担当者（相手方など）の行はスキップ

3. **抽出結果を提示して確認**
   - 星川担当のアクション一覧を表示（担当者・内容・期限）
   - 「以下のタスクをTodoistに登録しますか？」と確認
   - ユーザーが修正を求めた場合は反映して再提示

4. **Todoistタスクの作成**
   - 確認後に `mcp__todoist__add-tasks` でタスクを作成
   - 各タスクの設定：
     - `content`：アクション内容
     - `description`：ミーティングノートへのObsidianリンク
       ```
       [[meetings/YYYY-MM-DD_タイトル]]
       ```
     - `dueString`：期限（記載ある場合のみ）
     - `priority`：p3（デフォルト）
   - 関連プロジェクトがノートのfrontmatterに記載されていればTodoistのプロジェクトへの紐付けを提案する

5. **完了報告**
   - 作成したタスクの一覧を表示

## アクションアイテムのフォーマット規則

ミーティングノートの「次のアクション」セクションは以下のフォーマットで記載：

```markdown
## 次のアクション

- 【星川】アクション内容（期限: MM/DD）
- 【相手の名前】アクション内容（期限: MM/DD）
- 担当者未指定のアクション（星川担当とみなす）
```

- 期限は `（期限: MM/DD）` または `（期限: YYYY-MM-DD）` の形式
- 星川以外の担当者行はTodoistに登録しない（記録としてノートに残す）

## 注意事項

- 確認前にタスクを作成しない
- 期限が指定されていない場合は `dueString` を省略する
- Vault path: `/Users/takeshi/Library/Mobile Documents/iCloud~md~obsidian/Documents/main`
