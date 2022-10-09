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
    # File.rm(file)
    # {:ok, file} = File.open(file, [:write])

    to_external(pd,ds)
    |> writeToFile(file)
  end

  def to_external(pd,ds) do
    create_map(pd)
    |> fillMapwTrees(pd)
    |> fillMapwTents(pd, ds)
    |> toMapString(pd)
  end

  defp create_map(pd) do
    {rows, clms, _ts} = pd

    for row <- 1..length(rows), clm <- 1..length(clms), reduce: %{} do
      acc -> Map.put(acc, {row, clm}, "-")
    end
  end

  defp fillMapwTrees(map, pd) do
    {_rows, _clms, ts} = pd
    if ts == [] do
      map
    else

    Enum.reduce(ts, map, fn {row, clm}, acc ->
      Map.put(acc, {row, clm}, "*")
    end)
  end
  end

  defp getTents(pd, ds) do
    {_rs, _cs, ts} = pd

    if ds != [] do
      for i <- 0..(length(ds) - 1) do
        tree = Enum.at(ts, i)

        case Enum.at(ds, i) do
          :n -> %{{elem(tree, 0) - 1, elem(tree, 1)} => "N"}
          :s -> %{{elem(tree, 0) + 1, elem(tree, 1)} => "S"}
          :e -> %{{elem(tree, 0), elem(tree, 1) + 1} => "E"}
          :w -> %{{elem(tree, 0), elem(tree, 1) - 1} => "W"}
        end
      end
      |> Enum.reduce(&Map.merge/2)
    else
      %{}
    end
  end
  defp fillMapwTents(map, pd, ds) do
    {_rows, _clms, _ts} = pd
    tents = getTents(pd, ds)
    Map.merge(map, tents, fn _k, _v1, v2 -> v2 end)
  end

  defp toMapString(map, pd) do
    {rows, clms, _ts} = pd
    "  " <> (
    [ clms |> Enum.join(" ")
      | for row <- 1..length(rows) do
          [
            rows |> Enum.at(row - 1)
            | for clm <- 1..length(clms) do
                map[{row, clm}]
              end
          ]
          |> Enum.join(" ")
        end
    ]
    |> Enum.join("\n"))
  end

  defp writeToFile(string, file) do
    # megnyitjuk
    {:ok, file} = File.open(file, [:write])
    # beleírjuk
    IO.binwrite(file, string)
    IO.write(file, "\r\n")
    # lezárjuk
    File.close(file)
  end
end
