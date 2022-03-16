class UserAuthenticationController < ApplicationController
  # Uncomment this if you want to force users to sign in before any other actions
  # skip_before_action(:force_user_sign_in, { :only => [:sign_up_form, :create, :sign_in_form, :create_cookie] })

  def index
    matching_users = User.all

    @list_of_users = matching_users.order({ :created_at => :desc })

    render({ :template => "user_authentication/index.html.erb" })
  end

  def show
    the_username = params.fetch("username")

    matching_user = User.where({ :username => the_username })

    @the_user = matching_user.at(0)



    if @current_user != nil 
      
      if @the_user.username == @current_user.username 
        render({ :template => "user_authentication/show.html.erb" })
      else 

      
        current_user_follow_request = FollowRequest.where({ :recipient_id => @the_user.id, :sender_id => @current_user.id })
        the_follow_request = current_user_follow_request.at(0)
        if @the_user.private == true
        
          if the_follow_request == nil 
            redirect_to("/users", {:alert => "You're not authorized for that."}) 
          elsif the_follow_request.status == "pending" 
            redirect_to("/users", {:alert => "You're not authorized for that."})
          elsif the_follow_request.status == "accepted"  
            render({ :template => "user_authentication/show.html.erb" })
          elsif the_follow_request.status == "rejected" 
            redirect_to("/users", {:alert => "You're not authorized for that."})
          end 

        elsif @the_user.private == false
          render({ :template => "user_authentication/show.html.erb" })
        end
      end

    else
      redirect_to("/user_sign_in", {:alert => "You have to sign in first."}) 
    end

  end


  def sign_in_form
    render({ :template => "user_authentication/sign_in.html.erb" })
  end

  def create_cookie
    user = User.where({ :email => params.fetch("query_email") }).first
    
    the_supplied_password = params.fetch("query_password")
    
    if user != nil
      are_they_legit = user.authenticate(the_supplied_password)
    
      if are_they_legit == false
        redirect_to("/user_sign_in", { :alert => "Incorrect password." })
      else
        session[:user_id] = user.id
      
        redirect_to("/", { :notice => "Signed in successfully." })
      end
    else
      redirect_to("/user_sign_in", { :alert => "No user with that email address." })
    end
  end

  def destroy_cookies
    reset_session

    redirect_to("/", { :notice => "Signed out successfully." })
  end

  def sign_up_form
    render({ :template => "user_authentication/sign_up.html.erb" })
  end

  def create
    @user = User.new
    @user.email = params.fetch("query_email")
    @user.password = params.fetch("query_password")
    @user.password_confirmation = params.fetch("query_password_confirmation")
    @user.comments_count = params.fetch("query_comments_count")
    @user.likes_count = params.fetch("query_likes_count")
    @user.private = params.fetch("query_private", false)
    @user.username = params.fetch("query_username")

    save_status = @user.save

    if save_status == true
      session[:user_id] = @user.id
   
      redirect_to("/", { :notice => "User account created successfully."})
    else
      redirect_to("/user_sign_up", { :alert => @user.errors.full_messages.to_sentence })
    end
  end
    
  def edit_profile_form
    render({ :template => "user_authentication/edit_profile.html.erb" })
  end

  def update
    @user = @current_user
    @user.email = params.fetch("query_email")
    @user.password = params.fetch("query_password")
    @user.password_confirmation = params.fetch("query_password_confirmation")
    @user.comments_count = params.fetch("query_comments_count")
    @user.likes_count = params.fetch("query_likes_count")
    @user.private = params.fetch("query_private", false)
    @user.username = params.fetch("query_username")
    
    if @user.valid?
      @user.save

      redirect_to("/", { :notice => "User account updated successfully."})
    else
      render({ :template => "user_authentication/edit_profile_with_errors.html.erb" , :alert => @user.errors.full_messages.to_sentence })
    end
  end

  def destroy
    @current_user.destroy
    reset_session
    
    redirect_to("/", { :notice => "User account cancelled" })
  end

  def liked_photos  

    the_username = params.fetch("username")

    matching_user = User.where({ :username => the_username })

    @the_user = matching_user.at(0)

    render({ :template => "user_authentication/liked_photos.html.erb" })

 
  end

  def feed
    the_username = params.fetch("username")

    matching_user = User.where({ :username => the_username })

    @the_user = matching_user.at(0)

    render({ :template => "user_authentication/feed.html.erb" })

  end

  def discover

    the_username = params.fetch("username")

    matching_user = User.where({ :username => the_username })

    @the_user = matching_user.at(0)

    render({ :template => "user_authentication/discover.html.erb" })


  end



 
end
