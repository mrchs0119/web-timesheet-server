import Ecto.Query
defmodule TimesheetsWeb.SheetController do
  use TimesheetsWeb, :controller

  alias Timesheets.Sheets
  alias Timesheets.Sheets.Sheet
  alias Timesheets.Jobs.Job
  alias Timesheets.Repo
  alias Timesheets.Users


  def index(conn, _params) do
    if (!conn.assigns[:current_user].is_manager) do
      sheets = Sheets.get_sheet_by_user(conn.assigns[:current_user].id)
      render(conn, "index.html", sheets: sheets)
    else
      IO.inspect("is manager") 
      workers = Users.get_users_by_manager_email(conn.assigns[:current_user].email)
      IO.inspect(workers)
     sheets = Enum.concat(Enum.map(workers, fn x->Sheets.get_sheet_by_user(x.id) end))
      IO.inspect(sheets)
      render(conn, "index.html", sheets: sheets)
    end
  end

  def new(conn, _params) do
    changeset = Sheets.change_sheet(%Sheet{tasks: List.duplicate(%Timesheets.Tasks.Task{}, 10)})
    query = from job in Timesheets.Jobs.Job, select: job.jobCode
    jobs_list = Repo.all(query)
    render(conn, "new.html", changeset: changeset, jobs_list: jobs_list)
  end

  def create(conn, %{"sheet" => sheet_params}) do
    case Sheets.create_sheet(sheet_params) do
      {:ok, sheet} ->
        conn
        |> put_flash(:info, "Sheet created successfully.")
        |> redirect(to: Routes.sheet_path(conn, :show, sheet))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    sheet = Sheets.get_sheet!(id)
    render(conn, "show.html", sheet: sheet)
  end

  def edit(conn, %{"id" => id}) do
    sheet = Sheets.get_sheet!(id)
    changeset = Sheets.change_sheet(sheet)
    render(conn, "edit.html", sheet: sheet, changeset: changeset)
  end 

  def get_tasks_params(conn, sheet_params, task, hour, notes) do
     tasks_params = %{}
     if (sheet_params[task] != nil) do

        job_id = Repo.get_by(Timesheet.Jobs.Job, job_code: sheet_params[task]).id
        tasks_params = tasks_params |> Map.put("hours", sheet_params[hour])
			|> Map.put("job_id", job_id)
			|> Map.put("notes", sheet_params[notes])
       tasks_params
    end

  end

  def update(conn, %{"id" => id, "sheet" => sheet_params}) do
    sheet = Sheets.get_sheet!(id)

    case Sheets.update_sheet(sheet, sheet_params) do
      {:ok, sheet} ->
        conn
        |> put_flash(:info, "Sheet updated successfully.")
        |> redirect(to: Routes.sheet_path(conn, :show, sheet))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", sheet: sheet, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    sheet = Sheets.get_sheet!(id)
    {:ok, _sheet} = Sheets.delete_sheet(sheet)

    conn
    |> put_flash(:info, "Sheet deleted successfully.")
    |> redirect(to: Routes.sheet_path(conn, :index))
  end
end
