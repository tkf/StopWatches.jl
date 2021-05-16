"""
    StopWatches

Simple intrusive time measurements.

# Measurement API

* `@stopwatch([tag], code)`: measure the times to execute `code`.
* `StopWatches.clear()`: reset timing counters.

Measurement API is also available from `StopWatchesBase` package.  `StopWatches`
simply re-expose these APIs.

# Analysis API

* `StopWatches.summary()`: display summary data.
* `StopWatches.time_dataframe()`: export summary data as a `DataFrame`.
* `StopWatches.time_table()`: export summary data as a table.
"""
baremodule StopWatches

export @stopwatch

using StopWatchesBase: @stopwatch, Time, append_times!, clear

function summary end
function time_dataframe end
function time_table end

module Implementations

using DataFrames: DataFrame
using StopWatchesBase: Time, append_times!, clear
using StructArrays: StructVector
using Tables: Tables
using Unitful: @u_str, uconvert

using ..StopWatches: StopWatches

include("conversions.jl")

end  # module Implementations

end  # baremodule StopWatches
