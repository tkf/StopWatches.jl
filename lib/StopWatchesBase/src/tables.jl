struct Time
    total_time_ns::TimeNS
    ncalls::Int
    tag::Union{Symbol,Nothing}
    file::Union{Symbol,Nothing}
    line::Int
    fullname::Tuple{Vararg{Symbol}}
    pkgid::Union{UUID,Nothing}
end

time_table() = append_times!(Time[])

function append_times!(table)
    for thread_records in __RECORDS
        for record in thread_records
            ncalls = sum(getindex, record.total_calls)
            ncalls == 0 && continue
            total_time_ns = sum(getindex, record.total_times)
            row = Time(
                total_time_ns,
                ncalls,
                record.location.tag,
                record.location.file,
                record.location.line,
                record.location.fullname,
                record.location.pkgid,
            )
            push!(table, row)
        end
    end
    return table
end
