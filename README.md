# Game of Life in Elixir

## Description
Implementation of [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life) in Elixir, based on [a description](https://zverok.github.io/blog/2020-05-16-ruby-as-apl.html) of a conversion of an incredibly terse version in APL to Ruby. In short, we calculate the number of live neighbors of each cell by shifting the grid in each combination of up/down/left/right directions and, in effect, overlaying them and summing the results. Using those sums, then determining the next generation. 

## Execution

Within `IEx`, with default options:  
```
$ iex -S mix
[...]
iex(1)> Life.Life.go()
```

From command line, with default options:  
`$ elixir -pr lib/life/life.ex -e 'Life.Life.go()'`

**Default options:**  
```
[input: :demo,        # `:demo` or path to input file
 in_place: true,      # Draw each generation in-place, or scrolling
 delay_ms: 500,       # Time between generations
 check_cycles: false, # Report if a cycle is found
 num_gens: 10]        # How long to run for
```


## Example

With one of the sample grids in `priv/`:

```
$ elixir -pr lib/life/life.ex -e 'Life.Life.go( \
    input: "priv/grid-penta-decathlon-multi", \
    check_cycles: false, \
    delay_ms: 600, \
    num_gens: 21, \
    in_place: true)'
```

Start:
```
┌──────────────────────────────┐
│                              │
│                              │
│                              │
│                              │
│       █              █       │
│      █ █            █ █      │
│     █   █          █   █     │
│     █   █          █   █     │
│     █   █          █   █     │
│     █   █          █   █     │
│     █   █          █   █     │
│     █   █          █   █     │
│      █ █            █ █      │
│       █              █       │
│                              │
│                              │
│                              │
│                              │
└──────────────────────────────┘
```

After 21 generations:
```
┌──────────────────────────────┐
│                              │
│                              │
│       █              █       │
│      ███            ███      │
│     █ █ █          █ █ █     │
│     █ █ █          █ █ █     │
│      ███            ███      │
│       █              █       │
│                              │
│                              │
│       █              █       │
│      ███            ███      │
│     █ █ █          █ █ █     │
│     █ █ █          █ █ █     │
│      ███            ███      │
│       █              █       │
│                              │
│                              │
└──────────────────────────────┘
```



