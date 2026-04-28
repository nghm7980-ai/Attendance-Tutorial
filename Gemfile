# Gemをダウンロードする場所の指定
source "https://rubygems.org"

# 使用するRubyのバージョン
ruby "3.0.6"

# 【基本の道具（Gem）】
gem "rails", "~> 7.1.0"      # Rails本体
gem 'bcrypt'                 # パスワードを暗号化して保存するための道具
gem 'faker'                  # 本物っぽい偽データ（名前など）を作る道具（重複を削除してここに集約）
gem "sprockets-rails"        # 画像やCSSファイルを管理する仕組み
gem "mysql2"      # データを保存するデータベース（mysql2）
gem "puma", ">= 5.0"         # Railsを動かすためのWebサーバー
gem "importmap-rails"        # JavaScriptを簡単に扱うための仕組み
gem "turbo-rails"            # 画面遷移を高速化する魔法の道具（重複を削除してここに集約）
gem "stimulus-rails"         # 画面に動きをつけるJavaScriptの枠組み
gem "jbuilder"               # データをJSON形式で出力するための道具

gem 'will_paginate', '3.3.1'
gem 'bootstrap-will_paginate', '1.0.0'

gem "bootsnap", require: false # Railsの起動を速くする加速装置
gem "sassc-rails"            # CSSをより便利に書くための道具
gem 'bootstrap-sass', '3.3.6' # 画面のデザインを整える枠組み
gem 'jquery-rails'           # JavaScriptを便利に使うためのライブラリ

# 【開発環境とテスト環境の両方で使う道具】
group :development, :test do
  # コードの動きを止めて中身を調査できるデバッグツール
  gem "debug", platforms: %i[ mri mswin mswin64 mingw x64_mingw ]
end

# 【開発環境（自分のPC上）だけで使う道具】
group :development do
  # ブラウザ上のエラー画面を便利にするツール
  gem "web-console"
end

# 【テスト環境（自動テスト用）だけで使う道具】
group :test do
  gem 'capybara', '>= 3.26'           # ブラウザの動きをシミュレートする道具
  gem 'selenium-webdriver'            # ブラウザを自動操作する道具
  gem 'webdrivers'                    # ブラウザ操作に必要な部品の管理
  gem 'rails-flog', require: 'flog'   # コードが複雑になりすぎていないか測定するツール
  gem 'rspec-rails'                   # 高機能なテストを作成するための道具
  gem "factory_bot_rails"             # テストデータを効率よく作るための道具
  gem 'database_cleaner'              # テストが終わるたびにDBを掃除する道具
  gem 'rails-controller-testing'      # コントローラーのテストを助ける道具
end

# 【Windows/Mac共通の設定】
# Windows環境で時間を正しく扱うための設定（重複を削除してここに集約）
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]