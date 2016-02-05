defmodule Rumbl.UserView do

  use Rumbl.Web, :view
  alias Rumbl.User

  # Accepts a Rumbl.User, gets the value from :name, calls it name
  def first_name(%User{name: name}) do
    # Pass name through the function pipes
    # Ruby: name.split(" ").at(0)
    name
    |> String.split(" ")
    |> Enum.at(0)
  end

end
