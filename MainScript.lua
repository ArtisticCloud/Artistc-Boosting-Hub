local repo = 'https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/'
local Linoria = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

--// Create the window //--

local ArtsHub = {}

function ArtsHub.new()
    print( ArtsHub )
    local self = setmetatable({},{
        __index = ArtsHub
    })

    self.MainTab = nil 
    self.Settings = nil 

    self:LoadUI()
    return self 
end 

function ArtsHub:LoadUI()
   self.Window = Linoria:CreateWindow({
        Title = "Art's Boosting Hub" , 
        AutoShow = true , 
    })

    --// Load Tabs //--
    print( 'Loading tabs' )
    self.MainTab = Window:AddTab( 'Main' ) 
    self.Settings = Window:AddTab( 'Settings' )
end

getgenv().ArtsHub = ArtsHub.new()

Run() ; 
--// tabs //--
