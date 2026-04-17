# Neovim Configuration

このNeovim設定は以下の機能を提供します:

## 機能

### 1. Emacsスタイルのキーバインド
- `Ctrl+a`: 行の先頭に移動
- `Ctrl+e`: 行の末尾に移動
- `Ctrl+f`: 前進(右)
- `Ctrl+b`: 後退(左)
- `Ctrl+n`: 次の行
- `Ctrl+p`: 前の行
- `Ctrl+k`: 行末まで削除
- `Ctrl+x Ctrl+s`: ファイル保存
- `Ctrl+x Ctrl+c`: 終了
- `Ctrl+x b`: バッファ切り替え
- `Ctrl+x d`: ファイルエクスプローラー

### 2. ファイルエクスプローラー (Neo-tree)
- `Ctrl+x d` or `<leader>e`: ファイルエクスプローラーの表示/非表示
- `Enter`: ファイルを開く
- `P`: プレビューモードのトグル（開くとカーソル移動でファイル内容が自動表示）
- `a`: 新規ファイル/ディレクトリ作成
- `d`: 削除
- `r`: リネーム
- `y`: コピー
- `x`: カット
- `p`: ペースト
- `gg`: カーソル位置のリポジトリでLazyGitを開く
- `ff`: カーソル位置のディレクトリ配下でファイル検索（Telescope）
- `fg`: カーソル位置のディレクトリ配下でテキスト検索（Telescope live grep）

### 3. LSP機能 (定義ジャンプ・参照検索)
- `gd` or `Ctrl+]`: 定義にジャンプ
- `gr`: 参照を検索
- `K`: ホバー情報を表示
- `gi`: 実装にジャンプ
- `<leader>rn`: リネーム
- `<leader>ca`: コードアクション
- `<leader>f`: フォーマット（conform.nvim経由、手動実行）
- `Ctrl+LeftMouse` or `Alt+LeftMouse`: マウスクリックで定義にジャンプ

### 4. 補完機能 (nvim-cmp)
- `Tab`: 次の候補
- `Shift+Tab`: 前の候補
- `Enter`: 確定
- `Ctrl+Space`: 補完を開く
- `Ctrl+e`: 補完を閉じる

### 5. インライン警告・診断
- `]d`: 次の診断へ
- `[d`: 前の診断へ
- `<leader>d`: 診断の詳細を表示
- カーソルを止めると自動的に診断が表示されます

### 6. Git統合
#### Gitsigns
- `]c`: 次の変更箇所
- `[c`: 前の変更箇所
- `<leader>hs`: 変更をステージング
- `<leader>hr`: 変更をリセット
- `<leader>hp`: 変更をプレビュー
- `<leader>hb`: blame情報を表示

#### LazyGit
- `<leader>gg`: LazyGitを開く
- `<leader>gP`: PRをブラウザで作成（`gh pr create --web`）
- `<leader>gV`: 現在のブランチのPRをブラウザで表示

#### Octo (GitHub PR Review)
- `<leader>op`: PRリスト表示
- `<leader>oi`: Issueリスト表示
- `<leader>or`: PRレビュー開始
- PR内での操作:
  - `<space>ca`: コメント追加
  - `<space>sa`: サジェスション追加
  - `<space>pm`: PRマージ
  - `<space>pc`: コミット一覧
  - `<space>pf`: 変更ファイル一覧

#### Diffview
- `<leader>dv`: Diffビューを開く
- `<leader>dc`: Diffビューを閉じる
- `<leader>dh`: ファイル履歴を表示

### 7. コメント (Comment.nvim)
- `gcc`: 行コメントのトグル
- `gc` + モーション: ブロックコメントのトグル（例: `gcap` で段落）
- ビジュアル選択 → `gc`: 選択範囲をコメント

### 8. Undo履歴 (undotree)
- `<leader>u`: undoツリーの表示/非表示

### 9. 構文解析 (Treesitter)
- `<C-space>`: 構文ノードを選択（連打で範囲拡大）
- `<BS>`: 選択範囲を一段縮小

### 10. タブ操作
- `[t`: 前のタブ
- `]t`: 次のタブ
- `gt` / `gT`: 次 / 前のタブ（Vim 組み込み）
- `<leader>tn`: 新規タブ
- `<leader>tc`: タブを閉じる
- `<leader>to`: 他のタブを全て閉じる

### その他の便利なキーバインド
- `<leader>ff`: ファイル検索
- `<leader>fg`: テキスト検索
- `<leader>fb`: バッファ検索
- `Tab`: 次のバッファ
- `Shift+Tab`: 前のバッファ

## インストール

1. この設定を `~/.config/nvim/` に配置
2. Neovimを起動すると自動的にプラグインがインストールされます
3. `:checkhealth` で設定状態を確認できます

## 必要な外部ツール

以下のツールをインストールすることを推奨します:

```bash
# ripgrep (テキスト検索用)
brew install ripgrep

# fd (ファイル検索用)
brew install fd

# lazygit (Git UI)
brew install lazygit

# GitHub CLI (PR Review用)
brew install gh

# フォーマッタ (conform.nvim用)
brew install stylua black rustfmt prettier shfmt clang-format
```

Mason 経由でもインストールできます:
```vim
:MasonInstall stylua black prettierd shfmt clang-format
```

## LSPサーバー

Mason経由で以下のLSPサーバーが自動インストールされます:
- lua_ls (Lua)
- ts_ls (TypeScript/JavaScript)
- pyright (Python)
- rust_analyzer (Rust)
- gopls (Go)
- html, cssls, jsonls

追加のLSPサーバーは `:Mason` から手動でインストールできます。

## トラブルシューティング

### マウスクリックが動作しない場合
ターミナルエミュレータによっては、Cmd+Clickがターミナル側で処理されます。
- iTerm2: Preferences → Profiles → Keys → 「Application keypad mode」を有効化
- Kitty: 設定ファイルに `mouse_map cmd+left press ungrabbed mouse_click_url` を追加

### GitHub PR Reviewを使用する前に
```bash
# GitHub CLIで認証
gh auth login
```
