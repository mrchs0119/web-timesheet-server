# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Timesheet.Repo.insert!(%Timesheet.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Timesheets.Repo
alias Timesheets.Jobs.Job

#Repo.insert!(%User{name: "Alice", email: "alice@example.com"})
#Repo.insert!(%User{name: "Bob", email: "bob@example.com"})

Repo.insert!(%Job{jobCode: "VAOR-01", hours: 20, name: "Cyborg Arm", desc: "This is Job1.", user_id: 1})
Repo.insert!(%Job{jobCode: "VAOR-02", hours: 45, name: "Sobriety Pill", desc: "This is Job2.", user_id: 2})
Repo.insert!(%Job{jobCode: "VAOR-03", hours: 12, name: "Rat Cancer", desc: "This is Job3.", user_id: 2})
