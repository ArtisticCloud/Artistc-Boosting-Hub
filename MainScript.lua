local Rec = loadstring(game:HttpGet(('https://raw.githubusercontent.com/ArtisticCloud/Artistc-Boosting-Hub/master/Places/Rec.lua'),true))()
local Utility = loadstring(game:HttpGet(("https://raw.githubusercontent.com/ArtisticCloud/Artistc-Boosting-Hub/master/Modules/Utility.lua"),true))()
local Info = loadstring(game:HttpGet(("https://raw.githubusercontent.com/ArtisticCloud/Artistc-Boosting-Hub/master/Modules/Info.lua"),true))()
local Commands = loadstring(game:HttpGet(('https://raw.githubusercontent.com/ArtisticCloud/Artistc-Boosting-Hub/master/Modules/Commands.lua'),true))()
local AccountControl = loadstring(game:HttpGet(('https://raw.githubusercontent.com/ArtisticCloud/Artistc-Boosting-Hub/master/Modules/AccountControl.lua'),true))()

loadstring(game:HttpGet( ('https://raw.githubusercontent.com/ArtisticCloud/Artistc-Boosting-Hub/master/Places/Rec.lua') ))
print( "Art's Hub Debug: | Modules Loaded" )
local repo = 'https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/'
local Linoria = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()

local Player = game:GetService( 'Players' ).LocalPlayer
local Mouse = Player:GetMouse()

--// File data //--
local FolderName = "Art's Hub"
local DataFileName = 'Hub Data'
local FilePath = FolderName .. '/' .. DataFileName .. '.txt'

--// Services //--
local UIS = game:GetService( 'UserInputService' ) 
local RunService = game:GetService( 'RunService' )
local Tween = game:GetService( 'TweenService' ) 
local Storage = game:GetService( 'ReplicatedStorage' )

local Remotes = Storage:WaitForChild( 'Remotes' , 20 )
local GameEvents = Storage:WaitForChild( 'GameEvents' , 20 )

Linoria:OnUnload(function()
    print('Linoria Unloaded')
    Linoria.Unloaded = true
end)

local VirtualUser = game:GetService('VirtualUser')
Player.Idled:Connect(function()
    VirtualUser:CaptureController() 
    VirtualUser:ClickButton2(Vector2.new()) 
end)

local ArtsHub = {}

function ArtsHub.new( Main )
    local self = setmetatable({},{
        __index = ArtsHub
    })

    self.Main = Main
    self.Window = Linoria:CreateWindow({
        Title = "Art's Boosting Hub" , 
        AutoShow = true , 
    })

    self.MainTab = nil 
    self.SettingsTab = nil 
    self.RecTab = nil
    self.Data = {}

    if Main == nil or Main == '' then
        self.AccountType = 'Unregistered'
    else
        self.AccountType = (self.Main == Player.Name and 'Main') or 'Alt'
    end 
    print( "Art's Hub Debug: | Account Type: " .. self.AccountType)
    self.Commands = self.AccountType == 'Alt' and Commands.new( self ) or nil

    self.RegisteredAlts = {}

    self.MainGroupBoxes = {}
    self.SettingsGroupBoxes = {}
    self.RecGroupBoxes = {}

    self.UIElements = {}
    self.Linoria = Linoria
    self.AccountControl = AccountControl.new( self )
    self.RecTab = nil

    self:LoadData()
    self:LoadUI()
    self:Events()
    Linoria:Notify( "Art's Hub Initalized. \nPress " .. Info.DefaultKeybind .. ' to toggle' , 12 )

    return self 
end 

function ArtsHub:LoadData()
    local Data = Utility.getData( Info.GDFileName )
    local AccountControlData = Utility.getData( Info.ACFileName )
    if Data then

    end
    if AccountControlData then
        local n = 1
        for Account,Values in pairs( AccountControlData.Accounts ) do
            self.RegisteredAlts[n] = Account
            n = n + 1
        end 
        for i=1,Info.MaxAlts do
            if not self.RegisteredAlts[i] then
                self.RegisteredAlts[i] = ''
            end
        end
        return true
    else
        --// create new account control data
        Linoria:Notify( 'Creating new Account Control Data..' , 8 )
        Utility.saveData( Info.ACFileName , Info.ACFileTemplate )
    end
end

function ArtsHub:LoadUI()
    --// Load Tabs //--
    self.MainTab = self.Window:AddTab( 'Main' ) 
    self.RecTab = self.Window:AddTab( 'Rec.' )
    self.SettingsTab = self.Window:AddTab( 'Settings' )

    --// Group Boxes //--
    self.MainGroupBoxes.LeftOne = self.MainTab:AddLeftGroupbox( 'Account Manager' )

    --// fill group boxes //--
    self.MainGroupBoxes.LeftOne:AddDivider()
    self.MainGroupBoxes.LeftOne:AddLabel( 'Type: ' .. self.AccountType )

    if self.AccountType == 'Main' then
        self.UIElements.Boosting = self.MainGroupBoxes.LeftOne:AddToggle( 'Boosting' , {
            Text = ' Boosting' , 
            Tooltip = 'alts will automatically load the hub when on' , 
        })
        self.MainGroupBoxes.LeftOne:AddLabel( 'Configured Alts:')
        --// display the registered alts //--
        self.MainGroupBoxes.LeftOne:AddLabel( ' ------------------------------   ')
        for i,CurrentAlt in pairs( self.RegisteredAlts ) do
             --// store the element inside of the uielements table so i can change it later //--
            self.UIElements[ 'Alt Label ' .. i ] = self.MainGroupBoxes.LeftOne:AddLabel( '' )
            if CurrentAlt and CurrentAlt ~= '' and CurrentAlt:lower() ~= 'all' then
                self.UIElements[ 'Alt Label ' .. i ]:SetText( self.RegisteredAlts[i] )
            else
                self.UIElements[ 'Alt Label ' .. i ]:SetText( 'None' )
            end 
            self.UIElements[ 'Alt Remove Button ' .. i] = self.MainGroupBoxes.LeftOne:AddButton( 'Remove Account' , function()
                local Label = self.UIElements[ 'Alt Label ' .. i ]
                if self.RegisteredAlts[i] ~= '' then
                    local Response = self.AccountControl:unregisterAccount( self.RegisteredAlts[i] )
                    if Response == 'Success' then
                        --// update the labels and the data //--
                        local Label = self.UIElements[ 'Alt Label ' .. i ]
                        Label:SetText( 'None' ) 
                        self.RegisteredAlts[i] = ''
                        Options[ 'Account Dropdown' ]:SetValue(AccountControl)
                    end
                end
            end)
        end
        self.MainGroupBoxes.LeftOne:AddLabel( ' ------------------------------   ')
        self.MainGroupBoxes.LeftOne:AddInput( 'Add_Alt_Input' , {
            Default = '' , 
            Finished = true , 
    
            Text = 'Add Account' , 
            Tooltip = 'Press Enter to register' , 
    
            Placeholder = 'Account Name..' ,
        })
    elseif self.AccountType == 'Unregistered' then
        self.MainGroupBoxes.LeftOne:AddButton( 'Register As Main' , function()
            local Data = Utility.getData( Info.GDFileName )
            if not Data or Data and Data.Main == '' then
                --// Create a new data set //--
                local NewDataSet = Info.GDFileTemplate
                NewDataSet.Main = Player.Name
                self.AccountType = Player.Name 
                --// Resave the data and unload the ui //--
                Utility.saveData( Info.GDFileName , NewDataSet )
                Linoria:Unload()
            end
        end)
        return 
    end 
    --// Mainboxes Right //--
    if self.AccountType == 'Main' then
        self.MainGroupBoxes.RightOne = self.MainTab:AddRightGroupbox( 'Account Control' )
        self.MainGroupBoxes.RightOne:AddDivider()
        self.MainGroupBoxes.RightOne:AddDropdown( 'Account Dropdown' , {
            Values = self.RegisteredAlts , 
            Text = 'Account' , 
        })
        --// Command Buttons that alts will do //--
        self.MainGroupBoxes.RightOne:AddDropdown( 'OnBall_Dropdown' , {
            Values = Info.CommandTypes.OnBall ,
            Text = 'Onball Command'
        })
        self.MainGroupBoxes.RightOne:AddDropdown( 'OnBall_Data' , {
            Values = {} ,
            Text = '' , 
            Multi = true , 
        })
        self.MainGroupBoxes.RightOne:AddDivider()
        self.MainGroupBoxes.RightOne:AddDropdown( 'OffBall_Dropdown' , {
            Values = Info.CommandTypes.OffBall ,
            Text = 'Offball Command'
        })
        self.MainGroupBoxes.RightOne:AddDropdown( 'OffBall_Data' , {
            Values = {} ,
            Text = '' , 
            Multi = true 
        })
        self.MainGroupBoxes.RightOne:AddLabel( 'Extra Commands' ) 
        self.MainGroupBoxes.RightOne:AddButton( 'Teleport To Main' , function()
            
        end)
        self.MainGroupBoxes.RightOne:AddButton( 'Kick Account' , function()
            
        end)
    end 
    --// global group boxes //--
    self.MainGroupBoxes.LeftTwo = self.MainTab:AddLeftGroupbox( 'Misc.' )
    self.MainGroupBoxes.RightTwo = self.MainTab:AddRightGroupbox( 'Ingame stuff' )

    --// Aimbot //--
    self.UIElements.Aimbot = self.MainGroupBoxes.RightTwo:AddToggle( 'Aimbot' , {
        Text = 'Aimbot' , 
        Default = true , 
        Tooltip = 'Times the bar for you'
    })
    self.UIElements.AimbotSlider = self.MainGroupBoxes.RightTwo:AddSlider( 'Aimbot Slider' , {
        Text = 'Aimbot Slider' , 
        Default = 0.7,
        Min = 0.2 ,
        Max = 1 , 
        Rounding = 2 , 
    })
    --------------------
    --// Join logs //--
    self.UIElements.JoinLogs = self.MainGroupBoxes.LeftTwo:AddToggle( 'Join Logs' , {
        Text = 'Join Logs' , 
        Default = true , 
    })
    -------------------
    --// Remove Usernames //--
    self.UIElements.RemoveTags = self.MainGroupBoxes.LeftTwo:AddToggle( 'Remove NameTags' , {
        Text = 'Remove NameTags' , 
    })
    --------------------------

    --// load rec tab //--
    self.Rec = Rec.new( self , self.RecTab )

    --// Settings right group box //--
    self.SettingsGroupBoxes.RightOne = self.SettingsTab:AddRightGroupbox( 'Extra Settings' )
    self.SettingsGroupBoxes.RightOne:AddDivider()

    local Menu_Keybind = self.SettingsGroupBoxes.RightOne:AddLabel( 'Toggle Keybind' ):AddKeyPicker( 'Toggle_Keybind' , {
        Default = 'LeftAlt' , 
        Text = 'UI Keybind' , 
    })

    Linoria.ToggleKeybind = Options.Toggle_Keybind

    --// Register the events once it is created //--

    --// Managers //--
    ThemeManager:SetLibrary(Linoria)
    SaveManager:SetLibrary(Linoria)

    SaveManager:IgnoreThemeSettings() 
    SaveManager:SetIgnoreIndexes({ 'MenuKeybind' }) 

    ThemeManager:SetFolder(FolderName)
    SaveManager:SetFolder(FolderName .. '/' .. 'Themes')

    ThemeManager:ApplyToTab(self.SettingsTab)

    self:UIEvents()
    task.spawn(function()
        self:Aimbot()
    end)

    --// Keybinds //--
end

function ArtsHub:UIEvents()
    Options.Add_Alt_Input:OnChanged(function()
        local PlayerName , PlayerUserId = Utility.findGlobalPlayer( Options.Add_Alt_Input.Value ) 
        if PlayerName then
            --// Subtract 1 so it doesnt include the "all" section //--
            if PlayerName == self.Main then
                Linoria:Notify( 'Main account cannot be set as alt' , 10 )
                return
            end
            local Feedback = self.AccountControl:registerAccount( PlayerName , PlayerUserId )
            local function ChangeUserIndex()
                for index=1,#self.RegisteredAlts do
                    local value = self.RegisteredAlts[index]
                    if value == '' then
                        self.UIElements[ 'Alt Label ' .. index ]:SetText( PlayerName )
                        self.RegisteredAlts[index] = PlayerName
                        break
                    end
                end
                Options[ 'Account Dropdown' ]:SetValue(AccountControl)
            end
            if Feedback == 'Success' then
                ChangeUserIndex()
            end 
        elseif not PlayerName then
            Linoria:Notify( 'Invalid Name' , 10 )
        end 
    end)
    self.UIElements.Boosting:OnChanged(function()
        local Data = Utility.getData( Info.GDFileName )
        if Data then
            Data.Boosting = self.UIElements.Boosting.Value 
            Utility.saveData( Info.GDFileName , Data )
        end
    end)
    self.UIElements.RemoveTags:OnChanged(function()
        local NameTags = workspace.NameUIFolder 
        local Value = self.UIElements.RemoveTags.Value
        for _,Tag in pairs(NameTags:GetDescendants()) do
            if Tag:IsA( 'BillboardGui' ) then
                Tag.Enabled = not Value 
            end
        end
    end)
    Options['Account Dropdown']:OnChanged(function()
        local NewValue = Options[ 'Account Dropdown' ].Value
        if NewValue == nil then
            return 
        end
        --// Get the account data for it //--
        local AccountControlData = Utility.getData( Info.ACFileName )
        if AccountControlData and AccountControlData.Accounts[NewValue] then
            local AccountData = AccountControlData.Accounts[NewValue]
            Options.OnBall_Dropdown:SetValue(nil)
        else
            Linoria:Notify( 'Could not find data for ' .. NewValue )
        end
    end)
end 

function ArtsHub:Events()
    game.Players.PlayerAdded:Connect(function( PlayerWhoJoined ) 
        if table.find( Info.Snitches , PlayerWhoJoined.Name:lower() ) then
            Player:Kick( PlayerWhoJoined.Name .. ' joined and tried to snitch on you lmao' )
        end 
        if self.UIElements.JoinLogs.Value then
            Linoria:Notify( PlayerWhoJoined.Name .. ' has joined the game' , 30 )
        end
    end)
    game.Players.PlayerRemoving:Connect(function( PlayerWhoLeft )
        if self.UIElements.JoinLogs.Value then
            Linoria:Notify( PlayerWhoLeft.Name .. ' has left the game' , 15 )
        end
    end)
end 

function ArtsHub:Unload()
    Linoria:UnLoad() 
    setmetatable(self,nil)
end 

function ArtsHub:Aimbot()
    repeat task.wait() until Player.Character
    local Character = Player.Character
    local function HandleShooting()
        if self.UIElements.Aimbot.Value and Character:GetAttribute( 'Shooting' ) then 
            repeat task.wait() until (not Character:GetAttribute( 'Shooting') or Character:GetAttribute( 'ShotMeter' ) >= self.UIElements.AimbotSlider.Value)
            task.spawn(function()
                GameEvents.ClientAction:FireServer( 'Shoot' , false )
            end)
            repeat task.wait() until Character:GetAttribute( 'ShotType' ) and Character:GetAttribute( 'LandedShotMeter' )
            Linoria:Notify( 'ShotType: ' .. Character:GetAttribute( 'ShotType' ) .. '\n' .. 'Meter: ' .. Character:GetAttribute( 'LandedShotMeter' ) , 8.5 )
        end
    end
    Player.CharacterAdded:Connect(function( NewCharacter )
        Character = Player.Character
        repeat task.wait() until Character:GetAttribute( 'Shooting' ) ~= nil
        Character:GetAttributeChangedSignal( 'Shooting' ):Connect(HandleShooting)
    end)
    Character:GetAttributeChangedSignal( 'Shooting' ):Connect(HandleShooting)
    Character:GetAttributeChangedSignal( 'AlleyOop' ):Connect(HandleShooting)
end

function ArtsHub:Update()
    --// reset the mouse icon //--
    UIS.MouseIconEnabled = true
end

--// Check is there is any data under the player //--
local Data = Utility.getData( Info.GDFileName )
local AccountControlData = Utility.getData( Info.ACFileName )

if not Data then
    getgenv().ArtsHub = ArtsHub.new()
elseif Data and AccountControlData and AccountControlData.Accounts[Player.Name] or Data and Data.Main == Player.Name then
    print( "Art's Hub Debug: | Data found, registering hub" )
    getgenv().ArtsHub = ArtsHub.new( Data.Main )
end

RunService.RenderStepped:Connect(function()
    if getgenv().ArtsHub and getmetatable(getgenv().ArtsHub) then
        getgenv().ArtsHub:Update()
    end 
    if not getgenv().ArtsHub then
        -- local Data = Utility.getData( Info.GDFileName )
    end
end)
