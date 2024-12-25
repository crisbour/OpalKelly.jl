__precompile__()

module OpalKelly

using Libdl
using Logging
using CEnum
using Test
using Printf

export ErrorCode, BoardModel, FPGA
export get_api_version_major , get_api_version_minor , get_api_version_micro , destruct , get_host_interface_width , is_high_speed , get_board_model , find_usb_device_model , get_board_model_string , get_device_count , get_device_list_model , get_device_list_serial , open_by_serial , is_open , is_remote , enable_asynchronous_transfers , set_bt_pipe_polling_interval , set_timeout , get_device_major_version , get_device_minor_version , reset_fpga , close , get_serial_number , get_device_sensors , get_device_settings , get_device_info_with_size , get_device_id , set_device_id , configure_fpga , configure_fpga_with_reset , configure_fpga_from_memory , configure_fpga_from_memory_with_reset , configure_fpga_from_flash , is_front_panel_enabled , is_front_panel3_supported , update_wire_ins , get_wire_in_value , set_wire_in_value , update_wire_outs , get_wire_out_value , activate_trigger_in , update_trigger_outs , is_triggered , get_trigger_out_vector , get_last_transfer_length , write_to_pipe_in , read_from_pipe_out , write_to_block_pipe_in , read_from_block_pipe_out , write_i2c , read_i2c , flash_erase_sector , flash_write , flash_read , read_register , write_register , ok_front_panel_get_pll22150_configuration , ok_front_panel_set_pll22150_configuration , ok_front_panel_get_eeprom_pll22150_configuration , ok_front_panel_set_eeprom_pll22150_configuration , ok_front_panel_get_pll22393_configuration , ok_front_panel_set_pll22393_configuration , ok_front_panel_get_eeprom_pll22393_configuration , ok_front_panel_set_eeprom_pll22393_configuration , load_default_pll_configuration , get_api_version_major

include("constants.jl")

include("types.jl")
include("c_types.jl")

include("c_wrapper.jl")
include("extension.jl")

include("info.jl")
include("setup.jl")
include("test.jl")
include("utils.jl")


end
