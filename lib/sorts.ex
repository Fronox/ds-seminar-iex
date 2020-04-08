defmodule Sorts do

  defp par_merge_sort([el], _), do: [el]

  defp par_merge_sort(list, {:ps, ps_nr, ps_cap}) when ps_nr < ps_cap do
    {l1, l2} = list |> Enum.split(length(list) |> div(2))
    t1 = Task.async(fn -> l1 |> par_merge_sort({:ps, :erlang.system_info(:process_count), ps_cap}) end)
    t2 = Task.async(fn -> l2 |> par_merge_sort({:ps, :erlang.system_info(:process_count), ps_cap}) end)
    sorted1 = t1 |> Task.await
    sorted2 = t2 |> Task.await
    :lists.merge(sorted1, sorted2)
  end

  defp par_merge_sort(list, {:ps, _, ps_cap}) do
    {l1, l2} = list |> Enum.split(length(list) |> div(2))
    sorted1 = l1 |> par_merge_sort({:ps, :erlang.system_info(:process_count), ps_cap})
    sorted2 = l2 |> par_merge_sort({:ps, :erlang.system_info(:process_count), ps_cap})
    :lists.merge(sorted1, sorted2)
  end

  @spec seq_merge_sort(list) :: [any]
  defp seq_merge_sort([el]), do: [el]

  defp seq_merge_sort(list) do
    {l1, l2} = list |> Enum.split(length(list) |> div(2))
    sorted1 = l1 |> seq_merge_sort
    sorted2 = l2 |> seq_merge_sort
    :lists.merge(sorted1, sorted2)
  end

  @spec compare({:arr_len, integer}, {:ps_nr, integer}) :: {{:ms, {:seq, any}, {:par, any}}}
  def compare({:arr_len, len}, {:ps_nr, ps_nr} \\ {:ps_nr, 8}) do
    list = 1..len |> Enum.to_list |> Enum.map(fn _ -> Enum.random(1..10) end)
    {seq_time, _} = :timer.tc(fn -> seq_merge_sort(list) end)
    ps_count = :erlang.system_info(:process_count)
    {par_time, _} = :timer.tc(fn -> par_merge_sort(list, {:ps, ps_count, ps_count + ps_nr}) end)
    seq_time_ms = seq_time / 1000
    par_time_ms = par_time / 1000
    {{:ms, {:seq, seq_time_ms}, {:par, par_time_ms}}}
  end
end
