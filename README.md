# Mcguffin
Get the mcguffin!!

## groups

interactible - has interact(interacter: Player, interact_point: Vector3) and interacted with via raycast from player

entities - players/enemies, has 
hit(damage: int, from_point: Vector3)
signal death (for when they die)

## Fog
The fog is a problem, set in the world environment and lerped to correct value in the gadget api script. The world environment for the level must be local to scene so that when the gadget api goes to copy the original scene, and it modifies the fog settings of the scene, when the scene is reloaded those modifications aren't carried over in its new default. This explanation is bad long story short just toggle local to scene on world environments in levels. 