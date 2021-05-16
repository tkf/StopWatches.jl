module StopWatchesBase

export @stopwatch

using UUIDs: UUID

include("recording.jl")
include("tables.jl")
include("noop.jl")

function __init__()
    init_records()
end

end
