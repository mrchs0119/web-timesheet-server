defmodule Timesheets.Sheets.Sheet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sheets" do
    field :date, :date
    field :status, :string
    field :desc, :string
    belongs_to :user, Timesheets.Users.User, foreign_key: :worker_id
    has_many :tasks, Timesheets.Tasks.Task

    timestamps()
  end

  @doc false
  def changeset(sheet, attrs) do
    sheet
    |> cast(attrs, [:date, :status, :worker_id])
    |> cast_assoc(:tasks, required: true)
    |> validate_required([:date, :worker_id])
  end
end
