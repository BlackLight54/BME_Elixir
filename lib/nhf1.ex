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
        checkPartialSolBool(pd, solutions) == :ok
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
    if checkSolBool(pd, solutions) == :ok do

      # IO.puts("Solution:")
      # Khf2.to_external(pd, solutions) |> IO.puts()
      # IO.inspect(solutions)
      # IO.inspect(tents |> Enum.uniq(), label: "tents")
      # IO.inspect(trees, label: "trees")

      # Khf3.checkSolBool(pd, solutions)
      # |> IO.inspect(label: "res")
    end


    {checkSolBool(pd, solutions), solutions}
  end












    defp checkSolBool(pd, ds) do
      {rs, cs, ts} = pd
      {e_rows, e_cols, e_touch} = check_sol(pd, ds)

      if e_rows == %{err_rows: []} and e_cols == %{err_cols: []} and e_touch == %{err_touch: []} and
          length(ts) == length(getTents(pd,ds) |> Enum.uniq())  do
        :ok
      else
        :error
      end
    end

    defp check_sol(pd, ds) do
      tents = getTents(pd, ds)
      # |> IO.inspect(label: "tents")

      err_rows = checkRows(tents, pd)
      err_cols = checkCols(tents, pd)
      err_touch = checkTouch(tents, pd)
      {err_rows, err_cols, err_touch}
    end

    defp getTents(pd, ds) do
      {_rs, _cs, ts} = pd

      if ds != [] do
        for i <- 0..(length(ds) - 1) do
          tree = Enum.at(ts, i)

          case Enum.at(ds, i) do
            :n -> {elem(tree, 0) - 1, elem(tree, 1)}
            :s -> {elem(tree, 0) + 1, elem(tree, 1)}
            :e -> {elem(tree, 0), elem(tree, 1) + 1}
            :w -> {elem(tree, 0), elem(tree, 1) - 1}
          end
        end
      else
        []
      end
    end

    defp checkRows(tents, pd) do
      {rs, _cs, _ts} = pd
      # IO.inspect(tents)
      # IO.inspect(rs)
      %{
        :err_rows =>
          for rowIndex <- 1..length(rs) do
            # IO.puts("i: #{rowIndex}");
            if Enum.at(rs, rowIndex - 1) >= 0 do
              # IO.puts("r: #{Enum.at(rs, rowIndex - 1 )}");
              tentCount = fn tent ->
                if tent == nil or tent == [] do
                  0
                else
                  Enum.count(
                    tents,
                    fn cell ->
                      {r, _c} = cell
                      r == rowIndex
                    end
                  )
                end
              end

              # IO.puts("i: #{rowIndex}, r: #{Enum.at(rs, rowIndex - 1)}, c: #{tentCount.(tents)}")

              if Enum.at(rs, rowIndex - 1) != tentCount.(tents) do
                rowIndex
              end
            end
          end
          |> Enum.reject(fn x -> x == nil end)
      }
    end

    defp checkCols(tents, pd) do
      {_rs, cs, _ts} = pd
      # IO.inspect(tents)
      # IO.inspect(cs)
      %{
        :err_cols =>
          for colIndex <- 1..length(cs) do
            # IO.puts("i: #{colIndex}");
            if Enum.at(cs, colIndex - 1) >= 0 do
              # IO.puts("r: #{Enum.at(cs, colIndex - 1 )}");
              tentCount = fn tent ->
                if tent == nil or tent == [] do
                  0
                else
                  Enum.count(
                    tents,
                    fn cell ->
                      {_r, c} = cell
                      c == colIndex
                    end
                  )
                end
              end

              # IO.puts("i: #{colIndex}, r: #{Enum.at(cs, colIndex - 1)}, c: #{tentCount.(tents)}")

              if Enum.at(cs, colIndex - 1) != tentCount.(tents) do
                colIndex
              end
            end
          end
          |> Enum.reject(fn x -> x == nil end)
      }
    end

    defp checkTouch(tents, pd) do
      {rs, cs, _ts} = pd

      %{
        :err_touch =>
          if tents == nil or tents == [] do
            []
          else
            for tent <- tents do
              {r, c} = tent

              if r > 0 and c > 0 and r < length(rs) + 1 and c < length(cs) + 1 do
                if Enum.member?(tents, {r - 1, c - 1}) or
                     Enum.member?(tents, {r - 1, c}) or
                     Enum.member?(tents, {r - 1, c + 1}) or
                     Enum.member?(tents, {r, c - 1}) or
                     Enum.member?(tents, {r, c + 1}) or
                     Enum.member?(tents, {r + 1, c - 1}) or
                     Enum.member?(tents, {r + 1, c}) or
                     Enum.member?(tents, {r + 1, c + 1}) do
                  tent
                end
              end
            end
            |> Enum.filter(fn x -> x != nil end)
          end
      }
    end

    def checkPartialSolBool(pd, ds) do
      {rs, cs, ts} = pd
      {e_rows, e_cols, e_touch} = checkPartialSol(pd, ds)

      if e_rows == %{err_rows: []} and e_cols == %{err_cols: []} and e_touch == %{err_touch: []} and length(ds) == length(getTents(pd,ds) |> Enum.uniq()) do
        :ok
      else
        :error
      end
    end

    def checkPartialSol(pd, ds) do
      tents = getTents(pd, ds)
      # |> IO.inspect(label: "tents")

      err_rows = checkPartialRows(tents, pd)
      err_cols = checkPartialCols(tents, pd)
      err_touch = checkTouch(tents, pd)
      {err_rows, err_cols, err_touch}
    end

    defp checkPartialRows(tents, pd) do
      {rs, _cs, _ts} = pd

      %{
        :err_rows =>
          for rowIndex <- 1..length(rs) do
            # IO.puts("i: #{rowIndex}");
            if Enum.at(rs, rowIndex - 1) >= 0 do
              # IO.puts("r: #{Enum.at(rs, rowIndex - 1 )}");
              tentCount = fn tent ->
                if tent == nil or tent == [] do
                  0
                else
                  Enum.count(
                    tents,
                    fn cell ->
                      {r, _c} = cell
                      r == rowIndex
                    end
                  )
                end
              end

              # IO.puts("i: #{rowIndex}, r: #{Enum.at(rs, rowIndex - 1)}, c: #{tentCount.(tents)}")

              if Enum.at(rs, rowIndex - 1) < tentCount.(tents) do
                rowIndex
              end
            end
          end
          |> Enum.reject(fn x -> x == nil end)
      }
    end

    defp checkPartialCols(tents, pd) do
      {_rs, cs, _ts} = pd
      # IO.inspect(tents)
      # IO.inspect(cs)
      %{
        :err_cols =>
          for colIndex <- 1..length(cs) do
            # IO.puts("i: #{colIndex}");
            if Enum.at(cs, colIndex - 1) >= 0 do
              # IO.puts("r: #{Enum.at(cs, colIndex - 1 )}");
              tentCount = fn tent ->
                if tent == nil or tent == [] do
                  0
                else
                  Enum.count(
                    tents,
                    fn cell ->
                      {_r, c} = cell
                      c == colIndex
                    end
                  )
                end
              end

              # IO.puts("i: #{colIndex}, r: #{Enum.at(cs, colIndex - 1)}, c: #{tentCount.(tents)}")

              if Enum.at(cs, colIndex - 1) < tentCount.(tents) do
                colIndex
              end
            end
          end
          |> Enum.reject(fn x -> x == nil end)
      }
    end











end
