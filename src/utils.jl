function check_fpga_exists(fpga::FPGA)::Bool
    # Check FGPA exists
    num_fpga = get_device_count(fpga)

    if num_fpga < 1
        @error "No FPGA is plugged in!"
        return false
    else
        return true
    end
end
