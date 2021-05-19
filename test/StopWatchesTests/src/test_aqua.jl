module TestAqua

using Aqua
using StopWatches
using StopWatchesBase

function test_stopwatches()
    Aqua.test_all(StopWatches; ambiguities = false)
end

function test_stopwatchesbase()
    Aqua.test_all(StopWatchesBase)
end

end  # module
