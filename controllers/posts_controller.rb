class PostsController < Sinatra::Base # Base is a module, so think of it as a mini class, so its a package we can make to do things and this is what allows us to use the http verbs

  # This brings in the reloader
  configure :development do
    register Sinatra::Reloader
  end


  # This brings in the ERB, so it uses the template and brings it in directly to the controller

  #Sets path before the ERB so it would do .. then go to Views
  # set root as the parent directory of the current file
  set :root, File.join(File.dirname(__FILE__), '..')

  # sets the view directory correctly
  set :Views, Proc.new { File.join(root, "Views") }

  # $ can be used anywhere as it is a global variable, use sparingly
  $posts = [
    {
      :id => 0,
      :title => "Post 1",
      :body => "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    },
    {:id => 1,
      :title => "Post 2",
      :body => "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    },
    {  :id => 2,
      :title => "Post 3",
      :body => "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    }
  ]

  get '/' do

    @title = "Posts Index"
    @posts = $posts #Bringing in our global variable as a local variable
    erb :"posts/index"

  end

  get "/new" do

    @post = {
      :id => "",
      :title => "",
      :body => ""
    }
    @title = "New Index"
    @posts = $posts #Bringing in our global variable as a local variable
    erb :'posts/new'
  end

  get "/:id" do
    id = params[:id].to_i
    @title = "Show Post"
    @post = $posts[id]
    erb :'posts/show'
  end

  post '/' do

    id = $posts.last[:id] + 1

    new_post = {
      :id => id,
      :title => params[:title],
      :body => params[:body]
    }
    $posts.push new_post
    # Redirect is a get request, so what it means is, do all this then redirect me to /post
    redirect '/'
  end

  put '/:id' do
    # gets id from params
    id = params[:id].to_i
    #gets hash from array
    post = $posts[id]

    post[:title] = params[:title]
    post[:body] = params[:body]

    # Save the new data back in our array
    $posts[id] = post

    redirect '/'

  end

  get "/:id/edit" do
    id = params[:id].to_i
    @post = $posts[id] #Bringing in our global variable as a local variable
    @title = @post[:title]
    erb :'posts/edit'
  end

  delete '/:id' do
    # Get ID
    id = params[:id].to_i
    # Access our Array
    $posts.delete_at id
    # redirect
    redirect "/"
  end

end
