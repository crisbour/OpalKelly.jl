export getlibrary, open_board, init_board!, uploadFpgaBitfile

getlibrary(fpgas::Vector{FPGA}) = map(getlibrary, fpgas)

function getlibrary(fpga::FPGA)
  fpga.lib = Libdl.dlopen(ok_front_panel_lib_path, Libdl.RTLD_NOW)
  fpga.board = ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_Construct), Ptr{Nothing}, ())
  nothing
end

function open_board(fpga::FPGA)
  getlibrary(fpga)

  println("Scanning USB for Opal Kelly devices...")
  nDevices = get_device_count(fpga)
  println("Found ", nDevices, " Opal Kelly device(s)")

  #Get Serial Number
  serialnumber = get_device_list_serial(fpga, fpga.id)
  println("Serial number of device $(fpga.id) is ", serialnumber)

  #Open by serial
  err = open_by_serial(fpga, serialnumber)
  if err != ok_NoError
    @error "Device could not be opened. Is one connected? ERROR: $err"
    return err
  end
  id = get_device_id(fpga)
  board_model = get_board_model(fpga)
  @info "Device opened with id=$id and board model=$board_model"

  #configure on-board PLL
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_LoadDefaultPLLConfiguration), Cint, (Ptr{Nothing},), fpga.board)
end

function upload_fpga_bitfile(fpga::FPGA, bit_file_path)
  if !is_open(fpga)
    @error "FPGA connection not opened! Cannot upload bitfile."
  end

  #upload configuration file
  err::ErrorCode = configure_fpga(fpga, bit_file_path)
  if err != ok_NoError
    @error "FPGA configuration failed with error: $err"
  else
    # Log the bitfile path
    fpga.bitfile = bit_file_path
  end

  #Check if FrontPanel Support is enabled
  if !is_front_panel_enabled(fpga)
    @warn "FrontPanel not enabled"
  end

  update_wire_outs(fpga)
  # TODO: Get Firmware version and board version
  #boardId = GetWireOutValue(fpga,WireOutBoardId)
  #boardVersion = GetWireOutValue(fpga,WireOutBoardVersion)
end

function init_board!(fpga::FPGA)
  getlibrary(fpga)
  open_board(fpga)
  upload_fpga_bitfile(fpga, fpga.bitfile)
end
