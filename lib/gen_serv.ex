defmodule GSTest do
  use GenServer

  @impl true
  def init(:arg) do
    :pass
  end

  @impl true
  def handle_call(:msg, from, :state) do
    :pass
  end

  @impl true
  def handle_cast(:msg, :state) do
    :pass
  end
end
