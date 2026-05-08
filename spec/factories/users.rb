# 確実にログインできるように、確認用パスワード(password_confirmation)も明示的に追加します
FactoryBot.define do
  factory :user do
    # Fakerを使ってランダムな名前を作成
    name { Faker::Name.name }
    # メールアドレスが重複しないように連番を作成
    sequence(:email) { |n| "test#{n}-#{Faker::Internet.email}" }
    # ログイン時に使う「生のパスワード」
    password { 'password' }
    # 【追加】パスワード（確認用）も同じ値に設定して、バリデーションを確実に通します
    password_confirmation { 'password' }
    # 管理者権限はデフォルトでオフ
    admin { false }
    # 部署名をランダムに作成
    department { Faker::Job.field }
  end
end