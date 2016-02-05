defmodule Rumbl.UserController do
  use Rumbl.Web, :controller
  
  def index(conn, _params) do
    users = Repo.all(Rumbl.User)
    render conn, "index.html", users: users
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(Rumbl.User, id)
    render conn, "show.html", user: user
  end

  def new(conn, _params) do
    # Calls the `changeset` function passing an empty user (i.e. user with only default fields)
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

end
