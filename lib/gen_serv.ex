defmodule GSExample do
  use GenServer

  defp server_name do
    __MODULE__
  end

  # Example:
  # {:ok, pid} = GenServer.start_link(GSTest, %{})
  @impl true
  def init(state) when is_map(state) do
    {:ok, state}
  end

  # Example:
  # GenServer.call(pid, {:get, :all})
  @impl true
  def handle_call({:get, :all}, __from, state) do
    {:reply, state, state}
  end

  # Example:
  # GenServer.call(pid, {:get, :a})
  def handle_call({:get, key}, _from, state) do
    item = state |> Map.get(key)
    {:reply, item, state}
  end

  def handle_call({:get!, key}, _from, state) do
    {:ok, item} = state |> Map.fetch!(key)
    {:reply, item, state}
  end

  def handle_call({:put, key, value}, _from, state) do
    {:reply, :ok, state |> Map.put(key, value)}
  end

  def handle_call({:rm, key}, _from, state) do
    {:reply, :ok, state |> Map.delete(key)}
  end

  def handle_call({:pop, key}, _from, state) do
    {item, new_state} = state |> Map.pop(key)
    {:reply, item, new_state}
  end

  def handle_call(:clean, _from, _state) do
    {:reply, :ok, %{}}
  end

  # Example:
  # GenServer.cast(pid, {:put, :a, 1})
  @impl true
  def handle_cast({:put, key, value}, state) do
    {:noreply, state |> Map.put(key, value)}
  end

  def handle_cast({:rm, key}, state) do
    {:noreply, state |> Map.delete(key)}
  end

  def handle_cast(:clean, _state) do
    {:noreply, %{}}
  end


  def start_link(init_state) when is_map(init_state) do
    GenServer.start_link(server_name(), init_state, name: server_name())
  end

  def all() do
    GenServer.call(server_name(), {:get, :all})
  end

  def get(key) do
    GenServer.call(server_name(), {:get, key})
  end

  def get!(key) do
    GenServer.call(server_name(), {:get!, key})
  end

  def add(key, value) do
    GenServer.call(server_name(), {:put, key, value})
  end

  def add_async(key, value) do
    GenServer.cast(server_name(), {:put, key, value})
  end

  def remove(key) do
    GenServer.call(server_name(), {:rm, key})
  end

  def remove_async(key) do
    GenServer.cast(server_name(), {:rm, key})
  end

  def pop(key) do
    GenServer.call(server_name(), {:pop, key})
  end

  def clean() do
    GenServer.call(server_name(), :clean)
  end

  def clean_async() do
    GenServer.cast(server_name(), :clean)
  end

  def stop() do
    GenServer.stop(server_name())
  end
end
