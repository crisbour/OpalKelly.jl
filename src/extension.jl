module OKExtended

# NOTE: Wrap extension in an inner module in order to avoid confusion between c_wrapper methods and generalised calls from this module when using this API
# - As Julia is not strictly typed, multiple dispatch must be treated with more caution
# - Furthermore, Ext module uses the specific qualifier for the wrapper calls, in order to avoid recurrence
# - In the future, change function names, as in fact they have slightly distinct semantics

using ..OpalKelly

export get_wire_out_value, set_wire_in_value, read_from_block_pipe_out, read_from_pipe_out, write_to_block_pipe_in, write_to_pipe_in

function get_wire_out_value(fpga::FPGA, epaddr::Array{Integer})::Array{UInt8}
  #GETWIREOUTVALUE  Read the WireOut values from the device.
  #  epVAL=GETWIREOUTVALUE(OBJ,epADDR) returns the values of the WireOut
  #  endpoint in epVAL. The elements of epVAL are unsigned bytes
  #  (8 bits : 0..255) stored as fints (floating point integers).
  #  epVAL will have the same dimension as epADDR.  epADDR is a vector or
  #  matrix containing the endpoint addresses.
  #
  #  The valid endpoint address ranges are:
  #    0x00-0x1F : WireIn
  #  * 0x20-0x3F : WireOut
  #    0x40-0x5F : TriggerIn
  #    0x60-0x7F : TriggerOut
  #    0x80-0x9F : PipeIn
  #    0xA0-0xBF : PipeOut
  epval = zeros(size(epaddr))
  for i in 1:size(epaddr, 1)
    for j in 1:size(epaddr, 2)
      epval[i, j] = OpalKelly.get_wire_out_value(fpga, epaddr[i, j])
    end
  end
  epval
end

function set_wire_in_value(fpga::FPGA, epaddr::Array{Integer,D}, epvalue::Array{Integer,D}, epmask::Array{UInt32,D}) where {D}

  #SETWIREINVALUE  Write into WireIn values of the device.
  #  SETWIREINVALUE(OBJ,epADDR,epVALUE,epMASK) writes
  #  a value into a WireIn endpoint of a the device.
  #  The elements of epVALUE need to be ints (16 bits : 0..65535)
  #  stored as fints (floating point integers). epVALUE will have
  #  the same dimension as epADDR.
  #
  #  The valid endpoint address ranges are:
  #  * 0x00-0x1F : WireIn
  #    0x20-0x3F : WireOut
  #    0x40-0x5F : TriggerIn
  #    0x60-0x7F : TriggerOut
  #    0x80-0x9F : PipeIn
  #    0xA0-0xBF : PipeOut
  for i in 1:size(epaddr, 1)
    for j in 1:size(epaddr, 2)
      OpalKelly.set_wire_in_value(fpga, epaddr[i, j], epvalue[i, j], epmask[i, j])
    end
  end
end


# read_from_block_pipe_out in packet size at a time
# Return:
# - Length of the readout
# - Vector of the data read
function read_from_block_pipe_out(fpga::FPGA, epaddr::Integer, blksize, bsize; psize=nothing)::Vector{UInt8}
  #READFROMBLOCKPIPEOUT  Read data from a Block PipeOut.
  #  epVALUE=READFROMBLOCKPIPEOUT(OBJ,epADDR,BLKSIZE,SIZE) reads SIZE number of elements
  #  from a PipeOut endpoint.  The elements of evVALUE are unsigned bytes
  #  (8 bits : 0..255) stored as fints (floating point integers).
  #  epADDR the endpoint address of the PipeOut endpoint.
  #  BLKSIZE is the block size (2..1024).
  #
  #  epVALUE=READFROMPIPEOUT(OBJ,epADDR,BLKSIZE,SIZE,PSIZE) subdivides the read
  #  transfer into smaller packets of size PSIZE.
  #  By default, PSIZE = SIZE.
  #
  #  The valid endpoint address ranges are:
  #
  #    0x00-0x1F : WireIn
  #    0x20-0x3F : WireOut
  #    0x40-0x5F : TriggerIn
  #    0x60-0x7F : TriggerOut
  #    0x80-0x9F : PipeIn
  #  * 0xA0-0xBF : PipeOut

  if psize === nothing
    psize = bsize
  end

  # Allocate a buffer for read_from_block_pipe_out.
  psize = min(psize, bsize)
  epvalue::Vector{UInt8} = fill(UInt8(0), bsize)

  if psize == bsize
    err_or_len, epvalue = OpalKelly.read_from_block_pipe_out(fpga, epaddr, blksize, bsize)
    @inline check_err_or_len(err_or_len, bsize)
  else
    kk = 1:psize
    for k in 1:(bsize÷psize)
      err_or_len, buf = OpalKelly.read_from_block_pipe_out(fpga, epaddr, blksize, psize)
      @inline check_err_or_len(err_or_len, bsize)
      epvalue[kk] = buf
      kk = kk + psize
    end
    psize_last = mod(bsize, psize)
    kk = kk[end] + (1:psize_last)
    err, buf = OpalKelly.read_from_block_pipe_out(fpga, epaddr, blksize, psize_last)
    epvalue[kk] = buf(1:psize_last)
  end
  epvalue
end

function read_from_pipe_out(fpga::FPGA, epaddr::Integer, bsize; psize=nothing)::Vector{UInt8}
  #READFROMPIPEOUT  Read data from a PipeOut.
  #  epVALUE=READFROMPIPEOUT(OBJ,epADDR,SIZE) reads SIZE number of elements
  #  from a PipeOut endpoint.  The elements of evVALUE are unsigned bytes
  #  (8 bits : 0..255) stored as fints (floating point integers).
  #  epADDR the endpoint address of the PipeOut endpoint.
  #
  #  epVALUE=READFROMPIPEOUT(OBJ,epADDR,SIZE,PSIZE) subdivides the read
  #  transfer into smaller packets of size PSIZE.
  #  By default, PSIZE = SIZE.
  #
  #  The valid endpoint address ranges are:
  #
  #    0x00-0x1F : WireIn
  #    0x20-0x3F : WireOut
  #    0x40-0x5F : TriggerIn
  #    0x60-0x7F : TriggerOut
  #    0x80-0x9F : PipeIn
  #  * 0xA0-0xBF : PipeOut

  if psize === nothing
    psize = bsize
  end

  # Allocate a buffer for read_from_pipe_out.
  psize = min(psize, bsize)
  epvalue::Vector{UInt8} = fill(UInt8(0), bsize)

  if psize == bsize
    err_or_len, epvalue = OpalKelly.read_from_pipe_out(fpga, epaddr, bsize)
    @inline check_err_or_len(err_or_len, bsize)
  else
    kk = 1:psize
    for k = 1:(bsize÷psize)
      err_or_len, buf = OpalKelly.read_from_pipe_out(fpga, epaddr, psize)
      @inline check_err_or_len(err_or_len, bsize)
      epvalue[kk] = buf
      kk = kk + psize
    end
    psize_last = mod(bsize, psize)
    kk = kk[end] + (1:psize_last)
    err_or_len, buf = OpalKelly.read_from_pipe_out(fpga, epaddr, psize_last)
    @inline check_err_or_len(err_or_len, bsize)
    epvalue[kk] = buf(1:psize_last)
  end
  epvalue
end

function write_to_block_pipe_in(fpga::FPGA, epaddr::Integer, blksize, epvalue::Vector{UInt8}; psize=nothing)
  #WRITETOBLOCKPIPEIN  Write data into a PipeIn.
  #  SUCCESS=WRITETOBLOCKPIPEIN(OBJ,epADDR,BLKSIZE,epVALUE) writes
  #  the elements of the vector epVALUE into a PipeIn endpoint.
  #  The elements of epVALUE need to be unsigned bytes (8 bits : 0..255)
  #  stored as fints (floating point integers).
  #  epADDR the endpoint address of the PipeIn endpoint.
  #  BLKSIZE is the block size in bytes (2..1024).
  #
  #  SUCCESS=WRITETOBLOCKPIPEIN(OBJ,epADDR,BLKSIZE,epVALUE,PSIZE) subdivides
  #  transfer into multiple packets. The PSIZE contains the
  #  packet size of each packet, except for the last one.
  #
  #  The valid endpoint address ranges are:
  #
  #    0x00-0x1F : WireIn
  #    0x20-0x3F : WireOut
  #    0x40-0x5F : TriggerIn
  #    0x60-0x7F : TriggerOut
  #  * 0x80-0x9F : PipeIn
  #    0xA0-0xBF : PipeOut

  bsize = length(epvalue)
  if psize === nothing
    psize = bsize
  end
  psize = min(psize, bsize)

  if bsize == psize
    err_or_len = OpalKelly.write_to_block_pipe_in(fpga, epaddr, blksize, psize, epvalue)
    @inline check_err_or_len(err_or_len, bsize)
  else
    kk = 1:psize
    for _ = 1:(bsize÷psize)
      err_or_len = OpalKelly.write_to_block_pipe_in(fpga, epaddr, blksize, psize, epvalue[kk])
      @inline check_err_or_len(err_or_len, bsize)
      kk = kk + psize
    end
    psize_last = mod(bsize, psize)
    kk = kk[end] + (1:psize_last)
    err_or_len = OpalKelly.write_to_block_pipe_in(fpga, epaddr, blksize, psize_last, epvalue[kk])
    @inline check_err_or_len(err_or_len, bsize)
  end
end

function write_to_pipe_in(fpga::FPGA, epaddr::Integer, epvalue::Vector{UInt8}, psize)
  #WRITETOPIPEIN  Write data into a PipeIn.
  #  SUCCESS=WRITETOPIPEIN(OBJ,epADDR,epVALUE) writes
  #  the elements of the vector epVALUE into a PipeIn endpoint.
  #  The elements of epVALUE need to be unsigned bytes (8 bits : 0..255)
  #  stored as fints (floating point integers).
  #  epADDR the endpoint address of the PipeIn endpoint.
  #
  #  SUCCESS=WRITETOPIPEIN(OBJ,epADDR,epVALUE,PSIZE) subdivides
  #  transfer into multiple packets. The PSIZE contains the
  #  packet size of each packet, except for the last one.
  #
  #  The valid endpoint address ranges are:
  #
  #    0x00-0x1F : WireIn
  #    0x20-0x3F : WireOut
  #    0x40-0x5F : TriggerIn
  #    0x60-0x7F : TriggerOut
  #  * 0x80-0x9F : PipeIn
  #    0xA0-0xBF : PipeOut
  bsize = length(epvalue)
  if psize === nothing
    psize = bsize
  end
  psize = min(psize, bsize)

  if bsize == psize
    err_or_len = OpalKelly.write_to_pipe_in(fpga, epaddr, psize, epvalue)
    @inline check_err_or_len(err_or_len, bsize)
  else
    kk = 1:psize
    for _ = 1:(bsize÷psize)
      err_or_len = OpalKelly.write_to_pipe_in(fpga, epaddr, psize, epvalue[kk])
      @inline check_err_or_len(err_or_len, bsize)
      kk = kk + psize
    end
    psize_last = mod(bsize, psize)
    kk = kk[end] + (1:psize_last)
    err_or_len = OpalKelly.write_to_pipe_in(fpga, epaddr, psize_last, epvalue[kk])
    @inline check_err_or_len(err_or_len, bsize)
  end
end

# --------------------------------------------------------------------------------
# Utils
# --------------------------------------------------------------------------------

# Call this function with @inline to have error/warn report on the correct line number
function check_err_or_len(err_or_len::OpalKelly.ResultLength, expected_len::Integer)
  if is_error(err_or_len)
    @error "Failed with error: $err_or_len"
  elseif err_or_len != expected_len
    @warn "Read/Wrote $err_or_len bytes compared with expected $expected_len bytes"
  end
end

end
