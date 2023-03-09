repeat task.wait() until game:IsLoaded()
local repo = 'https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/'
local Linoria = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Player = game.Players.LocalPlayer 


local ArtsHub = {}

function ArtsHub.new()
    print( ArtsHub )
    local self = setmetatable({},{
        __index = ArtsHub
    })

    self.MainTab = nil 
    self.Settings = nil 

    self.MainGroupBoxes = {}

    self:LoadUI()
    return self 
end 

function ArtsHub:LoadUI()
   self.Window = Linoria:CreateWindow({
        Title = "Art's Boosting Hub" , 
        AutoShow = true , 
    })

    --// Load Tabs //--
    self.MainTab = self.Window:AddTab( 'Main' ) 
    self.Settings = self.Window:AddTab( 'Settings' )

    --// Group Boxes //--
    self.MainGroupBoxes.One = self.MainTab:AddLeftGroupbox( 'RinBigPapi Gets No Bitches' )
end

function ArtsHub:Update()

end

getgenv().ArtsHub = ArtsHub.new()

--// tabs //--
