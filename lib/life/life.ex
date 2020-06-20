defmodule Life.Life do

  # $ elixir -pr lib/life.ex -e 'Life.go( \
  #     input: "priv/grid-penta-decathlon-multi", 
  #     check_cycles: false, \
  #     delay_ms: 80, \
  #     num_gens: 21, \
  #     in_place: true)'

  def process_gen(g) do
    sums =
      do_hrotates(g)
      |> Enum.map(&do_vrotates/1)
      |> flatten_all()
      |> sum_grids()

    threes = find_val(sums, 3)
    fours = find_val(sums, 4)
    four_and_was_alive = find_four_and_was_alive(fours, g)

    decide_alive(threes, four_and_was_alive)
  end

  def do_hrotates(g) do
    Enum.map([-1, 0, 1], &hrotate(g, &1))
  end

  def do_vrotates(g) do
    Enum.map([-1, 0, 1], &vrotate(g, &1))
  end
  
  # Rows shift to the right
  def hrotate(g, -1) do
    Enum.map(g, fn(r) -> [0] ++ List.delete_at(r, -1) end)
  end

  # Rows shift to the left
  def hrotate(g, 1) do
    Enum.map(g, fn(r) -> List.delete_at(r, 0) ++ [0] end)
  end

  # Rows stay the same
  def hrotate(g, 0) do
    g
  end

  ###
  # Columns shift down
  def vrotate(g, -1) do
    [List.duplicate(0, length(hd(g)))]
    ++ List.delete_at(g, -1)
  end

  # Columns shift up
  def vrotate(g, 1) do
    List.delete_at(g, 0)
    ++ [List.duplicate(0, length(hd(g)))]
  end

  # Columns stay the same
  def vrotate(g, 0) do
    g
  end

  ###

  def flatten_all(gs) do
    gs
    |> List.foldl([], fn(r, acc) ->
      List.foldl(r, acc, fn(c, acc) ->
        [c | acc]
      end)
    end)
  end

  # Processing 2 grids at a time
#  def sum_grids(gs) do
#    Enum.reduce(gs, fn(g, acc) ->
#      process_grids_2(g, acc, &+/2)
#    end)
#  end
  # Processing n grids together
  def sum_grids(gs) do
    process_grids_n(gs, &+/2)
  end

  defp find_val(g, val) do
    Enum.map(g, &Enum.map(&1, fn(n) -> if n == val, do: 1, else: 0 end))
  end

  defp find_four_and_was_alive(g1, g2) do
    process_grids_2(g1, g2, &Bitwise.band/2)
  end

  defp decide_alive(g1, g2) do
    process_grids_2(g1, g2, &Bitwise.bor/2)
  end

  # g1: [ [1,2,3], [4,5,6], [7,8,9], [10,11,12] ]
  # g2: [ [101,102,103], [104,105,106], [107,108,109], [110,111,112] ]
  #
  # After step 1:
  # [
  #   {[1,2,3], [101,102,103]}, # Number of lists here = number of grids passed in
  #   {[4,5,6], [104,105,106]},
  #   {[7,8,9], [107,108,109]),
  #   {[10,11,12], [110,111,112]}
  # ]
  # After step 2:
  # [
  #   [ {1,101}, {2,102} , {3,103} ], # Number of tuples here = number of grids passed in
  #   [ {4,104}, {5,105}, {6,106}],
  #   [ {7,107}, {8,108}, {9,109}],
  #   [ {10,110}, {11,111}, {12,112}]
  # ]
  # After step 3 (when fun == &+/2):
  # [
  #   [102, 104, 106],
  #   [108, 110, 112],
  #   [114, 116, 118],
  #   [120, 122, 124]
  # ]
  # For 2 input lists
  def process_grids_2(g1, g2, fun) do
    Enum.zip(g1, g2)
    |> Enum.map(fn({l1, l2}) -> Enum.zip(l1, l2) end)
    |> Enum.map(&Enum.map(&1, fn({a1, a2}) -> fun.(a1, a2) end))
  end
  # For n input lists
  def process_grids_n(gs, fun) do
    Enum.zip(gs)
    |> Enum.map(fn(t) -> Enum.zip(Tuple.to_list(t)) end)
    |> Enum.map(&Enum.map(&1, fn(t) -> Enum.reduce(Tuple.to_list(t), fun) end))
  end

  @sq "\u2588"
  @sp " "
  
  # Bold
  #@tl "\u250f"
  #@tr "\u2513"
  #@bl "\u2517"
  #@br "\u251b"
  #@hz "\u2501"
  #@vt "\u2503"

  # Not bold
  @tl "\u250c"
  @tr "\u2510"
  @bl "\u2514"
  @br "\u2518"
  @hz "\u2500"
  @vt "\u2502"
  
  def out_grid(g) do
    out = Enum.map(g, fn(r) ->
      Enum.map(r, fn
        (1) -> @sq
        (0) -> @sp
      end)
      |> Enum.join("")
    end)

    horizontal = List.duplicate(@hz, length(hd(g))) |> Enum.join("")
    
    IO.puts(@tl <> horizontal <> @tr)
    Enum.each(out, &(IO.puts(@vt <> &1 <> @vt)))
    IO.puts(@bl <> horizontal <> @br)
  end

  ###
  def grid(:demo) do
    [
      [0, 0, 0, 0, 1, 1, 0],
      [0, 0, 1, 1, 0, 0, 0],
      [0, 1, 1, 0, 0, 1, 1],
      [1, 0, 1, 0, 1, 0, 0],
      [0, 0, 1, 0, 0, 1, 0],
      [0, 1, 1, 0, 0, 1, 0],
      [1, 0, 1, 0, 0, 1, 0]
    ]
  end

  def grid(:blinker) do
    [
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 1, 1, 1, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0]
    ]
  end

  def grid(invalid), do: raise("Invalid input: '#{invalid}")

  ###
  @default_opts [input: :demo, in_place: true, delay_ms: 500, check_cycles: false, num_gens: 10]
  
  def go(opts \\ @default_opts)
  def go(opts) do
    opts = Keyword.merge(@default_opts, opts)
    
    seen = if Keyword.get(opts, :check_cycles), do: MapSet.new(), else: nil
    
    run(
      get_grid(Keyword.get(opts, :input)), 
      Keyword.get(opts, :in_place),
      Keyword.get(opts, :delay_ms),
      seen,
      Keyword.get(opts, :num_gens))
  end

  #def get_grid(:demo), do: grid()
  def get_grid(name) when is_atom(name), do: grid(name)
  def get_grid(filename) do
    File.read!(filename) 
    |> String.replace(".", "0") 
    |> String.replace("x", "1") 
    |> String.split("\n", trim: true) 
    |> Enum.map(&String.split(&1, "", trim: true)) 
    |> Enum.map(&Enum.map(&1, fn(s) -> String.to_integer(s) end))
  end

  defp run(g, in_place, delay_ms, seen, n \\ 0, num_gens)
  defp run(_g, _in_place, _delay_ms, _seen, n, num_gens) when n >= num_gens, do: :ok
  defp run(g, in_place, delay_ms, seen, n, num_gens) do
    if n > 0 and in_place do
      rows_up = length(g) + 2
      IO.write("#{IO.ANSI.cursor_up(rows_up)}")
    end
      
    out_grid(g)
    
    seen =
      case seen do
        nil ->
          nil
        seen ->
          hash = :crypto.hash(:md5, :erlang.term_to_binary(g)) |> Base.encode64()

          if not MapSet.member?(seen, hash) do
            MapSet.put(seen, hash)
          else
            to_right = length(hd(g)) + 3
            IO.puts("#{IO.ANSI.cursor_up()}#{IO.ANSI.cursor_right(to_right)}Found cycle at gen #{n + 1}")
            nil
          end
      end

      # Checking for an infinite num_gens value (e.g., -1) could be added, instead of having to 
      # just use a very large number
    next =
      if n < num_gens - 1 do
        # This isn't the last recurse
        Process.sleep(delay_ms)
        process_gen(g)
      else
        nil
      end

#    if next != g do
#      run(next, in_place, delay_ms, seen, n + 1, num_gens)
#    else
#      :ok # Next gen is same as current, so quit
#    end

    run(next, in_place, delay_ms, seen, n + 1, num_gens)
  end

end

#Life.go()
