defmodule Rumbl.VideoController do
  use Rumbl.Web, :controller

  # Allows you to use `Video` instead of `Rumbl.Video`
  alias Rumbl.Video

  plug :scrub_params, "video" when action in [:create, :update]

  def index(conn, _params) do
    videos = Repo.all(Video)
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
  def new(conn, _params) do
    changeset =
      conn.assigns.current_user
      |> build_assoc(:videos)
      |> Video.changeset()

    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"video" => video_params}) do
    changeset =
      conn.assigns.current_user
      |> build_assoc(:videos)
      |> Video.changeset(video_params)

    case Repo.insert(changeset) do
      {:ok, _video} ->
        conn
        |> put_flash(:info, "Video created successfully.")
        |> redirect(to: video_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    video = Repo.get!(Video, id)
    render(conn, "show.html", video: video)
  end

  def edit(conn, %{"id" => id}) do
    video = Repo.get!(Video, id)
    changeset = Video.changeset(video)
    render(conn, "edit.html", video: video, changeset: changeset)
  end

  def update(conn, %{"id" => id, "video" => video_params}) do
    video = Repo.get!(Video, id)
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

  def delete(conn, %{"id" => id}) do
    video = Repo.get!(Video, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(video)

    conn
    |> put_flash(:info, "Video deleted successfully.")
    |> redirect(to: video_path(conn, :index))
  end
end
