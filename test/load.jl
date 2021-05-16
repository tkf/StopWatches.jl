try
    using StopWatchesTests
    true
catch
    false
end || begin
    push!(LOAD_PATH, joinpath(@__DIR__, "StopWatchesTests"))
    using StopWatchesTests
end
