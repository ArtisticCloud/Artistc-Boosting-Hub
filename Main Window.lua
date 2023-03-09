local repo = 'https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/'
local Linoria = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local init = require(init)  
print( 'init' , init ) 

--// Create the window //--
Linoria:CreateWindow({
    Title = "Art's Boosting Hub" , 
    AutoShow = true , 
})

--// tabs //--