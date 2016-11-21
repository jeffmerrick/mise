class InviteController < ApplicationController
  before_action :find_user


  def show

    if request.post?
      @invite_user.books.each do |book|
        BookUser.create(user: current_user, book: book) rescue nil
      end

      current_user.books.each do |book|
        BookUser.create(user: @invite_user, book: book) rescue nil
      end

      redirect_to recipes_path, flash: { success: "Recipes shared!" }
    end
  end

  private

  def find_user
    @invite_user = User.find_by_invite_token(params[:invite_token])
    if @invite_user.nil?
      redirect_to root_path
    end
  end
end
