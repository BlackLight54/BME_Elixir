defmodule Khf2_mark do

  @moduledoc """
  Kemping térképe
  @author "Molnár Márk - B44W74 <ranlom01@gmail.com>"
  @date   "2022-09-30"
  ...
  """

  @type row   :: integer    # sor száma (1-től n-ig)
  @type col   :: integer    # oszlop száma (1-től m-ig)
  @type field :: {row, col} # egy parcella koordinátái

  @type tents_count_rows :: [integer] # a sátrak száma soronként
  @type tents_count_cols :: [integer] # a sátrak száma oszloponként

  @type trees       :: [field]   # a fákat tartalmazó parcellák koordinátái lexikálisan rendezve
  @type puzzle_desc :: {tents_count_rows, tents_count_cols, trees} # a feladványleíró hármas

  @type dir       :: :n | :e | :s | :w # a sátorpozíciók iránya: north, east, south, west
  @type tent_dirs :: [dir]             # a sátorpozíciók irányának listája a fákhoz képest

  @spec to_external(pd::puzzle_desc, ds::tent_dirs, file::String.t) :: :ok
  # A pd = {rs, cs, ts} feladványleíró és a ds sátorirány-lista alapján
  # a feladvány szöveges ábrázolását írja ki a file fájlba, ahol
  #   rs a sátrak soronkénti számának a listája,
  #   cs a sátrak oszloponkénti számának a listája,
  #   ts a fákat tartalmazó parcellák koordinátájának listája

  def to_external(pd, ds, file) do
    #Kiszedjük az első sort
    first_row = elem(pd,1);

    #Kiszedjük a második sort
    first_col = elem(pd,0);

    #Mapeljük a fákat és a sátrakat
    objectMap=createObjectMap(elem(pd,2), ds, length(elem(pd,1)));

    #Elkészítjük a stringet
    solvationString=createString(objectMap, first_row, first_col);

    #Fileba kiírjuk
    writeToFile(file,solvationString);

  end

  #Itt készítjük el a mappelést
  defp createObjectMap(trees, dirs, row_len) do
    #Ha nincs fa, akkor üres mappel térünk vissza
    if trees==[] do
      %{};
    else
      #Az összes fára megcsináljuk
      for i <- 0..length(trees)-1 do
        tree=Enum.at(trees,i);
        #Fa index kiszámítása
        treeCell= ((elem(tree,0)-1)*row_len)+(elem(tree,1)-1);

        #Sátor index és betű beállítás
        tentCell=case Enum.at(dirs,i) do
          :n -> {treeCell-row_len, "N"};
          :s -> {treeCell+row_len, "S"};
          :e -> {treeCell+1, "E"};
          :w -> {treeCell-1, "W"};
        end

        #mapeljük a megkapott infót
        %{treeCell => "*", elem(tentCell,0)=>elem(tentCell,1)}
        #mergeljük az összes map-et
      end|>Enum.reduce(&Map.merge/2);
    end
  end

  #Elkészítjük a stringet
  defp createString(objectMap, first_row, first_col) do
    col_len=length(first_col);
    row_len=length(first_row);

    #Azoknak a soroknak az elkészítése amit a first_collal kezdődik és a térkép egy sorával végződik
    rows=for i <- 0..col_len-1 do
      #Kiszedjük a számot
      start_num=Enum.at(first_col,i);
      #Elkészítjük a térkép sorát
      row=for j <- (i*row_len)..(((i+1)*row_len)-1)  do
        #Ha van mappelve rá érték akkor azt, ha nem akkor "-"-t adunk vissza
        if Map.has_key?(objectMap, j) do
          objectMap[j];
        else
          "-";
        end
      end
      #Összefűzzük a sort és szétválasztjuk " "-el
      [start_num | row]|>Enum.join(" ");
    end
    #Összefűzzük a sorokat és lezárjük \r\n-el
    [[first_row|>Enum.join(" ")]|rows]|>Enum.join("\r\n");
  end

  #Filbeba írás
  defp writeToFile(file, string) do
    #megnyitjuk
    {:ok, file} = File.open(file, [:write]);
    #beleírjuk
      IO.binwrite(file, string);
      IO.write(file, "\r\n");
      #lezárjuk
      File.close(file);
  end
end
