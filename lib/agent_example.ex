defmodule AgentExample do
  use Agent

  def agent_name do
    __MODULE__
  end

  def start_link({:initial, state}) when is_map(state) do
    Agent.start_link(fn -> state end, name: agent_name())
  end

  def start_link() do
    Agent.start_link(fn -> %{} end, name: agent_name())
  end

  def all() do
    Agent.get(agent_name(), & &1)
  end

  def get({:key, key}) do
    Agent.get(agent_name(), fn state -> state |> Map.get(key) end)
  end

  def add(key, value) do
    Agent.update(agent_name(), fn state -> state |> Map.put(key, value) end)
  end

  def remove({:key, key}) do
    Agent.update(agent_name(), fn state -> state |> Map.delete(key) end)
  end

  def pop({:key, key}) do
    {result, new_state} = Agent.get(agent_name(), & Map.pop(&1, key))
    Agent.update(agent_name(), fn _ -> new_state end)
    result
  end

  def clean() do
    Agent.update(agent_name(), fn _ -> %{} end)
  end

  def stop() do
    Agent.stop(agent_name())
  end
end
