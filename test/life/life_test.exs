defmodule Life.LifeTest do
  use ExUnit.Case

  alias Life.Life

  #@moduletag :capture_log
  #doctest Life

  ###
  test "do_hrotates" do
    out = Life.do_hrotates(grid())
    assert out == [grid_right(), grid(), grid_left()]
  end

  test "do_vrotates" do
    out = Life.do_vrotates(grid())
    assert out == [grid_down(), grid(), grid_up()]
  end

  ###
  test "hrotate -1" do
    assert Life.hrotate(grid(), -1) == grid_right()
  end

  test "hrotate 1" do
    assert Life.hrotate(grid(), 1) == grid_left()
  end

  test "hrotate 0" do
    assert Life.hrotate(grid(), 0) == grid()
  end
  
  ###
  test "vrotate -1" do
    assert Life.vrotate(grid(), -1) == grid_down()
  end

  test "vrotate 1" do
    assert Life.vrotate(grid(), 1) == grid_up()
  end

  test "vrotate 0" do
    assert Life.vrotate(grid(), 0) == grid()
  end
  
  ###
  test "read file" do
    actual = Life.get_grid("test/life/sample_grid") # A better way to place a sample file like this?

    expected =
      [
        [0, 0, 0, 0, 1],
        [0, 0, 1, 1, 0],
        [0, 1, 1, 0, 0],
        [1, 0, 1, 0, 1],
        [0, 0, 0, 0, 0]
      ]

      assert actual == expected
  end

  ###
  test "flatten_all" do
    # The grids here are arbitrary- just want to assert they're flattened
    arg = [
      [grid_left(), grid_right()],
      [grid_up(), grid_down()]
    ]

    # flatten_all prepends
    expected = [grid_down(), grid_up(), grid_right(), grid_left()]
    
    assert Life.flatten_all(arg) == expected
  end
  
  ###
  test "sum_grids" do
    # The grids here are arbitrary- just want to assert they're summed
    gs = [grid(), grid_left(), grid_right()]
    expected = [
      [0, 0, 0, 0, 0],
      [0, 1, 2, 2, 1],
      [1, 2, 2, 1, 0],
      [0, 1, 1, 1, 0],
      [0, 0, 0, 0, 0]
    ]
    
    assert Life.sum_grids(gs) == expected
  end
  
  ###
  test "process_grids_2" do
    #    g1 = [
    #      [1, 2, 3],
    #      [4, 5, 6]
    #    ]
    #    g2 = [
    #      [7, 8, 9],
    #      [10, 11, 12]
    #    ]
    #    expected = [
    #      [8, 10, 12],
    #      [14, 16, 18]
    #    ]

    g1 = [ [1,2,3], [4,5,6], [7,8,9], [10,11,12] ]
    g2 = [ [101,102,103], [104,105,106], [107,108,109], [110,111,112] ]
    expected = [ [102, 104, 106], [108, 110, 112], [114, 116, 118], [120, 122, 124] ]

    assert Life.process_grids_2(g1, g2, &+/2) == expected
  end

  test "process_grids_n" do
    g1 = [ [1,2,3], [4,5,6], [7,8,9], [10,11,12] ]
    g2 = [ [101,102,103], [104,105,106], [107,108,109], [110,111,112] ]
    expected = [ [102, 104, 106], [108, 110, 112], [114, 116, 118], [120, 122, 124] ]
    
    assert Life.process_grids_n([g1, g2], &+/2) == expected
  end
    
  ###
  defp grid() do
    [
      [0, 0, 0, 0, 0],
      [0, 0, 1, 1, 0],
      [0, 1, 1, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 0, 0, 0]
    ]
  end

  defp grid_left() do
    [
      [0, 0, 0, 0, 0],
      [0, 1, 1, 0, 0],
      [1, 1, 0, 0, 0],
      [0, 1, 0, 0, 0],
      [0, 0, 0, 0, 0]
    ]
  end

  defp grid_right() do
    [
      [0, 0, 0, 0, 0],
      [0, 0, 0, 1, 1],
      [0, 0, 1, 1, 0],
      [0, 0, 0, 1, 0],
      [0, 0, 0, 0, 0]
    ]
  end

  defp grid_down() do
    [
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 1, 1, 0],
      [0, 1, 1, 0, 0],
      [0, 0, 1, 0, 0]
    ]
  end

  defp grid_up() do
    [
      [0, 0, 1, 1, 0],
      [0, 1, 1, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0]
    ]
  end

end
