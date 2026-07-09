# convert color components in the range 0-255 to hex digits in the range 00-ff, for macro purposes
$data modify storage ethan-arrowood.shulker_preview:data item.red set from storage ethan-arrowood.shulker_preview:data lookups.hex[$(red)]
$data modify storage ethan-arrowood.shulker_preview:data item.green set from storage ethan-arrowood.shulker_preview:data lookups.hex[$(green)]
$data modify storage ethan-arrowood.shulker_preview:data item.blue set from storage ethan-arrowood.shulker_preview:data lookups.hex[$(blue)]
