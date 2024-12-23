function GetWireOutValue(fpga::FPGA, epaddr::Array{Int})::Array{UInt8}
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
      epval[i, j] = GetWireOutValue(fpga, epaddr[i, j])
    end
  end
  epval
end

function SetWireInValue(fpga::FPGA, epaddr, epvalue, epmask)

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
      SetWireInValue(fpga, epaddr[i,j], epvalue[i,j], epmask[i,j])
    end
  end
end


# ReadFromBlockPipeOut in packet size at a time
function ReadFromBlockPipeOut(fpga::FPGA, epaddr::Int, blksize, bsize; psize=nothing)::Vector{UInt8}
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

  # Allocate a buffer for ReadFromBlockPipeOut.
  psize = min(psize, bsize)
  epvalue::Vector{UInt8} = fill(UInt8(0), bsize)

  if psize == bsize
    err, epvalue = ReadFromBlockPipeOut(fpga, epaddr, blksize, bsize, pv)
    if err != ok_NoError
      @error "ReadFromBlockPipeOut failed with error: $err"
    end
  else
    kk = 1:psize
    for k in 1:(bsize ÷ psize)
      err, buf = ReadFromBlockPipeOut(fpga, epaddr, blksize, psize)
      if err != ok_NoError
        @error "ReadFromBlockPipeOut failed with error: $err"
      end
      epvalue[kk] = buf
      kk = kk + psize
    end
    psize_last = mod(bsize, psize)
    kk = kk[end] + (1:psize_last)
    err, buf = ReadFromBlockPipeOut(fpga, epaddr, blksize, psize_last)
    epvalue[kk] = buf(1:psize_last)
  end
  epvalue
end

function ReadFromPipeOut(fpga::FPGA, epaddr, bsize; psize=nothing)::Vector{UInt8}
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

  # Allocate a buffer for ReadFromPipeOut.
  psize = min(psize, bsize)
  epvalue::Vector{UInt8} = fill(UInt8(0), bsize)

  if psize == bsize
    err, epvalue = ReadFromPipeOut(fpga, epaddr, bsize)
    if err != ok_NoError
      @error "ReadFromPipeOut failed with error: $err"
    end
  else
    kk = 1:psize
    for k = 1:(bsize÷psize)
      err, buf = ReadFromPipeOut(fpga, epaddr, psize)
      if err != ok_NoError
        @error "ReadFromPipeOut failed with error: $err"
      end
      epvalue[kk] = buf
      kk = kk + psize
    end
    psize_last = mod(bsize, psize)
    kk = kk[end] + (1:psize_last)
    err, buf = ReadFromPipeOut(fpga, epaddr, psize_last)
    if err != ok_NoError
      @error "ReadFromPipeOut failed to read last chunk with error: $err"
    end
    epvalue[kk] = buf(1:psize_last)
  end
  epvalue
end

function WriteToBlockPipeIn(fpga::FPGA, epaddr, blksize, epvalue::Vector{UInt8}; psize=nothing)::Union{ErrorCode, Int32}
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
  psize = min(psize,bsize);

  if bsize == psize
    err_or_len = WriteToBlockPipeIn(fpga, epaddr, blksize, psize, epvalue)
    if err_or_len isa ErrorCode
      @error "WriteToBlockPipeIn failed with error: $err_or_len"
      return err_or_len
    else
      @assert err_or_len == psize
    end
  else
  	kk = 1:psize
  	for k = 1:(bsize ÷ psize)
      err_or_len = WriteToBlockPipeIn(fpga, epaddr, blksize, psize, epvalue[kk])
      if err_or_len isa ErrorCode
        @error "WriteToBlockPipeIn failed with error: $err_or_len"
        return err_or_len
      else
        @assert err_or_len == psize
      end
  		kk = kk + psize;
  	end
  	psize_last = mod(bsize,psize);
    kk = kk[end] + (1:psize_last);
    err_or_len = WriteToBlockPipeIn(fpga, epaddr, blksize, psize_last, epvalue[kk])
    if err_or_len isa ErrorCode
      @error "WriteToBlockPipeIn failed with error: $err_or_len"
      return err_or_len
    else
      @assert err_or_len == psize_last
    end
  end
  bsize
end

function WriteToPipeIn(fpga::FPGA, epaddr, epvalue::Vector{UInt8}, psize)
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
  psize = min(psize,bsize);

  if bsize == psize
    err_or_len = WriteToPipeIn(fpga, epaddr, psize, epvalue)
    if err_or_len isa ErrorCode
      @error "WriteToPipeIn failed with error: $err_or_len"
      return err_or_len
    else
      @assert err_or_len == psize
    end
  else
  	kk = 1:psize
  	for k = 1:(bsize ÷ psize)
      err_or_len = WriteToPipeIn(fpga, epaddr, psize, epvalue[kk])
      if err_or_len isa ErrorCode
        @error "WriteToPipeIn failed with error: $err_or_len"
        return err_or_len
      else
        @assert err_or_len == psize
      end
  		kk = kk + psize;
  	end
  	psize_last = mod(bsize,psize);
    kk = kk[end] + (1:psize_last);
    err_or_len = WriteToPipeIn(fpga, epaddr, psize_last, epvalue[kk])
    if err_or_len isa ErrorCode
      @error "WriteToPipeIn failed with error: $err_or_len"
      return err_or_len
    else
      @assert err_or_len == psize_last
    end
  end
  bsize
end
