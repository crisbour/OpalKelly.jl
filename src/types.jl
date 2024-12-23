abstract type IC end

mutable struct FPGA <: IC
  id::Int
  board::Ptr{Nothing}
  lib::Ptr{Nothing}
  bitfile::Union{Nothing, String}
  usbBuffer::Vector{UInt8}
  usb3::Bool
  numBytesPerBlock::Int
end

function FPGA(bitfile;usb3=false)
    board = Ptr{Nothing}(1)
    mylib = Ptr{Nothing}(1)
    FPGA(0,
         board,
         mylib,
         bitfile,
         #zeros(UInt8, USB_BUFFER_SIZE),
         zeros(UInt8, 0),
         usb3,
         0)
end

