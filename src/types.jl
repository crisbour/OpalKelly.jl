abstract type IC end

mutable struct FPGA <: IC
    id::Int
    board::Ptr{Nothing}
    lib::Ptr{Nothing}
    board_model::String
    bitfile::Union{Nothing, String}
    usbBuffer::Vector{UInt8}
    usb3::Bool
    numBytesPerBlock::Int
end

function FPGA(bitfile;usb3=false)
    board = Ptr{Nothing}(0)
    mylib = Ptr{Nothing}(0)
    fpga = FPGA(0,
                board,
                mylib,
                "unknown",
                bitfile,
                #zeros(UInt8, USB_BUFFER_SIZE),
                zeros(UInt8, 0),
                usb3,
                0)
    finalizer(cleanup, fpga)
    fpga
end

# FPGA finalizer
function cleanup(fpga::FPGA)
    @info "Cleaning up FPGA connection to OK FrontPanel"
    if fpga.lib != C_NULL
        if is_open(fpga)
            close(fpga)
        else
            @warn "FPGA was not open. Program might have exited unexpectedly!"
        end
        destruct(fpga)
        Libdl.dlclose(fpga.lib)
        @info "FPGA desctructed! => Safe exit"
    end
end

