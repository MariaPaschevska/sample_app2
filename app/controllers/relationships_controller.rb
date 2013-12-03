class RelationshipsController < ApplicationController
  before_filter :signed_in_user

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    # redirect_to @user  - not used already because of AJAX respond below:   (AJAX reqest - spec/controllers/relation....)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_to do |format|   
    # выполняется только одна из строк (в зависимости от характера запроса)                
      format.html { redirect_to @user }
      format.js
    end
  end
end