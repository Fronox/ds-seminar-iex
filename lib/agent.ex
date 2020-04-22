defmodule AgentExample do
  defp agent_name do
    __MODULE__
  end

  def start(state) when is_map(state) do
    Agent.start_link(fn -> state end, name: agent_name())
  end

  def start() do
    Agent.start_link(fn -> %{} end, name: agent_name())
  end

  def all() do
    Agent.get(agent_name(), & &1)
  end

  def get(key) do
    Agent.get(agent_name(), fn state -> state |> Map.get(key) end)
  end

  def add(key, value) do
    Agent.update(agent_name(), fn state -> state |> Map.put(key, value) end)
  end

  def add_async(key, value) do
    Agent.cast(agent_name(), fn state -> state |> Map.put(key, value) end)
  end

  def remove(key) do
    Agent.update(agent_name(), fn state -> state |> Map.delete(key) end)
  end

  def remove_async(key) do
    Agent.cast(agent_name(), fn state -> state |> Map.delete(key) end)
  end

  def pop(key) do
    Agent.get_and_update(agent_name(), fn state -> state |> Map.pop(key) end)
  end

  def clean() do
    Agent.update(agent_name(), fn _ -> %{} end)
  end

  def clean_async() do
    Agent.cast(agent_name(), fn _ -> %{} end)
  end

  def stop() do
    Agent.stop(agent_name())
  end
end
