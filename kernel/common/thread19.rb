class Thread
  MUTEX_FOR_THREAD_EXCLUSIVE = Mutex.new

  def Thread.exclusive
    MUTEX_FOR_THREAD_EXCLUSIVE.synchronize { yield }
  end

  def root_fiber
    Rubinius.primitive :thread_root_fiber
    raise PrimitiveFailure, "Thread#root_fiber primitive failed"
  end
end
