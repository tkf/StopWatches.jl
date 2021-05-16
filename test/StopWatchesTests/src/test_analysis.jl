module TestAnalysis

using StopWatches
using Test

function test_smoke()
    @test StopWatches.time_dataframe() isa Any
    @test StopWatches.summary() === nothing
    println()
    # TODO: capture via display hook
    # (note: `display` seems to bypass `redirect_stdout`)
end

end  # module
