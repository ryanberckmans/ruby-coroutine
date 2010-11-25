require "coroutine.rb"

# consider this (rather silly) elevator:
FLOOR_ONE = 1
FLOOR_TWO = 2
FLOOR_THREE = 3

$requested_floor = nil

def elevator_state_machine( coroutine_controller )
  floor = FLOOR_ONE
  while true
    floor += 1 and coroutine_controller.yield "going up from 1 to 2!" if floor == FLOOR_ONE and $requested_floor > FLOOR_ONE

    floor += 1 and coroutine_controller.yield "going up from 2 to 3!" if floor == FLOOR_TWO and $requested_floor > FLOOR_TWO
    
    floor -= 1 and coroutine_controller.yield "going down from 2 to 1!" if floor == FLOOR_TWO and $requested_floor < FLOOR_TWO

    floor -= 1 and coroutine_controller.yield "going down from 3 to 2!" if floor == FLOOR_THREE and $requested_floor < FLOOR_THREE

    coroutine_controller.yield "elevator already at floor #{$requested_floor}" if floor == $requested_floor
  end
end

c = Coroutine.new { |ctrl| elevator_state_machine ctrl }

$requested_floor = 1
puts c.resume
$requested_floor = 2
puts c.resume # i.e., c.resume returns the parameter passed to the next yield
puts c.resume
$requested_floor = 3
puts c.resume
$requested_floor = 2
puts c.resume
$requested_floor = 1
puts c.resume
$requested_floor = 1
puts c.resume



