--// Art's Hub modules //--
local Utility = loadstring(game:HttpGet(("https://raw.githubusercontent.com/ArtisticCloud/Artistc-Boosting-Hub/master/Modules/Utility.lua"),true))()
local Info = loadstring(game:HttpGet(("https://raw.githubusercontent.com/ArtisticCloud/Artistc-Boosting-Hub/master/Modules/Info.lua"),true))()
local Commands = loadstring(game:HttpGet(('https://raw.githubusercontent.com/ArtisticCloud/Artistc-Boosting-Hub/master/Modules/Commands.lua'),true))()

print( "Art's Hub Debug: | Modules Loaded" )
local repo = 'https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/'
local Linoria = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()

local Places = {
    0000000, --// Park

}

local Player = game:GetService( 'Players' ).LocalPlayer

--// File data //--
local FolderName = "Art's Hub"
local DataFileName = 'Hub Data'
local FilePath = FolderName .. '/' .. DataFileName .. '.txt'

--// Services //--
local UIS = game:GetService( 'UserInputService' ) 
local RunService = game:GetService( 'RunService' )
local Tween = game:GetService( 'TweenService' ) 


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
    self.RegisteredAlts = {}

    self.Snitches = { --// Automatically kick out the game if one of these joins
        'xv_nike' , 
        'errorchekz' ,
        'superfluousbacon' , 
        'zornage' , 
        'luadimer' , 
        'coolius' , 
        'ashleydaballer' , 
    }


    self.MainGroupBoxes = {}

    self:LoadData()
    self:LoadUI()
    self:Events()

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
    self.MainGroupBoxes.LeftOne:AddLabel( 'Type: ' .. AccountType )

    if AccountType == 'Main Account' then
        self.MainGroupBoxes.LeftOne:AddLabel( 'Configured Alts:')
        --// display the registered alts //--
        for i=1,Info.MaxAlts do
            if self.RegisteredAlts[i] then
                self.MainGroupBoxes:AddLabel( self.RegisteredAlts[i] )
            else
                self.MainGroupBoxes:AddLabel( 'None' )
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

function ArtsHub:RegisterAlt( AltName )
    if self.AccountType == 'Main' and #self.RegisterAlts < Info.MaxAlts then
        
    end 
end 

function ArtsHub:Events()
    game.Players.PlayerAdded:Connect(function( PlayerWhoJoined ) 
        if table.find( self.Snitches , PlayerWhoJoined.Name:lower() ) then
            Player:Kick( PlayerWhoJoined.Name .. ' joined and tried to snitch on you lmao' )
        end 
        Linoria:Notify( PlayerWhoJoined.Name .. ' has joined the game' , 30 )
    end)
    game.Players.PlayerRemoving:Connect(function( PlayerWhoLeft )
        Linoria:Notify( PlayerWhoLeft.Name .. ' has left the game' , 15 )
    end)
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
