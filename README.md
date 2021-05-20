# StopWatches: Simple intrusive time measurements

StopWatches.jl is like
[TimerOutputs.jl](https://github.com/KristofferC/TimerOutputs.jl) but designed
for thread-friendliness.

## Usage

```julia
julia> using StopWatches

julia> f() = @stopwatch sleep(0.01);

julia> g() = @stopwatch :longer sleep(0.1);

julia> f()

julia> f()

julia> g()
```

The timing can be obtained via, e.g.,

``````julia
2×8 DataFrame
 Row │ average_time  total_time   ncalls  tag     file     line   fullname  pkgid
     │ Quantity…     Quantity…    Int64   Union…  Union…   Int64  Tuple…    Union…
─────┼─────────────────────────────────────────────────────────────────────────────
   1 │  0.0111036 s  0.0222073 s       2          REPL[2]      1  (:Main,)
   2 │  0.101307 s   0.101307 s        1  longer  REPL[3]      1  (:Main,)
``````

## API summary
### Measurement API

* `@stopwatch([tag], code)`: measure the times to execute `code`.
* `StopWatches.clear()`: reset timing counters.

Measurement API is also available from `StopWatchesBase` package.  `StopWatches`
simply re-expose these APIs.

### Analysis API

* `StopWatches.summary()`: display summary data.
* `StopWatches.time_dataframe()`: export summary data as a `DataFrame`.
* `StopWatches.time_table()`: export summary data as a table.
