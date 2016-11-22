defmodule Rumbl.Repo.Migrations.AddSlugToVideo do
  use Ecto.Migration

  def change do
    # The alter macro defines schema changes for both up and down migrations
    alter table(:videos) do
      add :slug, :string
    end
  end
end
