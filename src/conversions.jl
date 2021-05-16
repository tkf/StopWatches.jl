function StopWatches.time_table()
    table = Tables.columntable(append_times!(StructVector{Time}(undef, 0)))
    total_time = uconvert.(u"s", float.(table.total_time_ns) .* u"ns")
    average_time = total_time ./ table.ncalls
    return StructVector(
        _time_table(;
            average_time = average_time,
            total_time = total_time,
            # Append the rest:
            table...,
        ),
    )
end

_time_table(;
    # Removing from the table:
    total_time_ns,
    # Keeping the rest:
    table...,
) = values(table)

StopWatches.time_dataframe() = DataFrame(StopWatches.time_table(), copycols = false)

function StopWatches.summary()
    display(StopWatches.time_dataframe())
    return
end
