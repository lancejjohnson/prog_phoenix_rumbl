defmodule Rumbl.WatchViewTest do
  use Rumbl.ModelCase
  alias Rumbl.WatchView

  test "player_id/1 captures id of youtube video" do
    expected_id = "_WgrfEaAM4Y"
    video = %{url: "https://www.youtube.com/watch?v=#{expected_id}"}

    assert WatchView.player_id(video) == expected_id
  end
end
