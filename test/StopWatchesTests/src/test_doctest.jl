module TestDoctest

import StopWatchesTests
using Documenter: doctest
using Test

function test_doctest()
    doctest(StopWatchesTests; manual = false)
end

end  # module
