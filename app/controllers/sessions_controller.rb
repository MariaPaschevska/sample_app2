class SessionsController < ApplicationController
  def new
  end

  def create
  	# for tets
  	# binding.pry 
  	user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
    # Sign the user in and redirect to the user's show page.

    else
      flash.now[:error] = 'Invalid email/password combination'
       # Create an error message and re-render the signin form.
      render 'new'
    end
  end

  def destroy
  end
end
