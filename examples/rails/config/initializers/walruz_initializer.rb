Walruz.setup do |config|
  
  #
  # Specify which models behave like Actors in your authorization system
  config.actors = [Beatle, Colaboration]
  
  # Specify which models behave like Subjects (default: All of them)
  config.subjects = [ActiveRecord::Base]
  
  ActionController::Base.class_eval do
    
    rescue_from Walruz::NotAuthorized, :with => 'unathorized'
    
    #
    # This method will be called when a user is not authorized. By
    # default it renders a unauthorized template on the public directory
    # with a HTTP status 401 (not authorized)
    def unauthorized(e)
      render :template => 'public/unauthorized.html', :status => 401
    end
    
  end
end