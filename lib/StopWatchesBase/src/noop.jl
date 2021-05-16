module Noop

export @stopwatch

macro stopwatch(_, code)
    esc(code)
end

macro stopwatch(code)
    esc(code)
end

end
