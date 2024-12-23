function check_fpga_exists(fpga::FPGA)::Bool
  # Check FGPA exists
  num_fpga = GetDeviceCount(fpga)

  if num_fpga < 1
    @error "No FPGA is plugged in!"
    return false
  else
    return true
  end
end
