module Utils

if isdefined(Threads, Symbol("@spawn"))
    using Base.Threads: @spawn
else
    macro spawn(ex)
        esc(:($Base.@async $ex))
    end
end

end
