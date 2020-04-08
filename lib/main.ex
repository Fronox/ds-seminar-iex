defmodule Main do
  @moduledoc """
  Documentation for `Main`.
  """

  @spec par_merge_sort([any]) :: [any]
  def par_merge_sort([el]), do: [el]

  def par_merge_sort(list) do
    {l1, l2} = list |> Enum.split(length(list) |> div(2))
    t1 = Task.async(__MODULE__, :par_merge_sort, [l1])
    t2 = Task.async(__MODULE__, :par_merge_sort, [l2])
    sorted1 = Task.await(t1)
    sorted2 = Task.await(t2)
    merge(sorted1, sorted2)
  end

  @spec seq_merge_sort(list) :: [any]
  def seq_merge_sort([el]), do: [el]

  def seq_merge_sort(list) do
    {l1, l2} = list |> Enum.split(length(list) |> div(2))
    sorted1 = l1 |> seq_merge_sort
    sorted2 = l2 |> seq_merge_sort
    :lists.merge(sorted1, sorted2)
  end

  @spec merge([any], [any]) :: [any]
  @spec merge([any], [any], [any]) :: [any]
  def merge(l1, l2), do: merge(l1, l2, [])
  def merge([], l2, acc), do: acc ++ l2
  def merge(l1, [], acc), do: acc ++ l1
  def merge([h1|t1], [h2|t2], acc) when h1 <= h2, do: merge(t1, [h2|t2], acc ++ [h1])
  def merge([h1|t1], [h2|t2], acc) when h1 > h2, do: merge([h1|t1], t2, acc ++ [h2])

  # mat_mul_iter(M1Row, M2Col) ->
  #   lists:sum([X * Y || {X, Y} <- lists:zip(M1Row, M2Col)]).

  # mat_mul(M1, M2) when length(hd(M1)) == length(M2) ->
  #   mat_mul(M1, M2, [], 1, []).

  # mat_mul([], _, _, _, AccGlob) ->
  #   AccGlob;

  # mat_mul(M1, M2, Acc, Idx, AccGlob) when Idx =< length(hd(M2)) -> % For each column in M2
  #   M1Row = hd(M1),
  #   M2Col = lists:map(fun(M2Row) -> lists:nth(Idx, M2Row) end, M2),
  #   IterRes = mat_mul_iter(M1Row, M2Col),
  #   mat_mul(M1, M2, Acc ++ [IterRes], Idx + 1, AccGlob);

  # mat_mul([_|T1], M2, Acc, _, AccGlob) ->
  #   mat_mul(T1, M2, [], 1, AccGlob ++ [Acc]).

  # mat_test(M1, M2) ->
  #   mat_mul(M1, M2).

  def seq_mat_mul(m1, m2) when length(hd(m1)) == length(m2) do
    seq_mat_mul(m1, m2, [], 0, [])
  end

  defp seq_mat_mul([], _, _, _, accGlob), do: accGlob


  defp seq_mat_mul(m1, m2, acc, idx, accGlob) when idx < length(hd(m2)) do
    m1Row = hd(m1)
    m2Col = m2 |> Enum.map(fn m2Row -> m2Row |> Enum.at(idx) end)
    res = m1Row |> Enum.zip(m2Col) |> Enum.map(fn {a, b} -> a * b end) |> Enum.sum
    seq_mat_mul(m1, m2, acc ++ [res], idx + 1, accGlob)
  end

  defp seq_mat_mul([_|t1], m2, acc, _, accGlob), do: seq_mat_mul(t1, m2, [], 0, accGlob ++ [acc])

  def mat_test() do
    m1 = [
      [1,2,3,4],
      [5,6,7,8],
      [1,1,1,1]
    ]
    m2 = [
      [1, 1],
      [2, 3],
      [3, 4],
      [4, 1]
    ]
    :io.format("~w~n", [seq_mat_mul(m1, m2)])
  end

  @spec main(integer) :: float
  def main(len) do
    # list = 1..len |> Enum.to_list |> Enum.map(fn _ -> Enum.random(1..10) end)
    # IO.puts "Start"
    # {time, sorted} = :timer.tc(__MODULE__, :par_merge_sort, [list])
    # timeMs = time / 1000
    # IO.puts "Taken time: #{timeMs}"
    # timeMs
    mat_test()
  end

end
