extends Node

# player
const default_run_speed = 13.0
const default_feet_accel_factor = 9.0
const default_air_accel_factor = 2.0
const default_jump_airtime = 0.7
const default_jump_height = 2.0

# pearl
const pearl_teleport_time = 3.0
const pearl_airtime = 3.0
const pearl_max_height = 30.0

# dumbat
#just barely slower than the shoes, you can toggle shoes on and off really fast
#to cheat its cooldown. Important that it's faster than half the shoe speed boost
const dumbat_chase_speed = default_run_speed*1.9

# shoe
const shoe_lifespan: float = 50.0
const shoe_speed: float = default_run_speed*2.0
