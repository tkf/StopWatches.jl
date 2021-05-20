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

include("utils.jl")
include("conversions.jl")

end  # module Implementations

Implementations.define_docstrings()

end  # baremodule StopWatches
