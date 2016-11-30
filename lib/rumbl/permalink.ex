defmodule Rumbl.Permalink do
  @behaviour Ecto.Type

  def type, do: :id

  # cast/1 is called when external data is passed into Ecto
  # What's the point? In the video controller, the controller recieves the id
  # from the url parameters. Because we are using the video slug as the param
  # instead of the db id of the video, we need to convert the param into the
  # actual id of the resource. The structure of the slug prepends it with the
  # id, so this function gets the id from that string and returns it.
  def cast(binary) when is_binary(binary) do
    case Integer.parse(binary) do
      {int, _} when int > 0 ->
        {:ok, int}
      _ ->
        :error
    end
  end

  def cast(integer) when is_integer(integer) do
    {:ok, integer}
  end

  def cast(_) do
    :error
  end

  # Invoked when data is sent to the db
  def dump(integer) when is_integer(integer) do
    {:ok, integer}
  end

  # Invoked when data is loaded from the db
  def load(integer) when is_integer(integer) do
    {:ok, integer}
  end
end
