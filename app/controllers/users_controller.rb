class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info]
  before_action :set_one_month, only: :show


  def index
    @users = User.paginate(page: params[:page])

    respond_to do |format|
      format.html
      format.json { render json: @users }
    end 
  end

  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
    respond_to do |format|
      format.html # これがないとブラウザで画面が表示されません
      format.json { render json: @user } # これでテストが通ります
    end
  end

  def new
    @user = User.new

    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        log_in @user
        flash[:success] = '新規作成に成功しました。'
        format.html { redirect_to @user }
        # テスト(JSON)向けに「作成成功(created)」とデータを返します
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render 'new', status: :unprocessable_entity }
        # テスト(JSON)向けに「エラー内容」を返します
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        flash[:success] = "ユーザー情報を更新しました。"
        format.html { redirect_to @user }
        # テスト(JSON)向けに「成功(ok)」を返します
        format.json { render json: @user, status: :ok }
      else
        format.html { render 'edit', status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # ユーザーを削除します
    @user.destroy
    # ブラウザ表示用のフラッシュメッセージを設定します
    flash[:success] = "#{@user.name}のデータを削除しました。"
    
    # リクエストの形式（HTMLかJSONか）によって、返し方を変えます
    respond_to do |format|
      # ブラウザ（HTML）の場合は、ユーザー一覧ページへ移動します
      format.html { redirect_to users_url }
      # テスト（JSON）の場合は、中身なしの成功ステータス(204 No Content)を返します
      format.json { head :no_content }
    end
  end

  def edit_basic_info
  end

  def update_basic_info
    if @user.update(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      # カリキュラムの指定：エラーメッセージを<br>で連結する
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    
    # カリキュラムの指定：format.turbo_stream を含む respond_to を使用
    respond_to do |format|
      format.html { redirect_to users_url }
      format.turbo_stream
    end
  end

  def basic_info_params
    params.require(:user).permit(:department, :basic_time, :work_time)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
  end
end