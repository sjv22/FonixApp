class FonixAuthController < ApplicationController
    before_action :valid_user!

  def new
    @fonix_auth = FonixAuth.new
    @current_user = current_user
  end

  def create
    @current_user = current_user

    #Using phoneLib to check format of number
    phone = Phonelib.parse fonix_auth_params[:mobile_number]
    unless phone.valid? and phone.type.match(/(mobile)/)
      @fonix_auth = FonixAuth.new
      flash[:error] = "You have entered invalid mobile number. Please try again."
      return redirect_to root_path
    end

    #Generate random 4-digit code
    @fonix_auth = FonixAuth.new(fonix_auth_params)
    generate_random_code = 4.times.map{rand(10)}.join
    @fonix_auth.random_code = generate_random_code
    
    #Open the transaction 
    FonixAuth.transaction do
      #Save the mobile number or render the error page
      if @fonix_auth.save
        #Calling the zendsend api to send the message       
        unless helpers.api_call_to_zensend(@fonix_auth)
          return render_error
        end
      else
        flash[:error] = "Something went wrong. Please try again."
        redirect_to @fonix_auth
      end
    end
    respond_to do |format|
      format.html {
        flash[:success] = 'Please enter your 4-digit activation code.'
        redirect_to edit_fonix_auth_path(@fonix_auth)
      }
      format.json { render :edit, location: @fonix_auth }
    end
  end

  def edit
    @fonix_auth = FonixAuth.find(params[:id])
  end

  def update
    @fonix_auth = FonixAuth.find(params[:id])

    #Checking the token is already used or not
    unless @fonix_auth.is_used.blank?
      flash[:error] = "You have already validated your mobile number."
      return redirect_to edit_fonix_auth_path(@fonix_auth)
    end

    if @fonix_auth.random_code == params[:fonix_auth][:random_code]
      @fonix_auth.update_attribute(:is_used, true)
      flash[:success] = "You have entered valid token. Success!"
      redirect_to root_path
    else
      flash[:error] = "You have entered invalid token. Please try again."
      redirect_to edit_fonix_auth_path(@fonix_auth)
    end
  end

  #Render the error page 
  def render_error
    @fonix_auth.destroy
    flash[:error] = @fonix_auth.errors.full_messages.join(' ')
    return redirect_to root_path
  end

  #Only allow the white list through.
  def fonix_auth_params
    params.require(:mobile_number).permit(:mobile_number, :user_id)
  end
end
