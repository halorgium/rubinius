require File.expand_path('../../../spec_helper', __FILE__)
#require File.expand_path('../fixtures/classes', __FILE__)

describe "Fiber#keys" do
  it "returns an array of the names of the thread-local variables as symbols" do
    th = Fiber.new do
      Fiber.current["cat"] = 'woof'
      Fiber.current[:cat] = 'meow'
      Fiber.current[:dog] = 'woof'
    end
    th.resume
    th.keys.sort_by {|x| x.to_s}.should == [:cat,:dog]
  end

  ruby_version_is "1.9" do
    it "is not shared across fibers" do
      fib = Fiber.new do
        Fiber.current[:val1] = 1
        Fiber.yield
        Fiber.current.keys.should include(:val1)
        Fiber.current.keys.should_not include(:val2)
      end
      Fiber.current.keys.should_not include(:val1)
      fib.resume
      Fiber.current[:val2] = 2
      fib.resume
      Fiber.current.keys.should include(:val2)
      Fiber.current.keys.should_not include(:val1)
    end

    it "stores a local in another thread when in a fiber" do
      fib = Fiber.new do
        t = Fiber.new do
          sleep
          Fiber.current.keys.should include(:value)
        end

        Fiber.pass while t.status and t.status != "sleep"
        t[:value] = 1
        t.wakeup
        t.join
      end
      fib.resume
    end
  end

end
