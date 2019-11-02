defmodule Timesheets.Jobs.Job do
  use Ecto.Schema
  import Ecto.Changeset

  schema "jobs" do
    field :desc, :string
    field :hours, :integer
    field :jobCode, :string
    field :name, :string
    belongs_to :user, Timesheets.Users.User
    has_many :tasks, Timesheets.Tasks.Task

    timestamps()
  end

  @doc false
  def changeset(job, attrs) do
    job
    |> cast(attrs, [:desc, :hours, :jobCode, :name])
    |> validate_required([:desc, :hours, :jobCode, :name])
  end
end
