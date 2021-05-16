module TestRecording

using StopWatches
using StopWatchesBase: Record, RecordHandle, StopWatchesBase
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
    handle = @stopwatch :record_once begin
        y = 1
    end
    return y, handle
end

function test_record_once()
    y, handle = record_once()
    @test y == 1
    @test handle isa RecordHandle
end

function no_tag()
    handle = @stopwatch y = 1
    return y, handle
end

function test_no_tag()
    y, handle = no_tag()
    @test y == 1
    @test handle isa RecordHandle
end

function test_record_in_spawn()
    tasks = map(1:10) do i
        @spawn begin
            handle = @stopwatch :record_in_spawn begin
                y = i * 10
            end
            return (y == i * 10), handle
        end
    end
    results = fetch.(tasks)
    @test all(first, results)
    @test all(handle isa RecordHandle for (_, handle) in results)
end

end  # module
