require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is "1.9" do
  describe "Fiber.root" do
    it "is shared between fibers" do
      root = Fiber.root
      Fiber.current.should == root
      fib = Fiber.new {
        Fiber.root.should == root
        Fiber.current.should_not == root
      }
      fib.resume
    end

    it "differs between threads" do
      root = Fiber.root
      th = Thread.new {
        Fiber.root.should_not == root
      }
      th.join
    end
  end
end
