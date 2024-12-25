# ----------------------------------------------------------------------------
# Querry functions
# ----------------------------------------------------------------------------

#int DLL_ENTRY okFrontPanel_GetAPIVersionMajor();
function get_api_version_major()::Int
  ok_front_panel_lib = Libdl.dlopen(ok_front_panel_lib_path,Libdl.RTLD_NOW)
  ccall(Libdl.dlsym(ok_front_panel_lib, :okFrontPanel_GetAPIVersionMajor), Cint, ())
end
#int DLL_ENTRY okFrontPanel_GetAPIVersionMinor();
function get_api_version_minor()::Int
  ok_front_panel_lib = Libdl.dlopen(ok_front_panel_lib_path,Libdl.RTLD_NOW)
  ccall(Libdl.dlsym(ok_front_panel_lib, :okFrontPanel_GetAPIVersionMinor), Cint, ())
end
#int DLL_ENTRY okFrontPanel_GetAPIVersionMicro();
function get_api_version_micro()::Int
  ok_front_panel_lib = Libdl.dlopen(ok_front_panel_lib_path,Libdl.RTLD_NOW)
  ccall(Libdl.dlsym(ok_front_panel_lib, :okFrontPanel_GetAPIVersionMicro), Cint, ())
end


#TODO: Convert C++ interface to Julia
function destruct(fpga::FPGA)::Nothing
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_Destruct), Nothing, (Ptr{Nothing},), fpga.board)
end
#int DLL_ENTRY okFrontPanel_GetHostInterfaceWidth(okFrontPanel_HANDLE hnd);
function get_host_interface_width(fpga::FPGA)::Int
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_GetHostInterfaceWidth), Int, (Ptr{Nothing},), fpga.board)
end
#Bool DLL_ENTRY okFrontPanel_IsHighSpeed(okFrontPanel_HANDLE hnd);
function is_high_speed(fpga::FPGA)::Bool
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_IsHighSpeed), Bool, (Ptr{Nothing},), fpga.board)
end
#ok_BoardModel DLL_ENTRY okFrontPanel_GetBoardModel(okFrontPanel_HANDLE hnd);
function get_board_model(fpga::FPGA)::BoardModel
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_GetBoardModel), BoardModel, (Ptr{Nothing},), fpga.board)
end
#ok_BoardModel DLL_ENTRY okFrontPanel_FindUSBDeviceModel(unsigned usbVID, unsigned usbPID);
function find_usb_device_model(fpga::FPGA, usbVID::UInt, usbPID::UInt)::BoardModel
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_FindUSBDeviceModel), BoardModel, (Ptr{Nothing}, UInt, UInt), fpga.board, usbVID, usbPID)
end
#void DLL_ENTRY okFrontPanel_GetBoardModelString(okFrontPanel_HANDLE hnd, ok_BoardModel m, char *buf);
function get_board_model_string(fpga::FPGA, brd_model::BoardModel)::String
  buf = Array{UInt8}(undef, 64)
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_GetBoardModelString), Nothing, (Ptr{Nothing}, BoardModel, Ptr{Char}), fpga.board, brd_model, buf)
  unsafe_string(pointer(buf))
end
#int DLL_ENTRY okFrontPanel_GetDeviceCount(okFrontPanel_HANDLE hnd);
function get_device_count(fpga::FPGA)::Int
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_GetDeviceCount), Cint, (Ptr{Nothing},), fpga.board)
end
#ok_BoardModel DLL_ENTRY okFrontPanel_GetDeviceListModel(okFrontPanel_HANDLE hnd, int num);
function get_device_list_model(fpga::FPGA, idx::Int)::BoardModel
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_GetDeviceListModel), BoardModel, (Ptr{Nothing}, Int), fpga.board, idx)
end
#void DLL_ENTRY okFrontPanel_GetDeviceListSerial(okFrontPanel_HANDLE hnd, int num, char *buf);
function get_device_list_serial(fpga::FPGA, idx::Int)::String
  buf=Array{UInt8}(undef,11)
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_GetDeviceListSerial), Nothing, (Ptr{Nothing}, Int, Ptr{Char}), fpga.board, idx, buf)
  buf[end]=0
  unsafe_string(pointer(buf))
end
#ok_ErrorCode DLL_ENTRY okFrontPanel_OpenBySerial(okFrontPanel_HANDLE hnd, const char *serial);
function open_by_serial(fpga::FPGA, serial_name::String)::ErrorCode
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_OpenBySerial), ErrorCode, (Ptr{Nothing}, Ptr{UInt8}), fpga.board, serial_name)
end
#Bool DLL_ENTRY okFrontPanel_IsOpen(okFrontPanel_HANDLE hnd);
function is_open(fpga::FPGA)::Bool
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_IsOpen), Bool, (Ptr{Nothing},), fpga.board)
end
#Bool DLL_ENTRY okFrontPanel_IsRemote(okFrontPanel_HANDLE hnd);
function is_remote(fpga::FPGA)::Bool
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_IsRemote), Bool, (Ptr{Nothing},), fpga.board)
end
#void DLL_ENTRY okFrontPanel_EnableAsynchronousTransfers(okFrontPanel_HANDLE hnd, Bool enable);
function enable_asynchronous_transfers(fpga::FPGA, enable::Bool)
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_EnableAsynchronousTransfers), Nothing, (Ptr{Nothing}, Bool), fpga.board, enable)
end
#ok_ErrorCode DLL_ENTRY okFrontPanel_SetBTPipePollingInterval(okFrontPanel_HANDLE hnd, int interval);
function set_bt_pipe_polling_interval(fpga::FPGA, interval::Int)::ErrorCode
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_SetBTPipePollingInterval), ErrorCode, (Ptr{Nothing}, Int), fpga.board, interval)
end
#void DLL_ENTRY okFrontPanel_SetTimeout(okFrontPanel_HANDLE hnd, int timeout);
function set_timeout(fpga::FPGA, timeout::Int)::Int
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_SetTimeout), Nothing, (Ptr{Nothing}, Cint), fpga.board, timeout)
end
#int DLL_ENTRY okFrontPanel_GetDeviceMajorVersion(okFrontPanel_HANDLE hnd);
function get_device_major_version(fpga::FPGA)::Int
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_GetDeviceMajorVersion), Cint, (Ptr{Nothing},), fpga.board)
end
#int DLL_ENTRY okFrontPanel_GetDeviceMinorVersion(okFrontPanel_HANDLE hnd);
function get_device_minor_version(fpga::FPGA)::Int
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_GetDeviceMinorVersion), Cint, (Ptr{Nothing},), fpga.board)
end
#ok_ErrorCode DLL_ENTRY okFrontPanel_ResetFPGA(okFrontPanel_HANDLE hnd);
function reset_fpga(fpga::FPGA)::ErrorCode
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_ResetFPGA), ErrorCode, (Ptr{Nothing},), fpga.board)
end
#void DLL_ENTRY okFrontPanel_Close(okFrontPanel_HANDLE hnd);
function close(fpga::FPGA)
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_Close), Nothing, (Ptr{Nothing},), fpga.board)
end
#void DLL_ENTRY okFrontPanel_GetSerialNumber(okFrontPanel_HANDLE hnd, char *buf);
function get_serial_number(fpga::FPGA)::String
  buf::Array{UInt8,1} = Array{UInt8}(undef, 256)
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_GetSerialNumber), Nothing, (Ptr{Nothing}, Ptr{Char}), fpga.board, buf)
  unsafe_string(pointer(buf))
end
#ok_ErrorCode DLL_ENTRY okFrontPanel_GetDeviceSensors(okFrontPanel_HANDLE hnd, okDeviceSensors_HANDLE settings);
function get_device_sensors(fpga::FPGA, dev_sensor_handle::Ptr{Nothing})::ErrorCode
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_GetDeviceSensors), ErrorCode, (Ptr{Nothing}, Ptr{Nothing}), fpga.board, dev_sensor_handle)
end
#ok_ErrorCode DLL_ENTRY okFrontPanel_GetDeviceSettings(okFrontPanel_HANDLE hnd, okDeviceSettings_HANDLE settings);
function get_device_settings(fpga::FPGA, dev_settings_handle::Ptr{Nothing})::ErrorCode
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_GetDeviceSettings), ErrorCode, (Ptr{Nothing}, Ptr{Nothing}), fpga.board, dev_settings_handle)
end
#ok_ErrorCode DLL_ENTRY okFrontPanel_GetDeviceInfoWithSize(okFrontPanel_HANDLE hnd, okTDeviceInfo *info, unsigned size);
function get_device_info_with_size(fpga::FPGA, size::UInt)::Tuple{ErrorCode,Any}
  dev_info::Ptr{Nothing} = Ptr{Nothing}(1)
  err = ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_GetDeviceInfoWithSize), ErrorCode, (Ptr{Nothing}, Ptr{Nothing}, Cuint), fpga.board, dev_info, size)
  err, dev_info[]
end
#void DLL_ENTRY okFrontPanel_GetDeviceID(okFrontPanel_HANDLE hnd, char *buf);
function get_device_id(fpga::FPGA)::String
  buf = Array{UInt8}(undef, 64)
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_GetDeviceID), Nothing, (Ptr{Nothing}, Ptr{UInt8}), fpga.board, buf)
  unsafe_string(pointer(buf))
end
#void DLL_ENTRY okFrontPanel_SetDeviceID(okFrontPanel_HANDLE hnd, const char *strID);
function set_device_id(fpga::FPGA, dev_id::String)
  if length(dev_id) > 32
    @warn "Device ID length is greater than 32 characters. Truncating to 32 characters"
    dev_id = dev_id[1:32]
  end
  cstr_dev_id::Array{UInt8} = vcat(UInt8.(collect(dev_id)),[0x00])
  @debug "Configure FPGA with new ID : $dev_id"
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_SetDeviceID), Nothing, (Ptr{Nothing}, Ptr{Char}), fpga.board, cstr_dev_id)
end

# ----------------------------------------------------------------------------
# Configure FPGA with bitfile from:
# file, memory, flash or data
# ----------------------------------------------------------------------------

#ok_ErrorCode DLL_ENTRY okFrontPanel_ConfigureFPGA(okFrontPanel_HANDLE hnd, const char *strFilename);
function configure_fpga(fpga::FPGA, str_filename::String)::ErrorCode
  cstr_filename::Array{UInt8} = vcat(UInt8.(collect(str_filename)),[0x00])
  @debug "Configure FPGA with bitfile: $str_filename of type $(typeof(cstr_filename))"
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_ConfigureFPGA), ErrorCode, (Ptr{Nothing}, Ptr{UInt8}), fpga.board, cstr_filename)
end
#ok_ErrorCode DLL_ENTRY okFrontPanel_ConfigureFPGAWithReset(okFrontPanel_HANDLE hnd, const char *strFilename, const okTFPGAResetProfile *reset);
function configure_fpga_with_reset(fpga::FPGA, str_filename::String, fpga_reset_profile::okTFPGAResetProfile)::ErrorCode
  h_fpga_reset_profile = Ref(fpga_reset_profile)
  cstr_filename::Array{UInt8} = vcat(UInt8.(collect(str_filename)),[0x00])
  @debug "Configure FPGA with bitfile: $str_filename of type $(typeof(cstr_filename))"
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_ConfigureFPGAWithReset), ErrorCode, (Ptr{Nothing}, Ptr{UInt8}, Ptr{Nothing}), fpga.board, str_filename, h_fpga_reset_profile)
end
#ok_ErrorCode DLL_ENTRY okFrontPanel_ConfigureFPGAFromMemory(okFrontPanel_HANDLE hnd, unsigned char *data, unsigned long length);
function configure_fpga_from_memory(fpga::FPGA, data::Vector{UInt8})::ErrorCode
  len = length(data)
  data_slice = Array{UInt8}(data, len)
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_ConfigureFPGAFromMemory), ErrorCode, (Ptr{Nothing}, Ptr{UInt8}, Culong), fpga.board, data_slice, len)
end
##ok_ErrorCode DLL_ENTRY okFrontPanel_ConfigureFPGAFromMemoryWithProgress(okFrontPanel_HANDLE hnd, unsigned char *data, unsigned long length, okTProgressCallback callback, void *arg);
#function configure_fpga_from_memory_with_progress(fpga::FPGA, data::Vector{UInt8}, len::Int, callback::)::Int
#    ccall(Libdl.dlsym(fpga.lib,:okFrontPanel_ConfigureFPGAFromMemoryWithProgress),Int,(Ptr{Nothing},),fpga.board)
#end
#ok_ErrorCode DLL_ENTRY okFrontPanel_ConfigureFPGAFromMemoryWithReset(okFrontPanel_HANDLE hnd, unsigned char *data, unsigned long length, const okTFPGAResetProfile *reset);
function configure_fpga_from_memory_with_reset(fpga::FPGA, data::Vector{UInt8}, fpga_reset_profile::okTFPGAResetProfile)::ErrorCode
  h_fpga_reset_profile = Ref(fpga_reset_profile)
  len = length(data)
  data_slice = Array{UInt8}(data, len)
  ccall(Libdl.dlsym(fpga.lib,:okFrontPanel_ConfigureFPGAFromMemoryWithReset),ErrorCode,(Ptr{Nothing},Ptr{UInt8}, Culong, Ptr{Nothing}), fpga.board, data_slice, len, h_fpga_reset_profile)
end
#ok_ErrorCode DLL_ENTRY okFrontPanel_ConfigureFPGAFromFlash(okFrontPanel_HANDLE hnd, unsigned long configIndex);
function configure_fpga_from_flash(fpga::FPGA, config_idx::UInt32)::Int
    ccall(Libdl.dlsym(fpga.lib,:okFrontPanel_ConfigureFPGAFromFlash),ErrorCode,(Ptr{Nothing},Culong),fpga.board, config_idx)
end

# ----------------------------------------------------------------------------
#
# ----------------------------------------------------------------------------

function is_front_panel_enabled(fpga::FPGA)::Bool
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_IsFrontPanelEnabled), Bool, (Ptr{Nothing},), fpga.board)
end
#Bool DLL_ENTRY okFrontPanel_IsFrontPanel3Supported(okFrontPanel_HANDLE hnd);
function is_front_panel3_supported(fpga::FPGA)::Bool
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_IsFrontPanel3Supported), Bool, (Ptr{Nothing},), fpga.board)
end
#ok_ErrorCode DLL_ENTRY okFrontPanel_UpdateWireIns(okFrontPanel_HANDLE hnd);
function update_wire_ins(fpga::FPGA)::ErrorCode
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_UpdateWireIns), ErrorCode, (Ptr{Nothing},), fpga.board)
end
#ok_ErrorCode DLL_ENTRY okFrontPanel_GetWireInValue(okFrontPanel_HANDLE hnd, int epAddr, UINT32 *val);
function get_wire_in_value(fpga::FPGA, ep_addr::Int)::Tuple{ErrorCode,UInt32}
  val = Ptr{UInt32}(0)
  err = ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_GetWireInValue), ErrorCode, (Ptr{Nothing}, Int, Ptr{Nothing}), fpga.board, ep_addr, val)
  err, val[]
end
#ok_ErrorCode DLL_ENTRY okFrontPanel_SetWireInValue(okFrontPanel_HANDLE hnd, int ep, unsigned long val, unsigned long mask);
function set_wire_in_value(fpga::FPGA, ep::Int, val::UInt32, mask::UInt32=0xffffffff)::ErrorCode
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_SetWireInValue), ErrorCode, (Ptr{Nothing}, Cint, Culong, Culong), fpga.board, ep, val, mask)
end
#ok_ErrorCode DLL_ENTRY okFrontPanel_UpdateWireOuts(okFrontPanel_HANDLE hnd);
function update_wire_outs(fpga::FPGA)::ErrorCode
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_UpdateWireOuts), ErrorCode, (Ptr{Nothing},), fpga.board)
end
#unsigned long DLL_ENTRY okFrontPanel_GetWireOutValue(okFrontPanel_HANDLE hnd, int epAddr);
function get_wire_out_value(fpga::FPGA, ep_addr::Int)::UInt
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_GetWireOutValue), Culong, (Ptr{Nothing}, Int32), fpga.board, ep_addr)
end
#ok_ErrorCode DLL_ENTRY okFrontPanel_ActivateTriggerIn(okFrontPanel_HANDLE hnd, int epAddr, int bit);
function activate_trigger_in(fpga::FPGA, ep_addr::Int, bit::Int)::ErrorCode
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_ActivateTriggerIn), ErrorCode, (Ptr{Nothing}, Int32, Int32), fpga.board, ep_addr, bit)
end
#ok_ErrorCode DLL_ENTRY okFrontPanel_UpdateTriggerOuts(okFrontPanel_HANDLE hnd);
function update_trigger_outs(fpga::FPGA)::ErrorCode
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_UpdateTriggerOuts), ErrorCode, (Ptr{Nothing},), fpga.board)
end
#Bool DLL_ENTRY okFrontPanel_IsTriggered(okFrontPanel_HANDLE hnd, int epAddr, unsigned long mask);
function is_triggered(fpga::FPGA, ep_addr::Int, mask::UInt32)::Bool
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_IsTriggered), Bool, (Ptr{Nothing}, Int, UInt32), fpga.board, ep_addr, mask)
end
#UINT32 DLL_ENTRY okFrontPanel_GetTriggerOutVector(okFrontPanel_HANDLE hnd, int epAddr);
function get_trigger_out_vector(fpga::FPGA, ep_addr::Int)::UInt32
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_GetTriggerOutVector), UInt32, (Ptr{Nothing}, Int), fpga.board, ep_addr)
end
#long DLL_ENTRY okFrontPanel_GetLastTransferLength(okFrontPanel_HANDLE hnd);
function get_last_transfer_length(fpga::FPGA)::UInt
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_GetLastTransferLength), Cint, (Ptr{Nothing},), fpga.board)
end
#long DLL_ENTRY okFrontPanel_WriteToPipeIn(okFrontPanel_HANDLE hnd, int epAddr, long length, unsigned char *data);
function write_to_pipe_in(fpga::FPGA, ep_addr::Int, len::UInt, data::Vector{UInt8})::UInt
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_WriteToPipeIn), UInt32, (Ptr{Nothing}, Int, Int, Ptr{UInt8}), fpga.board, ep_addr, len, data)
end
#long DLL_ENTRY okFrontPanel_ReadFromPipeOut(okFrontPanel_HANDLE hnd, int epAddr, long length, unsigned char *data);
function read_from_pipe_out(fpga::FPGA, ep_addr::Int, len::Int)::Tuple{ErrorCode, Vector{UInt8}}
  data::Vector{UInt8} = Array{UInt8}(undef, len)
  ret_len = ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_ReadFromPipeOut), Clong, (Ptr{Nothing}, Int32, Clong, Ptr{UInt8}), fpga.board, ep_addr, len, data)
  ErrorCode(ret_len>=0 ? ErrorCode.ok_NoError : ErrorCode(ret_len)), unsafe_wrap(Vector{UInt8}, data, ret_len)
end
#long DLL_ENTRY okFrontPanel_WriteToBlockPipeIn(okFrontPanel_HANDLE hnd, int epAddr, int blockSize, long length, unsigned char *data);
function write_to_block_pipe_in(fpga::FPGA, ep_addr::Int, block_size::Int, len::Int, data::Vector{UInt8})::Union{ErrorCode, Int32}
  ret = ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_WriteToBlockPipeIn), Clong, (Ptr{Nothing}, Int, Int, Int, Ptr{Char}), fpga.board, ep_addr, block_size, len, data)
  if ret < 0
    return ErrorCode(ret)
  else
    return Int32(ret)
  end
end
#long DLL_ENTRY okFrontPanel_ReadFromBlockPipeOut(okFrontPanel_HANDLE hnd, int epAddr, int blockSize, long length, unsigned char *data);
function read_from_block_pipe_out(fpga::FPGA, ep_addr::Int, block_size::Int, len::UInt)::Tuple{ErrorCode,Vector{UInt8}}
  data::Vector{UInt8} = Array{UInt8}(undef, len)
  err = ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_ReadFromBlockPipeOut), ErrorCode, (Ptr{Nothing}, Int32, Int32, Clong, Ptr{UInt8}), fpga.board, ep_addr, block_size, len, data)
  err, data
end

# ----------------------------------------------------------------------------
# MCU Write/Read
# ----------------------------------------------------------------------------

#ok_ErrorCode DLL_ENTRY okFrontPanel_WriteI2C(okFrontPanel_HANDLE hnd, const int addr, int length, unsigned char *data);
function write_i2c(fpga::FPGA, addr::Int, data::Vector{UInt8})::ErrorCode
  len = length(data)
  data_slice = Array{UInt8}(data, len)
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_WriteI2C), ErrorCode, (Ptr{Nothing}, Cint, Cint, Ptr{UInt8}), fpga.board, addr, len, data_slice)
end
#ok_ErrorCode DLL_ENTRY okFrontPanel_ReadI2C(okFrontPanel_HANDLE hnd, const int addr, int length, unsigned char *data);
function read_i2c(fpga::FPGA, addr::Int, len::Int)::Tuple{ErrorCode, Vector{UInt8}}
  data_slice = Array{UInt8}(undef, len)
  err = ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_ReadI2C), ErrorCode, (Ptr{Nothing}, Cint, Cint, Ptr{UInt8}), fpga.board, addr, len, data_slice)
  data = unsafe_wrap(Vector{UInt8}, data_slice, len)
  err, data
end
#ok_ErrorCode DLL_ENTRY okFrontPanel_FlashEraseSector(okFrontPanel_HANDLE hnd, UINT32 address);
function flash_erase_sector(fpga::FPGA, addr::UInt32)::ErrorCode
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_FlashEraseSector), ErrorCode, (Ptr{Nothing}, UInt32), fpga.board, addr)
end
#ok_ErrorCode DLL_ENTRY okFrontPanel_FlashWrite(okFrontPanel_HANDLE hnd, UINT32 address, UINT32 length, const UINT8 *buf);
function flash_write(fpga::FPGA, addr::UInt32, data::Vector{UInt8})::Tuple{ErrorCode, Vector{UInt8}}
  len = length(data)
  data_slice = Array{UInt8}(data, len)
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_FlashWrite), ErrorCode, (Ptr{Nothing}, UInt32, UInt32, Ptr{UInt8}), fpga.board, addr, len, data_slice)
end
#ok_ErrorCode DLL_ENTRY okFrontPanel_FlashRead(okFrontPanel_HANDLE hnd, UINT32 address, UINT32 length, UINT8 *buf);
function flash_read(fpga::FPGA, addr::Int, len::Int)::Tuple{ErrorCode, Vector{UInt8}}
  data_slice = Array{UInt8}(undef, len)
  err = ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_FlashRead), ErrorCode, (Ptr{Nothing}, Cint, Cint, Ptr{UInt8}), fpga.board, addr, len, data_slice)
  data = unsafe_wrap(Vector{UInt8}, data_slice, len)
  err, data
end

# ----------------------------------------------------------------------------
# Registers Read/Write
# ----------------------------------------------------------------------------

#ok_ErrorCode DLL_ENTRY okFrontPanel_ReadRegister(okFrontPanel_HANDLE hnd, UINT32 addr, UINT32 *data);
function read_register(fpga::FPGA, addr::UInt32)::Tuple{ErrorCode, UInt32}
  data_ptr = Ptr{UInt32}(undef, 1)
  err = ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_ReadRegister), ErrorCode, (Ptr{Nothing}, UInt32, Ptr{UInt32}), fpga.board, addr, data_ptr)
  err, data_ptr[]
end
#ok_ErrorCode DLL_ENTRY okFrontPanel_WriteRegister(okFrontPanel_HANDLE hnd, UINT32 addr, UINT32 data);
function write_register(fpga::FPGA, addr::UInt32, data::UInt32)::ErrorCode
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_WriteRegister), ErrorCode, (Ptr{Nothing}, UInt32, UInt32), fpga.board, addr, data)
end
#ok_ErrorCode DLL_ENTRY okFrontPanel_ReadRegisters(okFrontPanel_HANDLE hnd, unsigned num, okTRegisterEntry* regs);
#ok_ErrorCode DLL_ENTRY okFrontPanel_WriteRegisters(okFrontPanel_HANDLE hnd, unsigned num, const okTRegisterEntry* regs);

# ----------------------------------------------------------------------------
# PLL Configuration
# ----------------------------------------------------------------------------

# ---------------- PLL22150 ----------------

#ok_ErrorCode DLL_ENTRY okFrontPanel_GetPLL22150Configuration(okFrontPanel_HANDLE hnd, okPLL22150_HANDLE pll);
function ok_front_panel_get_pll22150_configuration(fpga::FPGA)::Tuple{ErrorCode, Ptr{Nothing}}
  pll::Ptr{Nothing} = Ptr{Nothing}(1)
  err = ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_GetPLL22150Configuration), ErrorCode, (Ptr{Nothing}, Ptr{Nothing}), fpga.board, pll)
  err, pll
end
#ok_ErrorCode DLL_ENTRY okFrontPanel_SetPLL22150Configuration(okFrontPanel_HANDLE hnd, okPLL22150_HANDLE pll);
function ok_front_panel_set_pll22150_configuration(fpga::FPGA, pll)::ErrorCode
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_SetPLL22150Configuration), ErrorCode, (Ptr{Nothing}, Ptr{Nothing}), fpga.board, pll)
end
#ok_ErrorCode DLL_ENTRY okFrontPanel_GetEepromPLL22150Configuration(okFrontPanel_HANDLE hnd, okPLL22150_HANDLE pll);
function ok_front_panel_get_eeprom_pll22150_configuration(fpga::FPGA)::Tuple{ErrorCode, Ptr{Nothing}}
  pll::Ptr{Nothing} = Ptr{Nothing}(1)
  err = ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_GetEepromPLL22150Configuration), ErrorCode, (Ptr{Nothing}, Ptr{Nothing}), fpga.board, pll)
  err, pll
end
#ok_ErrorCode DLL_ENTRY okFrontPanel_SetEepromPLL22150Configuration(okFrontPanel_HANDLE hnd, okPLL22150_HANDLE pll);
function ok_front_panel_set_eeprom_pll22150_configuration(fpga::FPGA, pll)::ErrorCode
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_SetEepromPLL22150Configuration), ErrorCode, (Ptr{Nothing}, Ptr{Nothing}), fpga.board, pll)
end

# ---------------- PLL22393 ----------------

#ok_ErrorCode DLL_ENTRY okFrontPanel_GetPLL22393Configuration(okFrontPanel_HANDLE hnd, okPLL22393_HANDLE pll);
function ok_front_panel_get_pll22393_configuration(fpga::FPGA)::Tuple{ErrorCode, Ptr{Nothing}}
  pll::Ptr{Nothing} = Ptr{Nothing}(1)
  err = ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_GetPLL22393Configuration), ErrorCode, (Ptr{Nothing}, Ptr{Nothing}), fpga.board, pll)
  err, pll
end
#ok_ErrorCode DLL_ENTRY okFrontPanel_SetPLL22393Configuration(okFrontPanel_HANDLE hnd, okPLL22393_HANDLE pll);
function ok_front_panel_set_pll22393_configuration(fpga::FPGA, pll)::ErrorCode
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_SetPLL22393Configuration), ErrorCode, (Ptr{Nothing}, Ptr{Nothing}), fpga.board, pll)
end
#ok_ErrorCode DLL_ENTRY okFrontPanel_GetEepromPLL22393Configuration(okFrontPanel_HANDLE hnd, okPLL22393_HANDLE pll);
function ok_front_panel_get_eeprom_pll22393_configuration(fpga::FPGA)::Tuple{ErrorCode, Ptr{Nothing}}
  pll::Ptr{Nothing} = Ptr{Nothing}(1)
  err = ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_GetEepromPLL22393Configuration), ErrorCode, (Ptr{Nothing}, Ptr{Nothing}), fpga.board, pll)
  err, pll
end
#ok_ErrorCode DLL_ENTRY okFrontPanel_SetEepromPLL22393Configuration(okFrontPanel_HANDLE hnd, okPLL22393_HANDLE pll);
function ok_front_panel_set_eeprom_pll22393_configuration(fpga::FPGA, pll)::ErrorCode
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_SetEepromPLL22393Configuration), ErrorCode, (Ptr{Nothing}, Ptr{Nothing}), fpga.board, pll)
end

#ok_ErrorCode DLL_ENTRY okFrontPanel_LoadDefaultPLLConfiguration(okFrontPanel_HANDLE hnd);
function load_default_pll_configuration(fpga::FPGA)::ErrorCode
  ccall(Libdl.dlsym(fpga.lib, :okFrontPanel_LoadDefaultPLLConfiguration), ErrorCode, (Ptr{Nothing}, ), fpga.board)
end


# TODO Implement the following functions
#int DLL_ENTRY okFrontPanel_GetErrorString(int ec, char *buf, int length);
#
#const char* DLL_ENTRY okFrontPanel_GetLastErrorMessage(okFrontPanel_HANDLE hnd);
#
#ok_ErrorCode DLL_ENTRY okFrontPanel_GetFPGAResetProfile(okFrontPanel_HANDLE hnd, ok_FPGAConfigurationMethod method, okTFPGAResetProfile *profile);
#ok_ErrorCode DLL_ENTRY okFrontPanel_GetFPGAResetProfileWithSize(okFrontPanel_HANDLE hnd, ok_FPGAConfigurationMethod method, okTFPGAResetProfile *profile, unsigned size);
#ok_ErrorCode DLL_ENTRY okFrontPanel_SetFPGAResetProfile(okFrontPanel_HANDLE hnd, ok_FPGAConfigurationMethod method, const okTFPGAResetProfile *profile);
#ok_ErrorCode DLL_ENTRY okFrontPanel_SetFPGAResetProfileWithSize(okFrontPanel_HANDLE hnd, ok_FPGAConfigurationMethod method, const okTFPGAResetProfile *profile, unsigned size);
