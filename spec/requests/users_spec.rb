require 'rails_helper'

RSpec.describe "Users", type: :request do
  # 共通で使うユーザーを作成（Factory側でパスワードは'password'に固定されています）
  let(:user) { create(:user) }

  describe 'GET index' do
    context 'ユーザーが5件存在する場合' do
      # テスト実行前に合計5件のユーザーをDBに作成する
      let!(:users) { create_list(:user, 4) + [user] }
  
      before do
        # 【重要】Docker環境でも認識されやすいよう、sessionキーを明示して生のパスワードを送る
        post login_path, params: { 
          session: { 
            email: user.email, 
            password: 'password' 
          } 
        }
        
        # --- Docker環境用のデバッグ出力 ---
        # ログインが成功すると通常 302 (リダイレクト) が返ります。
        # もし 422 が返る場合は、ここで詳細な理由を表示します。
        if response.status != 302
           puts "\n[Docker環境デバッグ] ログイン処理が失敗しました"
           puts "ステータスコード: #{response.status}"
           puts "エラーメッセージ(flash): #{flash[:danger]}"
        end
        # -------------------------------

        # ログイン後の状態で「ユーザー一覧」をJSON形式で取得
        get users_path, as: :json
      end

      it "200 httpレスポンスを返す" do
        # ログインが成功していれば、一覧画面は正常に表示(200)される
        expect(response.status).to eq 200
      end

      it "ユーザーが5件返ってくることを確認する" do
        # 解析したJSONデータの配列サイズが5であればOK
        json_response = JSON.parse(response.body)
        expect(json_response.length).to eq(5)
      end
    end
  end

  describe 'PATCH update' do
    # 更新対象のユーザー
    let(:user) { create(:user) }
  
    before do
      # 更新を行う前にもログイン処理が必要
      post login_path, params: { session: { email: user.email, password: 'password' } }
      # 自身の名前を変更するリクエストを送信
      patch user_path(user), params: { user: { name: '新しい名前' } }, as: :json
    end
  
    it "正常に更新され、200 OKを返すこと" do
      # 以前 422 になっていた箇所。成功すれば 200 が返る
      expect(response.status).to eq 200
      # データベースの情報を最新の状態に更新して確認
      user.reload
      expect(user.name).to eq('新しい名前')
    end
  end

  describe 'DELETE #destroy' do
    # 管理者ユーザー(admin: true)を作成
    let!(:admin_user) { create(:user, admin: true) }
    # 削除される側のユーザー
    let!(:target_user) { create(:user) }

    before do
      # 管理者としてログイン（削除権限があるのは管理者のため）
      post login_path, params: { session: { email: admin_user.email, password: 'password' } }
    end

    it 'ユーザーがデータベースから削除されること' do
      # deleteリクエストによって、Userモデルの件数が -1 になることを確認
      expect {
        delete user_path(target_user)
      }.to change(User, :count).by(-1)
    end

    it '削除成功後に一覧画面へリダイレクトされること' do
      delete user_path(target_user)
      expect(response).to redirect_to(users_url)
      # フラッシュメッセージが表示されているかもチェック
      expect(flash[:success]).to be_present
    end
  end
end