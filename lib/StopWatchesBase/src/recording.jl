const TimeNS = typeof(time_ns())

struct RecordLocation
    pkgid::Union{UUID,Nothing}
    fullname::Tuple{Vararg{Symbol}}
    line::Int
    file::Union{Symbol,Nothing}
    tag::Union{Symbol,Nothing}
end

mutable struct Record
    location::RecordLocation
    total_times::Vector{typeof(Ref{TimeNS}())}
    total_calls::Vector{typeof(Ref{UInt}())}
end
# TODO: use cacheline-aligned state

function Record(location::RecordLocation)
    total_times = [Ref{TimeNS}(0) for _ in 1:Threads.nthreads()]
    total_calls = [Ref{UInt}(0) for _ in 1:Threads.nthreads()]
    return Record(location, total_times, total_calls)
end

function Base.empty!(record::Record)
    empty!(record.total_times)
    empty!(record.total_calls)
    # sizehint!(record.total_times, 0)
    # sizehint!(record.total_calls, 0)
    return record
end

const __RECORDS = Vector{Record}[]

"""
    StopWatches.clear()

Clear all records. The caller must ensure that no recordings are happening
concurrently.
"""
function clear()
    foreach(empty!, Iterators.flatten(__RECORDS))
    return
end

function init_records()
    empty!(__RECORDS)
    append!(__RECORDS, (Record[] for _ in 1:Threads.nthreads()))
end

@generated function _allocate_record(
    ::Val{pkgid},
    ::Val{fullname},
    ::Val{line},
    ::Val{file},
    ::Val{tag},
) where {pkgid,fullname,line,file,tag}
    location = RecordLocation(pkgid, fullname, line, file, tag)
    record = Record(location)
    # I am so sorry :)
    push!(__RECORDS[Threads.threadid()], record)
    quote
        $(QuoteNode(record))
    end
end
# TODO: Use StaticStorages.jl instead of the generated function hack.

function allocate_record_expr(__source__, __module__, tag::Union{Symbol,Nothing})
    pkgid = Base.PkgId(__module__).uuid
    fn = fullname(__module__)
    quote
        _allocate_record(
            $(Val(pkgid)),
            $(Val(fn)),
            $(Val(__source__.line)),
            $(Val(__source__.file)),
            $(Val(tag)),
        )
    end
end

macro allocate_record(tag::QuoteNode = QuoteNode(nothing))
    allocate_record_expr(__source__, __module__, tag.value)
end

# Used in test:
_sample_record1() = @allocate_record
_sample_record2() = @allocate_record :sample_record2
_sample_record3() = @allocate_record

"""
    @stopwatch(tag::Symbol, code)
    @stopwatch(code)

Record the start and stop times for executing `code`.

`tag` must be a literal symbol; i.e., `@stopwatch :mytag ...` instead of
`@stopwatch mytag ...`.

# Examples

```jldoctest
julia> using StopWatchesBase

julia> @stopwatch begin
           sleep(0.01)
           1
       end
1
```

The timing can now be printed with `using StopWatches` then
`StopWatches.summary()`.
"""
macro stopwatch(tag::QuoteNode, code)
    tag.value isa Symbol || error("`tag` must be a symbol; got: $(tag.value)")
    return stopwatch_impl(__source__, __module__, tag.value, code)
end

macro stopwatch(code)
    return stopwatch_impl(__source__, __module__, nothing, code)
end

macro stopwatch(tag::Symbol, code)
    error("use `@stopwatch :$tag ...`")
end

function stopwatch_impl(__source__, __module__, tag, code)
    record = allocate_record_expr(__source__, __module__, tag)
    return quote
        local t0 = time_ns()
        local ans = $(esc(Expr(:block, __source__, code)))
        local t1 = time_ns()
        local record = $record
        $push_record!(record, t1 - t0)
        ans
    end
end
# TODO: Add an option to use the geometric distribution trick to only measure
# some random subset?

function push_record!(record::Record, duration)
    # hope three is no yield :)
    tid = Threads.threadid()
    record.total_times[tid][] += duration
    record.total_calls[tid][] += 1
end
# TODO: Support other statistics? Use OnlineStats.jl?
