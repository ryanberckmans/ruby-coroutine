
class Coroutine
  def initialize
    @on_resume = lambda { yield self; @dead = true; self.yield } 
  end

  def yield *args
    @on_yield.call nil if @dead
    callcc do |@on_resume|
      @on_yield.call *args
    end
    @on_resume = nil
  end

  def resume
    return if @dead
    yielded = callcc do |@on_yield|
      @on_resume.call
    end
    @on_yield = nil
    yielded
  end
end
