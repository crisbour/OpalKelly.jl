function info(fpga::FPGA)
  #DISPLAY  Display an okfrontpanel object.

  if !IsOpen(fpga)
    @warn "NO DEVICE OPEN."
  else
    @printf("API version: %d.%d.%d\n", GetAPIVersionMajor(), GetAPIVersionMinor(), GetAPIVersionMicro())
    println("Board model: ", GetBoardModel(fpga))
    @printf("Firmware revision: %d.%d\n", GetDeviceMajorVersion(fpga), GetDeviceMinorVersion(fpga))
    println("Serial number: ", GetSerialNumber(fpga))
    println("Device ID: ", GetDeviceID(fpga))
  end
end
