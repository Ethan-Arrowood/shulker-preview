# when necessary, NBT lookups are faster in storage, and permit destructive iteration
# so pre-emptively copy the shulker box items to storage
data modify storage ethan-arrowood.shulker_preview:data contents set from entity @s Item.components."minecraft:container"

# we can directly modify this item, it doesn't need to be copied anywhere
function ethan-arrowood.shulker_preview:process
