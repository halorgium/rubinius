require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is "1.9" do
  describe "Fiber#alive?" do
    it "is true when running" do
      fib = Fiber.new {
        fib.alive?.should == true
      }
      fib.resume
    end

    it "is true when sleeping" do
      fib = Fiber.new {
        Fiber.yield
      }
      fib.resume
      fib.alive?.should == true
      fib.resume
    end

    it "is false when dead" do
      fib = Fiber.new { }
      fib.resume
      fib.alive?.should == false
    end
  end
end
