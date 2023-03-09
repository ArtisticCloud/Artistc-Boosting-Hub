local repo = 'https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/'
local Linoria = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()

local Places = {

}

local Player = game.Players.LocalPlayer 

--// File data //--
local FolderName = "Art's Hub"
local DataFileName = 'Hub Data'
local FilePath = FolderName .. '/' .. DataFileName .. '.txt'

--// Services //--
local UIS = game:GetService( 'UserInputService' ) 
local RunService = game:GetService( 'RunService' )
local Tween = game:GetService( 'TweenService' ) 

print('utility' , Utility)

function Utility.findGlobalPlayer( Username )
    local UserId 
    local s,e = pcall(function()
        UserId = game.Players:GetUserIdFromNameAsync( Username )
    end)
    if UserId then
        local Exists 
        local s,e = pcall(function()
            Exists = game.Players:GetNameFromUserIdAsync( UserId )
        end)
        return Exists
    end 
end 

function Utility.saveData( Data )
    makefolder( FolderName )
    writefile( FilePath )
end 

function Utility.getData()
    if isfile( FilePath ) then
        return readfile( FilePath )
    end 
end 

local ArtsHub = {}

function ArtsHub.new( Main )
    local self = setmetatable({},{
        __index = ArtsHub
    })

    self.Main = Main

    self.MainTab = nil 
    self.SettingsTab = nil 
    self.Data = {}

    self.AccountType = (self.Main == Player.Name and 'Main') or 'Alt'

    self.Snitches = { --// Automatically kick out the game if one of these joins
        'xv_nike' , 
        'errorchekz' ,
        'superflousbacon' , 
        'zornage' , 
        'luadimer' , 
        'coolius' , 

    }

    self.MainGroupBoxes = {}

    self:LoadData()
    self:LoadUI()

    return self 
end 

function ArtsHub:LoadData()
    
end

function ArtsHub:LoadUI( )
   self.Window = Linoria:CreateWindow({
        Title = "Art's Boosting Hub" , 
        AutoShow = true , 
    })

    --// Load Tabs //--
    self.MainTab = self.Window:AddTab( 'Main' ) 
    self.SettingsTab = self.Window:AddTab( 'Settings' )

    --// Group Boxes //--
    self.MainGroupBoxes.LeftOne = self.MainTab:AddLeftGroupbox( 'Account Manager' )

    --// fill group boxes //--
    local AccountType = (self.Main == Player.Name and 'Main Account') or 'Alt Account'
    self.MainGroupBoxes.LeftOne:AddLabel( AccountType )

    if AccountType == 'Main Account' then
        self.MainGroupBoxes.LeftOne:AddLabel( 'Configured Alts:')
        if self.Data.LoadedAlts == nil or #self.Data.LoadedAlts == 0 then
            self.MainGroupBoxes.LeftOne:AddLabel( 'None')
        else
            for _ , Alt in self.Data.LoadedAlts do
                self.MainGroupBoxes.LeftOne:AddLabel( Alt )
            end 
        end 
        self.MainGroupBoxes.LeftOne:AddInput( 'Add_Alt_Input' , {
            Default = 'Add A New Alt' , 
            Finished = true , 
    
            Text = '' , 
            Tooltip = 'add account' , 
    
            Placeholder = 'Account Name..' ,
        })
    end 

    --// Managers //--
    ThemeManager:SetLibrary(Linoria)
    SaveManager:SetLibrary(Linoria)

    SaveManager:IgnoreThemeSettings() 
    SaveManager:SetIgnoreIndexes({ 'MenuKeybind' }) 

    ThemeManager:SetFolder(FolderName)
    SaveManager:SetFolder(FolderName .. '/' .. 'Themes')

    ThemeManager:ApplyToTab(self.SettingsTab)

    --// Keybinds //--
end

function ArtsHub:Unload()
    Linoria:UnLoad() 
    setmetatable(self,nil)
end 

function ArtsHub:Update()

end

getgenv().ArtsHub = ArtsHub.new( 'iArtisticDev' )

RunService.RenderStepped:Connect(function()
    if getgenv().ArtsHub and getmetatable(getgenv().ArtsHub) then
        getgenv().ArtsHub:Update()
    end 
end)

--// tabs //--
