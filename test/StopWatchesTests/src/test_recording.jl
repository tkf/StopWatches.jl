module TestRecording

using StopWatches
using StopWatchesBase: Record, StopWatchesBase
using Test

using ..Utils: @spawn

function test_allocation_hack()
    swb = StopWatchesBase
    @test swb._sample_record1() === swb._sample_record1()::Record
    @test swb._sample_record2() === swb._sample_record2()::Record
    @test swb._sample_record3() === swb._sample_record3()::Record
    @test swb._sample_record1().location.fullname[1] === fullname(swb)[1]
    @test swb._sample_record1().location.tag === nothing
    @test swb._sample_record2().location.tag === :sample_record2
    @test swb._sample_record1().location.line + 1 == swb._sample_record2().location.line
end

function record_once()
    ans = @stopwatch :record_once begin
        y = 1
    end
    return (ans, y)
end

function test_record_once()
    @test record_once() == (1, 1)
end

function no_tag()
    ans = @stopwatch y = 1
    return (ans, y)
end

function test_no_tag()
    @test no_tag() == (1, 1)
end

function test_record_in_spawn()
    tasks = map(1:10) do i
        @spawn begin
            ans = @stopwatch :record_in_spawn begin
                y = i * 10
            end
            return (ans, y)
        end
    end
    results = fetch.(tasks)
    @test first.(results) == (1:10) .* 10
    @test last.(results) == (1:10) .* 10
end

end  # module
