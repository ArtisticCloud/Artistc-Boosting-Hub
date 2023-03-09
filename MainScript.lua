local repo = 'https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/'
local Linoria = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

--// Create the window //--
function Run()
    Linoria:CreateWindow({
        Title = "Art's Boosting Hub" , 
        AutoShow = true , 
    })
end 

Run() ; 
--// tabs //--
