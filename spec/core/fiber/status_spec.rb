require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is "1.9" do
  describe "Fiber#status" do
    it "is running when running" do
      Fiber.current.status.should == "running"
      fib = Fiber.new {
        fib.status.should == "running"
      }
      fib.resume
    end

    it "is sleeping when sleeping" do
      fib = Fiber.new {
        Fiber.root.status.should == "sleeping"
        Fiber.yield
      }
      fib.resume
      fib.status.should == "sleeping"
      fib.resume
    end

    it "is false when dead" do
      fib = Fiber.new { }
      fib.resume
      fib.status.should == "dead"
    end
  end
end
