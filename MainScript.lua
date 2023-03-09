local repo = 'https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/'
local Linoria = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

--// Create the window //--

local ArtsHub = {}

function ArtsHub.new()
    local self = setmetatable({},{__index=ArtsHub})

    self:LoadUI()
    return self 
end 

function ArtsHub:LoadUI()
   Window = Linoria:CreateWindow({
        Title = "Art's Boosting Hub" , 
        AutoShow = true , 
    })

    --// Load Tabs //--
    local MainTab = Window:AddTab( 'Main' ) 
    local Settings = Window:AddTab( 'Settings' )
end

getgenv().ArtsHub = ArtsHub.new()

Run() ; 
--// tabs //--
