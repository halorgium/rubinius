class Struct
  Struct.new 'Tms', :utime, :stime, :cutime, :cstime

  class Tms
    def initialize(utime=nil, stime=nil, cutime=nil, cstime=nil)
      @utime = utime
      @stime = stime
      @cutime = cutime
      @cstime = cstime
    end
  end

  def self.specialize_initialize
  end
end
