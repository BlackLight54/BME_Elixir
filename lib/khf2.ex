defmodule Khf2 do
  @moduledoc """
  Kemping térképe
  @author "Farkas Martin <fmartin0120@gmail.com>"
  @date   "2022-09-30"
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

  @spec to_external(pd :: puzzle_desc, ds :: tent_dirs, file :: String.t()) :: :ok
  # A pd = {rs, cs, ts} feladványleíró és a ds sátorirány-lista alapján
  # a feladvány szöveges ábrázolását írja ki a file fájlba, ahol
  #   rs a sátrak soronkénti számának a listája,
  #   cs a sátrak oszloponkénti számának a listája,
  #   ts a fákat tartalmazó parcellák koordinátájának listája

  def to_external(pd, ds, file) do
    File.rm(file)
    {:ok, file} = File.open(file, [:write])
    {rs, cs, _ts} = pd

    matrix =
      createMatrix(pd)
      |> delUnusable(pd)
      |> placeTrees(pd)
    #IO.inspect(matrix)
     IO.binwrite(file, createFile(pd, matrix))
  end

  defp createMatrix(pd) do
    {rs, cs, _ts} = pd

    for i <- 1..length(rs) do
      for j <- 1..length(cs) do
        # Enum.join([i, j], ",")
        "-"
      end
    end
  end

  defp delUnusable(matrix, pd) do
    {rs, cs, ts} = pd

    for i <- 1..length(rs) do
      for j <- 1..length(cs) do
        if Enum.at(rs, i - 1 ) == 0 do
          "x"
        else
          if Enum.at(cs, j - 1) == 0 do
            "x"
          else
            "-"
          end
        end
      end
    end
  end

  defp placeTrees(matrix, pd) do
    {rs, cs, ts} = pd
    for r <- 1..length(rs) do
      for c <- 1..length(cs) do
        if Enum.member?(ts, {r, c}) do
          "*"
        else
                 getField(matrix, pd ,c,r )
        end
      end
    end
  end
  defp getField(matrix, pd, x, y) do
    {rs, cs, ts} = pd

    Enum.at(matrix, y - 1)
    |> Enum.at(x - 1)
  end
  defp placeTents(pd, ds) do
    for tent <- ds do
    end
  end

  defp createFile(pd, matrix) do
    {rs, cs, _ts} = pd

    ([Enum.join([" "] ++ cs, " ")] ++
       for ri <- 1..length(rs) do
         ([Enum.at(rs, ri - 1)] ++
            Enum.at(matrix, ri - 1))
         |> Enum.join(" ")
       end)
    |> Enum.join("\n")
  end
end
