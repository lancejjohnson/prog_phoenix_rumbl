defmodule Rumbl.WatchView do
  use Rumbl.Web, :view

  # NOTE: Original pattern in the book. Can't get it to match.
  # @id_pattern ~r{^.*(?:youtu\.be/|\w+|v=)(?<id>[^#&?]*)}
  @id_pattern ~r{^.*v=(?<id>[^#&?]*)}

  def player_id(video) do
    @id_pattern
    |> Regex.named_captures(video.url)
    |> get_in(["id"])
  end
end
