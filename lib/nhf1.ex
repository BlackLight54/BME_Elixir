defmodule Nhf1 do
  @moduledoc """
  Kemping
  @author "Egyetemi Hallgató <egy.hallg@dp.vik.bme.hu>"
  @date   "2022-10-15"
  ...
  """

  # sor száma (1-től n-ig)
  @type row :: integer
  # oszlop száma (1-től m-ig)
  @type col :: integer
  # egy parcella koordinátái
  @type field :: {row, col}

  # a sátrak száma soronként
  @type tents_count_rows :: [integer]
  # a sátrak száma oszloponként
  @type tents_count_cols :: [integer]

  # a fákat tartalmazó parcellák koordinátái lexikálisan rendezve
  @type trees :: [field]
  # a feladványleíró hármas
  @type puzzle_desc :: {tents_count_rows, tents_count_cols, trees}

  # a sátorpozíciók iránya: north, east, south, west
  @type dir :: :n | :e | :s | :w
  # a sátorpozíciók irányának listája a fákhoz képest
  @type tent_dirs :: [dir]

  @spec satrak(pd :: puzzle_desc) :: tss :: [tent_dirs]
  # tss a pd feladványleíróval megadott feladvány összes megoldásának listája, tetszőleges sorrendben

  def satrak(pd) do
    {tents_count_rows, tents_count_cols, trees} = pd
    [traverse_solution_graph(pd, trees, 0, [], [])]
    |> List.flatten()
    |> Enum.filter(fn x -> x != nil end)
    |> Enum.filter(fn {res, _} -> res == :ok end)
    |> Enum.map(fn {_res, dirs} -> dirs end)

  end

  defp traverse_solution_graph(pd, [curr_tree | tail_trees], solTreeDepth, solutions, tents) do
    {tents_count_rows, tents_count_cols, trees} = pd
    {curr_row, curr_col} = curr_tree

    # IO.inspect(curr_tree)
    # IO.puts("solTreeDepth: #{solTreeDepth}\n")
    if(
      length(solutions) == length(Enum.uniq(tents)) and
        Khf3.checkPartialSolBool(pd, solutions) == :ok
    ) do
      # case solTreeDepth |> rem(4) do
      # 0 ->

      northN = if curr_row > 1 do
        traverse_solution_graph(
          pd,
          tail_trees,
          solTreeDepth + 1,
          solutions ++ [:n],
          tents ++ [{curr_row - 1, curr_col}]
        )
      end

      # 1 ->
      southN = if(curr_row < length(tents_count_rows)) do
        traverse_solution_graph(
          pd,
          tail_trees,
          solTreeDepth + 1,
          solutions ++ [:s],
          tents ++ [{curr_row + 1, curr_col}]
        )
      end

      # 2 ->
      eastN = if curr_col < length(tents_count_cols) do
        traverse_solution_graph(
          pd,
          tail_trees,
          solTreeDepth + 1,
          solutions ++ [:e],
          tents ++ [{curr_row, curr_col + 1}]
        )
      end
      # 3 ->
      westN = if curr_col > 1 do
        traverse_solution_graph(
          pd,
          tail_trees,
          solTreeDepth + 1,
          solutions ++ [:w],
          tents ++ [{curr_row, curr_col - 1}]
        )
      end
      [northN, southN, eastN, westN]
      # end
    end

  end

  defp traverse_solution_graph(pd, [], solTreeDepth, solutions, tents) do
    {tents_count_rows, tents_count_cols, trees} = pd
    if Khf3.checkSolBool(pd, solutions) == :ok do

      IO.puts("Solution:")
      Khf2.to_external(pd, solutions) |> IO.puts()
      IO.inspect(solutions)
      IO.inspect(tents |> Enum.uniq(), label: "tents")
      IO.inspect(trees, label: "trees")

      Khf3.checkSolBool(pd, solutions)
      |> IO.inspect(label: "res")
    end


    {Khf3.checkSolBool(pd, solutions), solutions}
  end
end
