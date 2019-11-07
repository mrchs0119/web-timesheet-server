defmodule Timesheets.Sheets.Sheet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sheets" do
    field :date, :date
    field :status, :string
    belongs_to :user, Timesheets.Users.User, foreign_key: :worker_id
    has_many :tasks, Timesheets.Tasks.Task

    timestamps()
  end

  @doc false
  def changeset(sheet, attrs) do
     if (attrs["tasks"] == nil || valid_hours(attrs)) do
    sheet
    |> cast(attrs, [:date, :status, :worker_id])
    |> cast_assoc(:tasks, required: true)
    |> validate_required([:date, :worker_id])
   else
      sheet
    |> cast(attrs, [:date, :status, :worker_id])
    |> validate_required([:date, :status, :worker_id])
   end
  end

  def valid_hours(attrs) do
    if (attrs["tasks"] == nil) do
       IO.inspect("nil")
       false
       
    end 
    ret = attrs["tasks"] 
	|> Map.values()
	|> Enum.map(fn x->x["hours"] end)
    	|> Enum.map(fn x ->{n, ""} = Integer.parse(x); n end)
        |> Enum.reduce(fn(x, acc) ->x+acc end) 

    ret <= 8
   end 
end
