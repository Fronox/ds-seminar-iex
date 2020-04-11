defmodule Main do
  @moduledoc """
  Documentation for `Main`.
  """

  defp seq_mat_mul(m1, m2) when length(hd(m1)) == length(m2) do
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

  defp par_mat_mul(mat1, mat2, PsLim \\ 8) when length(mat1) != 0 and length(mat2) != 0 and length(hd(mat1)) == length(mat2) do
    :pass
  end

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
end
