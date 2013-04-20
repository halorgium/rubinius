require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is "1.9" do
  describe "Fiber#backtrace" do
    it "returns the stack frames" do
      p Fiber.current.backtrace
    end

    it "is not shared between fibers" do
      f0 = Fiber.current
      f1 = Fiber.new {
        # TODO: check f0 backtrace
        Fiber.yield
      }
      f2 = Fiber.new {
        Fiber.yield
      }
      p f0.backtrace
      p f1.backtrace
      p f2.backtrace
    end
  end
end
