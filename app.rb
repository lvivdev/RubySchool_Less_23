#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

configure do
  enable :sessions
end

helpers do
  def username
    session[:identity] ? session[:identity] : "#{@username}"
  end

end

before '/login/form/*' do
  unless session[:identity]
    session[:previous_url] = request.path
    @error = 'Sorry, you need to be logged in to visit ' + request.path
    halt erb(:login_form)
  end
end

get '/' do
	erb "Мы приветствуем Вас в нашем Barber Shop! Осмотритесь тут пока)"		
end

get '/login/form' do
  erb :login_form
end

post '/login/attempt' do
	@username = params[:username]
	@pass = params[:pass]

	if @username == 'admin' && @pass == 'pass'
				session[:identity] = @username
				where_user_came_from = session[:previous_url] || '/'
				redirect to where_user_came_from
				
	else erb :login_form

	end

end

get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end

post '/visit' do
	@username = params[:username]
	@usermail = params[:usermail]
	@userphone = params[:userphone]
	@date_time = params[:date_time]
	@barber = params[:barber]

	f = File.open './public/users.txt', 'a'
	f.write "Barber: #{@barber} for User: #{@username}, Mail: #{@usermail}, Phone: #{@userphone}, Date and time: #{@date_time}"
	f.close

	erb "Будем ждать вас, #{@username.strip.capitalize} к #{@date_time}!"
end

get '/contacts' do
	erb :contacts
end

post '/contacts' do
	@user_name = params[:user_name]
	@user_mail = params[:user_mail]
	@user_message = params[:user_message]

	c = File.open './public/contacts.txt', 'a'
	c.write "User: #{@user_name}, Mail: #{@user_mail}, Message: #{@user_message} "
	c.close

	erb :contacts
end

get '/logout' do
  session.delete(:identity)
  erb "<div class='alert alert-message'>Logged out</div>"
end

