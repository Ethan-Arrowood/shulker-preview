# first install, set default settings and show a welcome message
scoreboard players set #install shulker_preview 1
scoreboard players set #shulker_enabled shulker_preview 1
scoreboard players set #ender_enabled shulker_preview 1
scoreboard players set #colors_enabled shulker_preview 1
tellraw @a {translate:"ethan-arrowood.shulker_preview.translate",fallback:"%1$s",with:[{text:"\nDon't forget to equip the shulker preview resource pack!\n",color:"#8fdff7"},""]}
tellraw @a [{text:"\nSuccessfully installed ",color:"#8fdff7"},{text:"Ethan Arrowood's",color:"#468beb",hover_event:{action:"show_text",value:{text:"(click for the project page — a fork of tryashtar's original pack)",color:"gray"}},click_event:{action:"open_url",url:"https://github.com/Ethan-Arrowood/shulker-preview"}},{text:" Shulker Preview Pack!\nThank you and enjoy.",color:"#8fdff7"},"\n",{text:"Click here to change settings for the pack.",color:"#56d656",underlined:true,hover_event:{action:"show_text",value:{text:"/function ethan-arrowood.shulker_preview:config/show_settings",color:"gray"}},click_event:{action:"run_command",command:"/function ethan-arrowood.shulker_preview:config/show_settings"}},"\n"]
