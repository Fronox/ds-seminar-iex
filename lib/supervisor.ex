defmodule SupExample do

  def start_gen_server() do
    children = [
      %{
        id: GSExample,
        start: {GSExample, :start_link, [%{}]}
      }
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
