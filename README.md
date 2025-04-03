# OpalKelly.jl - FrontPanel API

```julia
Pkg.add(OpalKelly)
```

`OpalKelly.jl` is a C binding library for the FrontPanelAPI that provides all
functions that are exposed for the Matlab API.

In order to keep it organized, the library and FrontPanel handler are hold into
a struct `FPGA` which is received as parameter to all the shim layer calls to
the C library.

```julia
using OpalKelly

julia> using OpalKelly

julia> bitfile = joinpath(@__DIR__, "examples/hw/ok-sample/XEM7310-A200/First.bit")
"/home/cristi/Documents/Scripts/Julia/opal-kelly/OpalKelly/examples/hw/ok-sample/XEM7310-A200/First.bit"

julia> fpga = FPGA(bitfile)
FPGA(0, Ptr{Nothing} @0x0000000000000001, Ptr{Nothing} @0x0000000000000001, "/home/cristi/Documents/Scripts/Julia/opal-kelly/OpalKelly/examples/hw/ok-sample/XEM7310-A200/First.bit", UInt8[], false, 0)

julia> init_board!(fpga)
Scanning USB for Opal Kelly devices...
Found 1 Opal Kelly device(s)
Serial number of device 0 is 1908000OVV
[ Info: Device opened with id=Opal Kelly XEM7310 and board model=ok_brdXEM7310A200
ok_NoError::ErrorCode = 0

julia> OpalKelly.info(fpga)
API version: 5.2.3
Board model: ok_brdXEM7310A200
Firmware revision: 1.30
Serial number: 1908000OVV
Device ID: Opal Kelly XEM7310

# Let's try a blinky example
julia> include("examples/test.jl")
led_test (generic function with 1 method)

julia> test_random_leds(fpga)
ok_NoError::ErrorCode = 0
```

## TODO

- [ ] Write documentation inline with code and generate docs webpage
