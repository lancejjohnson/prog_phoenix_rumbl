defmodule Rumbl.VideoController do
  use Rumbl.Web, :controller

  # Allows you to use `Video` instead of `Rumbl.Video`
  alias Rumbl.Video

  plug :scrub_params, "video" when action in [:create, :update]

  @doc """
  Every controller has a default action function that determines the arguments
  passed to the function for the controller action. You can redefine this
  method to change which arguments are passed to each function.

  __MODULE__ expands to the current module. This could have been
  Rumbl.VideoController but using __MODULE__ allows to change the module name
  and not worry about changing that code as well.
  """
  def action(conn, _) do
    apply(
      __MODULE__, # Apply the fn to the current module
      action_name(conn), # Get the action name from the conn to route to the correct action fn
      [conn, conn.params, conn.assigns.current_user] # Pass these arguments to the fns
    )
  end

  def index(conn, _params, user) do
    videos = user|> user_videos |> Repo.all
    render(conn, "index.html", videos: videos)
  end

  @doc """
  Create a Video changeset that includes the user id of the current user so
  that the video is associated with that user.

  This controller is scoped to /manage, which pipes through the
  authenticate_user function, so you can never reach this route without
  having a current_user in the conn.assigns.

  build_assoc returns the struct defined by the association. User is associated
  with :videos by Rumbl.Video, so a %Rumbl.Video{} struct is returned.
  """
  def new(conn, _params, user) do
    changeset = user |> build_assoc(:videos) |> Video.changeset()

    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"video" => video_params}, user) do
    changeset = user |> build_assoc(:videos) |> Video.changeset(video_params)

    case Repo.insert(changeset) do
      {:ok, _video} ->
        conn
        |> put_flash(:info, "Video created successfully.")
        |> redirect(to: video_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, user) do
    video = user |> user_videos |> Repo.get!(id)
    render(conn, "show.html", video: video)
  end

  def edit(conn, %{"id" => id}, user) do
    video = user |> user_videos |> Repo.get!(id)
    changeset = Video.changeset(video)
    render(conn, "edit.html", video: video, changeset: changeset)
  end

  def update(conn, %{"id" => id, "video" => video_params}, user) do
    video = user |> user_videos |> Repo.get!(id)
    changeset = Video.changeset(video, video_params)

    case Repo.update(changeset) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video updated successfully.")
        |> redirect(to: video_path(conn, :show, video))
      {:error, changeset} ->
        render(conn, "edit.html", video: video, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, user) do
    video = user |> user_videos |> Repo.get!(id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(video)

    conn
    |> put_flash(:info, "Video deleted successfully.")
    |> redirect(to: video_path(conn, :index))
  end

  defp user_videos(user), do: assoc(user, :videos)
end
