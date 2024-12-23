__precompile__()

module OpalKelly

using Libdl
using Logging
using CEnum
using Test
using Printf

include("constants.jl")

include("types.jl")
include("c_types.jl")

include("c_wrapper.jl")
include("extension.jl")

include("info.jl")
include("setup.jl")
include("test.jl")
include("utils.jl")

export ErrorCode, BoardModel, FPGA

end
