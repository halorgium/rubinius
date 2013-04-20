require File.expand_path('../../../spec_helper', __FILE__)
#require File.expand_path('../fixtures/classes', __FILE__)

describe "Fiber#[]=" do
  ruby_version_is ""..."1.9" do
    it "raises exceptions on the wrong type of keys" do
      lambda { Fiber.current[nil] = true }.should raise_error(TypeError)
      lambda { Fiber.current[5] = true }.should raise_error(ArgumentError)
    end
  end

  ruby_version_is "1.9" do
    it "raises exceptions on the wrong type of keys" do
      lambda { Fiber.current[nil] = true }.should raise_error(TypeError)
      lambda { Fiber.current[5] = true }.should raise_error(TypeError)
    end

    it "is not shared across fibers" do
      fib = Fiber.new do
        Fiber.current[:value] = 1
        Fiber.yield
        Fiber.current[:value].should == 1
      end
      fib.resume
      Fiber.current[:value].should be_nil
      Fiber.current[:value] = 2
      fib.resume
      Fiber.current[:value] = 2
    end

    it "stores a local in another thread when in a fiber" do
      raise "is this useful?"
      fib = Fiber.new do
        t = Thread.new do
          sleep
          Fiber.current[:value].should == 1
        end

        Thread.pass while t.status and t.status != "sleep"
        t[:value] = 1
        t.wakeup
        t.join
      end
      fib.resume
    end
  end
end
