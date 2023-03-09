local repo = 'https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/'
local Linoria = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Player = game.Players.LocalPlayer 

--// File data //--
local FolderName = "Art's Hub"

--// Services //--
local UIS = game:GetService( 'UserInputService' ) 
local RunService = game:GetService( 'RunService' )
local Tween = game:GetService( 'TweenService' ) 

local ArtsHub = {}

function ArtsHub.new()
    print( ArtsHub )
    local self = setmetatable({},{
        __index = ArtsHub
    })

    self.MainTab = nil 
    self.SettingsTab = nil 
    self.Data = {}

    self.MainGroupBoxes = {}

    self:LoadUI()
    return self 
end 

function ArtsHub:GetData()

end

function ArtsHub:LoadUI( Main )
   self.Window = Linoria:CreateWindow({
        Title = "Art's Boosting Hub" , 
        AutoShow = true , 
    })

    --// Load Tabs //--
    self.MainTab = self.Window:AddTab( 'Main' ) 
    self.SettingsTab = self.Window:AddTab( 'Settings' )

    --// Group Boxes //--
    self.MainGroupBoxes.LeftOne = self.MainTab:AddLeftGroupbox( 'RinBigPapi Gets No Bitches' )
    self.MainGroupBoxes.LeftOne:AddLabel( 'Alts' )

    --// Managers //--
    ThemeManager:SetLibrary(Linoria)
    SaveManager:SetLibrary(Linoria)

    SaveManager:IgnoreThemeSettings() 
    SaveManager:SetIgnoreIndexes({ 'MenuKeybind' }) 

    ThemeManager:SetFolder(FolderName')
    SaveManager:SetFolder(FolderName .. '/' .. 'Themes')

    SaveManager:BuildConfigSection(self.SettingsTab) 
    ThemeManager:ApplyToTab(self.SettingsTab)

    --// Keybinds //--
end

function ArtsHub:Update()

end

getgenv().ArtsHub = ArtsHub.new()

RunService.RenderStepped:Connect(function()
    if getgenv().ArtsHub and getmetatable(getgenv().ArtsHub) then
        getgenv().ArtsHub:Update()
    end 
end)

--// tabs //--
