defmodule Rumbl.CategoryRepoTest do
  use Rumbl.ModelCase
  alias Rumbl.Category

  test "alphabetical/1 orders by name" do
    for category_name <- ~w(c a b) do
      Repo.insert!(%Category{name: category_name})
    end

    # The query under test
    query = Category |> Category.alphabetical
    # Add to the query to select only the category name
    query = from category in query, select: category.name

    # Assert the names are in alphabetical order
    assert Repo.all(query) == ~w(a b c)
  end
end
