# -*- encoding: us-ascii -*-

module Rubinius
  class Fiber
    def self.create(callable)
      Rubinius.primitive :fiber_new
      raise NotImplementedError, "Fibers not supported on this platform"
    end

    def self.new(size=0, &block)
      if block.nil?
        raise ArgumentError, "Fiber.new requires a block"
      end

      create(block)
    end

    def self.current
      Rubinius.primitive :fiber_s_current
      raise PrimitiveFailure, "Rubinius::Fiber.current failed"
    end

    def self.root
      Rubinius.primitive :fiber_s_root
      raise PrimitiveFailure, "Rubinius::Fiber.root failed"
    end

    def self.yield(*args)
      Rubinius.primitive :fiber_s_yield
      raise PrimitiveFailure, "Rubinius::Fiber.yield failed"
    end

    def resume(*args)
      Rubinius.primitive :fiber_resume
      raise PrimitiveFailure, "Rubinius::Fiber#resume failed"
    end

    def transfer(*args)
      Rubinius.primitive :fiber_transfer
      raise PrimitiveFailure, "Rubinius::Fiber#transfer failed"
    end

    def alive?
      # FIXME: why is the ivar present after death but not before
      !@dead
    end

    def status
      Rubinius.primitive :fiber_status
      raise PrimitiveFailure, "Rubinius::Fiber#status failed"
    end

    def mri_backtrace
      Rubinius.primitive :fiber_mri_backtrace
      raise PrimitiveFailure, "Rubinius::Fiber#mri_backtrace failed"
    end

    def backtrace
      mri_backtrace.map do |tup|
        code = tup[0]
        line = tup[1]
        is_block = tup[2]
        name = tup[3]

        "#{code.active_path}:#{line}:in `#{name}'"
      end
    end

    def [](key)
      @locals ||= Rubinius::LookupTable.new
      @locals[key]
    end

    def []=(key, value)
      @locals ||= Rubinius::LookupTable.new
      @locals[key] = value
    end

    def keys
      @locals ||= Rubinius::LookupTable.new
      @locals.keys
    end

    def alive?
      !@dead
    end
  end
end
