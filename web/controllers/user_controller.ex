defmodule Rumbl.UserController do

  use Rumbl.Web, :controller
  alias Rumbl.Auth
  alias Rumbl.Repo
  alias Rumbl.User

  # A function plug is any function that accepts a conn and opts and returns a
  # conn. Rumbl.Auth.authenticate_user is such a function. It is included in
  # the Rumbl.Web.controller definition. We can call this function via `plug`
  # instead of calling it in individual functions within this controller
  # because it is available to the controller and meets the plug function
  # definition.
  plug :authenticate_user when action in [:index, :show]

  def index(conn, _params) do
    users = Repo.all(User)
    render conn, "index.html", users: users
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    render conn, "show.html", user: user
  end

  def new(conn, _params) do
    # Calls the `changeset` function passing an empty user (i.e. user with only default fields)
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> Auth.login(user)
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

end
