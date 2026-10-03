# render decorated pot patterns as overlays
# only the left and front faces are visible, on the left and right, respectively
# each face is an optional item stack template ({id:...}) of either a sherd or brick;
# a missing face renders as brick, so default to that before reading the IDs
data modify storage ethan-arrowood.shulker_preview:data tooltip append value {translate:"ethan-arrowood.shulker_preview.overlay"}
data modify storage ethan-arrowood.shulker_preview:data item merge value {left:"minecraft:brick",right:"minecraft:brick"}
data modify storage ethan-arrowood.shulker_preview:data item.left set from storage ethan-arrowood.shulker_preview:data item.components."minecraft:pot_decorations".left.id
data modify storage ethan-arrowood.shulker_preview:data item.right set from storage ethan-arrowood.shulker_preview:data item.components."minecraft:pot_decorations".front.id
function ethan-arrowood.shulker_preview:render/row_1/overlay/pot_patterns2 with storage ethan-arrowood.shulker_preview:data item
data modify storage ethan-arrowood.shulker_preview:data tooltip append value {translate:"ethan-arrowood.shulker_preview.overlay_done"}
