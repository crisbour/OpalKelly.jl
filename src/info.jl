
function info(fpga::FPGA)
  #DISPLAY  Display an okfrontpanel object.

  if !is_open(fpga)
    @warn "NO DEVICE OPEN."
  else
    @printf("API version: %d.%d.%d\n", get_api_version_major(), get_api_version_minor(), get_api_version_micro())
    println("Board model: ", get_board_model(fpga))
    @printf("Firmware revision: %d.%d\n", get_device_major_version(fpga), get_device_minor_version(fpga))
    println("Serial number: ", get_serial_number(fpga))
    println("Device ID: ", get_device_id(fpga))
  end
end
