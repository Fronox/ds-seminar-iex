defmodule SupExample do
  use Supervisor

  @impl true
  def init(init_arg) do
    children = [
      %{
        id: GSExample,
        start: {GSExample, :start_link, [init_arg]}
      }
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end
end
