class SessionsController < ApplicationController
  skip_before_action :ensure_signed_in, only: [:create]

  def create
    auth_hash = request.env['omniauth.auth']
    gh_user = GithubUser.new(auth_hash.dig('extra', 'raw_info', 'login'))

    if gh_user.belongs_to_authorized_org?
      user = User.get_or_create_from_omniauth(auth_hash)
      sign_in(user)
      redirect_to projects_path
    else
      flash[:notice] = 'You must be a public member of an authorized GitHub organization to sign in'
      redirect_to root_path
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
