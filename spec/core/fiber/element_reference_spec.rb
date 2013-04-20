require File.expand_path('../../../spec_helper', __FILE__)
#require File.expand_path('../fixtures/classes', __FILE__)

describe "Fiber#[]" do
  ruby_version_is "1.9" do
    it "gives access to fiber local values" do
      f = Fiber.new do
        Fiber.current[:value] = 5
      end
      f.resume
      f[:value].should == 5
      Fiber.current[:value].should == nil
    end

    it "is not shared across fibers" do
      f1 = Fiber.new do
        Fiber.current[:value] = 1
      end
      f2 = Fiber.new do
        Fiber.current[:value] = 2
      end
      [f1,f2].each {|x| x.resume}
      f1[:value].should == 1
      f2[:value].should == 2
    end

    it "is accessable using strings or symbols" do
      f1 = Fiber.new do
        Fiber.current[:value] = 1
      end
      f2 = Fiber.new do
        Fiber.current["value"] = 2
      end
      [f1,f2].each {|x| x.resume}
      f1[:value].should == 1
      f1["value"].should == 1
      f2[:value].should == 2
      f2["value"].should == 2
    end

    it "raises exceptions on the wrong type of keys" do
      lambda { Fiber.current[nil] }.should raise_error(TypeError)
      lambda { Fiber.current[5] }.should raise_error(TypeError)
    end
  end
end
