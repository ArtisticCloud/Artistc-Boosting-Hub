--// Art's Hub modules //--
local Utility = loadstring(game:HttpGet(("https://raw.githubusercontent.com/ArtisticCloud/Artistc-Boosting-Hub/master/Modules/Utility.lua"),true))()
local Info = loadstring(game:HttpGet(("https://raw.githubusercontent.com/ArtisticCloud/Artistc-Boosting-Hub/master/Modules/Info.lua"),true))()
local Commands = loadstring(game:HttpGet(('https://raw.githubusercontent.com/ArtisticCloud/Artistc-Boosting-Hub/master/Modules/Commands.lua'),true))()
local AccountControl = loadstring(game:HttpGet(('https://raw.githubusercontent.com/ArtisticCloud/Artistc-Boosting-Hub/master/Modules/AccountControl.lua'),true))()

print( "Art's Hub Debug: | Modules Loaded" )
local repo = 'https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/'
local Linoria = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()

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
    self.AccountControl = AccountControl.new( self )

    self.MainTab = nil 
    self.SettingsTab = nil 
    self.Data = {}

    self.AccountType = (self.Main == Player.Name and 'Main') or 'Alt'
    self.RegisteredAlts = {
        'iArtisticDev' , 
        'All' , 
    }

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
    self.SettingsGroupBoxes = {}

    self:LoadData()
    self:LoadUI()
    self:Events()
    Linoria:Notify( "Art's Hub Initalized. \nPlease use Khyshub along with this hub. \nim not making you an auto timer" , 12 )

    return self 
end 

function ArtsHub:LoadData()
    local Data = Utility.getData( Utility.GDFileName )
    if Data then
        self.RegisteredAlts = Data.Alts 
        self.Main = Data.Main
    end
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
    self.MainGroupBoxes.LeftOne:AddDivider()
    self.MainGroupBoxes.LeftOne:AddLabel( 'Type: ' .. AccountType )

    if self.Main == nil or self.Main == '' then
        AccountType == 'Unregistered'
    end

    if AccountType == 'Main Account' then
        self.MainGroupBoxes.LeftOne:AddLabel( 'Configured Alts:')
        --// display the registered alts //--
        self.MainGroupBoxes.LeftOne:AddLabel( ' ------------------------------   ')
        for i=1,Info.MaxAlts do
            local CurrentAlt = self.RegisteredAlts[i]
            if CurrentAlt and CurrentAlt:lower() ~= 'all' then
                local AccountLabel = self.MainGroupBoxes.LeftOne:AddLabel( self.RegisteredAlts[i] )
                self.MainGroupBoxes.LeftOne:AddButton( 'Remove ' .. self.RegisteredAlts[i] , function()
                    --// remove the registered alt here //--
                    
                end)
            else
                self.MainGroupBoxes.LeftOne:AddLabel( 'None' )
                self.MainGroupBoxes.LeftOne:AddButton( 'Remove None ' .. i , function() 
                    --// no alt registered so do nothing basically
                end)
            end 
        end
        self.MainGroupBoxes.LeftOne:AddLabel( ' ------------------------------   ')

        self.MainGroupBoxes.LeftOne:AddInput( 'Add_Alt_Input' , {
            Default = '' , 
            Finished = true , 
    
            Text = 'Add Account' , 
            Tooltip = 'Press Enter to register' , 
    
            Placeholder = 'Account Name..' ,
        })
    elseif AccountType == 'Unregistered' then

    end 
    --// Mainboxes Right //--
    if self.AccountType == 'Main' then
        self.MainGroupBoxes.RightOne = self.MainTab:AddRightGroupbox( 'Account Control' )
        self.MainGroupBoxes.RightOne:AddDivider()
        self.MainGroupBoxes.RightOne:AddDropdown( 'Account Dropdown' , {
            Multi = true , 
            Values = self.RegisteredAlts , 
            Text = 'Account' , 
        })
        --// Command Buttons that alts will do //--
        self.MainGroupBoxes.RightOne:AddLabel( 'Commands' ) 
        self.MainGroupBoxes.RightOne:AddButton( 'Teleport To Main' , function()
            
        end)
        self.MainGroupBoxes.RightOne:AddButton( 'Clear Commands' , function()
            
        end)
    end 

    --// Settings right group box //--
    self.SettingsGroupBoxes.RightOne = self.SettingsTab:AddRightGroupbox( 'Extra Settings' )
    self.SettingsGroupBoxes.RightOne:AddDivider()
    self.SettingsGroupBoxes.RightOne:AddLabel( 'Toggle Keybind' ):AddKeyPicker( 'Toggle_Keybind' , {
        Default = 'Left' , 
        Text = 'UI Keybind' , 
    })
    Linoria.ToggleKeybind = Options.Toggle_Keybind

    --// Register the events once it is created //--
    self:UIEvents()

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

function ArtsHub:UIEvents()
    Options.Add_Alt_Input:OnChanged(function()
        local PlayerName , PlayerUserId = Utility.findGlobalPlayer( Options.Add_Alt_Input.Value ) 
        if PlayerName then
            --// Subtract 1 so it doesnt include the "all" section //--
            if #self.RegisteredAlts - 1 >= Utility.MaxAlts then
                Linoria:Notify( 'Alt capacity reached. \n Try deleting an alt' , 10 )
            end
            if PlayerName == self.Main then
                Linoria:Notify( 'Main account cannot be set as alt' , 10 )
                return
            end
            self.AccountControl:registerAccount( PlayerName , PlayerUserId )
        end 
    end)
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

--// Check is there is any data under the player //--
local Data = Utility.getData( Info.GDFileName )
if not Data then
    print( "Art's Hub Debug: | User has not data, creating a new data set" )
    Utility.saveData( Info.GDFileName , Info.GDFileTemplate )
else
    getgenv().ArtsHub = ArtsHub.new( Data.Main )
end

RunService.RenderStepped:Connect(function()
    if getgenv().ArtsHub and getmetatable(getgenv().ArtsHub) then
        getgenv().ArtsHub:Update()
    end 
end)

--// tabs //--
