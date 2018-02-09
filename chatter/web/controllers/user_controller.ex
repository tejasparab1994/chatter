defmodule Chatter.UserController do
	use Chatter.Web, :controller

	alias Chatter.User

    def index(conn, _params) do
      users = Repo.all(User)
      render(conn, "index.html", users: users)
    end

    def show(conn, %{"id" => id}) do
      user = Repo.get!(User, id)
      render(conn, "show.html", user: user)
  	end

  	def new(conn, _params) do
      changeset = User.changeset(%User{})
      render(conn, "new.html", changeset: changeset)
  	end

    def create(conn, %{"user" => user_params}) do
      #passing connection and user
      #coming from model, empty user and populating with user params
        changeset = User.changeset(%User{}, user_params)

        #if changeset that comes from controller satisfies the rules of
        # changeset model then inserted into db
        case Repo.insert(changeset) do
          {:ok, _user} ->
            conn  #pass connection and put flash message
            |> put_flash(:info, "User created successfully.")   #redirect to user index
            |> redirect(to: user_path(conn, :index)) #rerender the new.html in case of error and reset the email pass fields
          {:error, changeset} ->
            render(conn, "new.html", changeset: changeset)
      end
    end

    def edit(conn, %{"id" => id}) do
      #pull user out of the db with id
      user = Repo.get!(User, id)
      #create shape of the model we pass to
      changeset = User.changeset(user)
      #pass user and changeset to edit.html and render edit.html
      #form will have user id already, but password will be update
      render(conn, "edit.html", user: user, changeset: changeset)
  	end
    #user_params coming from the form
  	def update(conn, %{"id" => id, "user" => user_params}) do
      user = Repo.get!(User, id)
      #create the changeset and populate it with user params
      changeset = User.changeset(user, user_params)

      #we want to see if user_params fit our changeset
      case Repo.update(changeset) do
        {:ok, user} ->
          conn
          |> put_flash(:info, "User updated successfully.")
          |> redirect(to: user_path(conn, :show, user)) #redirect to user_path show
        {:error, changeset} ->
          render(conn, "edit.html", user: user, changeset: changeset) #else rerender edit.html
      end
  	end

  	def delete(conn, %{"id" => id}) do #call user direct by id
      user = Repo.get!(User, id) #get from repo
      Repo.delete!(user) #delete the user

      conn
      |> put_flash(:danger, "User deleted successfully.")
      |> redirect(to: user_path(conn, :index)) #redirect to index of users
  	end
end
