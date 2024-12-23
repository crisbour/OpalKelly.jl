using Random
using OpalKelly

function test_random_leds(fpga::FPGA)
  ledArray = bitrand(8)
  set_leds(fpga, ledArray)
end

macro show_error(expr)
  return quote
    err = $(esc(expr))
    if err != ok_NoError
      @error "ERROR: $err"
    end
  end
end

function set_leds(fpga::FPGA, ledArray::BitVector)
  ledOut::UInt32=0
  for i=1:8
    if ledArray[i]
      ledOut |= 1 << (i-1)
    end
  end
  OpalKelly.SetWireInValue(fpga, 0, ledOut)
  OpalKelly.UpdateWireIns(fpga)
end

function led_test(fpga::FPGA)
  #LED Test to flash through all LEDs

  addr::Int = 0;
  for v = 0:255
    value = UInt32(v);
    @show_error SetWireInValue(fpga, addr, value);
    @show_error UpdateWireIns(fpga);
    sleep(0.05)
  end

  @show_error SetWireInValue(fpga, addr, UInt32(0));
  @show_error UpdateWireIns(fpga);
end


