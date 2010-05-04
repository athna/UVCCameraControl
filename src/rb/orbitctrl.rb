require "osx/foundation"
OSX.require_framework('IOKit')
require "osx/cocoa"
require "uvccameracontrol"

class OrbitControl
  def initialize(vendor_id = 0x046d,product_id = 0x0994)
    @vendor = vendor_id
    @product = product_id
    @camera_control = nil
  end

  def cmd(cmd,val)
    case cmd
    when /reset/
      reset
    when /pan/
      pan(val.to_i)
    when /tilt/
      tilt(val.to_i)
    end
  end

  def close 
    # @camera_control.release
    @camera_control = nil
  end

  def reset
    open_control unless @camera_control
    tilt(10)
    sleep 10
    @camera_control.resetTiltPan(true)
  end

  def pan(val)
    open_control unless @camera_control
    @camera_control.setPanTilt_withPan_withTilt(false,
                               val,0)
  end

  def tilt(val)
    open_control unless @camera_control
    @camera_control.setPanTilt_withPan_withTilt(false,
                               0,val)
  end

  private 
  def open_control
  #  @camera_control = OSX::UVCCameraControl.alloc.initWithVendorID_productID(
  #    @vendor.to_i,0x0994)
    @camera_control = OSX::UVCCameraControl.alloc.initWithVendorID_productID(
      @vendor, @product)
  end

  def close_control
    @camera_control.release
  end

end


if __FILE__ == $0
  oc = OrbitControl.new
  oc.cmd(ARGV[0],ARGV[1])
  #  oc.reset
#  oc.pan(1)
#  oc.tilt(1)
end
