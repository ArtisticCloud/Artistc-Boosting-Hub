local Rec = {}

local Utility = loadstring(game:HttpGet(("https://raw.githubusercontent.com/ArtisticCloud/Artistc-Boosting-Hub/master/Modules/Utility.lua"),true))()
local Info = loadstring(game:HttpGet(("https://raw.githubusercontent.com/ArtisticCloud/Artistc-Boosting-Hub/master/Modules/Info.lua"),true))()
local AccountControl = loadstring(game:HttpGet(('https://raw.githubusercontent.com/ArtisticCloud/Artistc-Boosting-Hub/master/Modules/AccountControl.lua'),true))()

local Player = game.Players.LocalPlayer 
local Storage = game:GetService( 'ReplicatedStorage' )

local Remotes = Storage:WaitForChild( 'Remotes' , 20 )

local RecClass = nil 
function Rec.new( Hub , RecTab )
    print( 'was called' )
    local self = setmetatable({},{
        __index = function( Table , Index , Value )
            if not Rec[Index] then
                return Hub[Index]
            end
            return Rec[Index]
        end,
    })

    self.RecTab = RecTab
    self.UIElements = {}

    self.LobbyGroupBox = nil

    self.MainParty = nil 
    self.AltParty = nil 
    self.LastPartyCreation = tick()

    self:LoadUI()
    self:Events()

    RecClass = self 

    return self
end

function Rec:LoadUI()
    if self.AccountType == 'Main' then
        --// reset party data //--
        local GeneralData = Utility.getData( Info.GDFileName )
        self:GlobalLeaveParty()
        GeneralData.Rec.Parties.Main = nil 
        GeneralData.Rec.Parties.Alt = nil 
        Utility.saveData( Info.GDFileName , GeneralData )

        self.LobbyGroupBox = self.RecTab:AddLeftGroupbox( 'Rec. Lobby' )
        self.LobbyGroupBox:AddDivider()
        self.UIElements.RecBoosting = self.LobbyGroupBox:AddToggle( 'Rec_Boosting' , {
            Text = 'Rec Boosting' , 
            Tooltip = 'doesnt do anything yet'
        })
        self.UIElements.AutoStart = self.LobbyGroupBox:AddToggle( 'Auto_Start' , {
            Text = 'Auto Start' , 
            Tooltip = 'Automatically starts when both parties are full'
        })
        self.LobbyGroupBox:AddDivider()
        self.LobbyGroupBox:AddDropdown( 'Account_Dropdown' , {
            Values = self.RegisteredAlts , 
            Text = 'Other Main' , 
        })
        self.UIElements.MainPartyCode = self.LobbyGroupBox:AddLabel( 'Main Party: None' )
        self.UIElements.AltPartyCode = self.LobbyGroupBox:AddLabel( 'Alt Party: None' )
        self.UIElements.CreateParty = self.LobbyGroupBox:AddButton( 'Create Parties' , function()
            if tick() - self.LastPartyCreation < 3 then
                self.Linoria:Notify( 'Please wait ' .. math.round( (3 - (tick() - self.LastPartyCreation)) * 1000 ) * 1000)
                return
            end
            local OtherMain = Options.Account_Dropdown.Value and Utility.isValidAlt( Options.Account_Dropdown.Value )
            if OtherMain and game.Players:FindFirstChild( Options.Account_Dropdown.Value ) then
                self.LastPartyCreation = tick()
                local Response = self:createPartyCodes( Options.Account_Dropdown.Value )
            elseif not OtherMain or not game.Players:FindFirstChild( Options.Account_Dropdown.Value ) then
                self.Linoria:Notify( 'Invalid Main' , 8 )
            elseif not game.Players:FindFirstChild( Options.Account_Dropdown.Value ) then
                self.Linoria:Notify( 'Other main isnt in your server' )
            end
        end)
        self.LobbyGroupBox:AddDivider()
        self.LobbyGroupBox:AddDropdown( 'Party_Type' , {
            Values = {'Main','Alt'} , 
            Text = 'Party Type' , 
        })
        self.UIElements.InviteAlts = self.LobbyGroupBox:AddButton( 'Invite Alts' , function()
            local Party = GeneralData.Rec.Parties[Options.Party_Type.Value]
            local AccountControlData = Utility.getData( Info.ACFileName )
            if AccountControlData and Party then
                for Account,AccountData in pairs(AccountControlData.Accounts) do
                    if AccountData.Online and game.Players:FindFirstChild( Account ) then
                        AccountControlData.Accounts[Account].JoinParty = Party
                    end
                end
                Utility.saveData( Info.ACFileName , AccountControlData )
            else
                self.Linoria:Notify( 'There is no' .. Options.Party_Type.Value ..  'party' , 7.5 )
            end
            return true
        end)
    end
    --// rec q //--
    self.QGroupBox = self.RecTab:AddLeftGroupbox( 'Rec. Queue' )
    self.QGroupBox:AddButton( 'Back to Lobby' , function() 
        if self.AccountType == 'Main' and game.PlaceId == Info.Places.RecQ and Options.Rec_Boosting.Value then
            Remotes.Teleport:InvokeServer( 'Rec Lobby' )
        end
    end)
    self.MatchGroupBox = self.RecTab:AddRightGroupbox( 'Rec. Match' )
    self.UIElements.Remove_Out_Of_Bounds = self.MatchGroupBox:AddToggle( 'Remove_Out_Of_Bounds' , {
        Text = 'Remove Out Of Bounds' 
    })

    return true 
end

function Rec:GlobalLeaveParty()
    local AccountControl = Utility.getData( Info.ACFileName )
    if self.AccountType == 'Main' and Remotes:FindFirstChild( 'Parties' ) then
        Remotes.Parties:InvokeServer( 'Leave' )
    end
    if AccountControl then
        for Account,Data in pairs(AccountControl.Accounts) do
            AccountControl.Accounts[Account].LeaveParty = true
        end
        Utility.saveData( Info.ACFileName , AccountControl )
    end
    return true
end

function Rec:Events()
    self.UIElements.Remove_Out_Of_Bounds:OnChanged(function()
        local Collection = game:GetService( 'CollectionService' )
        for _,Part in pairs(Collection:GetTagged("OutOfBounds")) do
            Part.Parent = (self.UIElements.Remove_Out_Of_Bounds.Value and Storage) or (workspace)
        end 
    end)
    return true
end

function Rec:createPartyCodes( OtherMain )
    local GeneralData = Utility.getData( Info.GDFileName )
    self:GlobalLeaveParty()
    if GeneralData and Remotes:FindFirstChild( 'Parties' ) then
        local Response , ResponseData = Remotes.Parties:InvokeServer( 'Start' )
        local AccountData , AccountControlData = Utility.isValidAlt( OtherMain )
        --// tell alt to create party //--
        if AccountData then
            AccountControlData.Accounts[OtherMain].CreateParty = true 
            Utility.saveData( Info.ACFileName , AccountControlData )
        end
        if Response then
            GeneralData.Rec.Parties.Main = ResponseData
            Utility.saveData( Info.GDFileName , GeneralData ) 
            self.Linoria:Notify( 'Successfully created main party. Code: ' .. tostring(ResponseData.Code) )
        else
            self.Linoria:Notify( 'Could not start the main party. Error: ' .. tostring(ResponseData.Code) , 9 )
            return
        end
    elseif not Remotes:FindFirstChild( 'Parties' ) then
        self.Linoria:Notify( 'bro your not even in rec' , 9  )
    end
end     

function Rec:JoinParty( Code )
    Remotes.Parties:InvokeServer( 'Leave' )
    local Response , ResponseData = Remotes.Parties:InvokeServer( 'Join' , tostring(Code) )
    if Response == false then
        self.Linoria:Notify( 'there was an error joining the party, error: ' ..  tostring(ResponseData) , 9 )
        return
    end
    self.Linoria:Notify( 'Successfully joined party through code: ' .. '"' .. Code .. '"' )
end

function Rec:AltEvents( AccountData , AccountControlData )
    if AccountData.CreateParty then
        AccountControlData.Accounts[Player.Name].CreateParty = nil 
        local GeneralData = Utility.getData( Info.GDFileName )
        if GeneralData then
            task.spawn(function()
                Remotes.Parties:InvokeServer( 'Leave' )
                local Response , ResponseData = Remotes.Parties:InvokeServer( 'Start' )
                GeneralData.Rec.Parties.Alt = ResponseData
                if GeneralData.Rec.Parties.Alt and GeneralData.Rec.Parties.Main then
                    Utility.sendMessageThroughBot( 'Party Codes:' , 'Main: ' .. GeneralData.Rec.Parties.Main.Code .. ' | \n' .. GeneralData.Rec.Parties.Alt.Code .. ' |' )
                end
                Utility.saveData( Info.GDFileName , GeneralData )
            end)
        end 
        Utility.saveData( Info.ACFileName , AccountControlData )
    end
    if AccountData.JoinParty then
        local Response = self:JoinParty( AccountData.JoinParty.Code )
        AccountControlData.Accounts[Player.Name].JoinParty = nil 
        Utility.saveData( Info.ACFileName , AccountControlData )
    end
    if AccountData.LeaveParty then
        if Remotes:FindFirstChild( 'Parties' ) then
            Remotes.Parties:InvokeServer( 'Leave' )
        end
        AccountControlData.Accounts[Player.Name].LeaveParty = nil
        Utility.saveData( Info.ACFileName , AccountControlData )
    end
    if AccountData.BeginMatch then 
        Remotes.Teleport:InvokeServer( 'Ranked Queue' )
        AccountControlData.Accounts[Player.Name].BeginMatch = nil
        Utility.saveData( Info.ACFileName , AccountControlData )
    end
    return true
end

function Rec:IsInParty( Name )
    local Parties = Storage:FindFirstChild( 'Parties' )
    local GeneralData = Utility.getData( Info.GDFileName )
    if not Parties or not GeneralData then
        return false
    end
    for _,Party in pairs(Parties:GetChildren()) do
        if Party:FindFirstChild( Name , true ) or Party:GetAttribute( 'Leader' ) == Name then
            return true
        end
    end
    return false
end

function Rec:Update()
    local AccountControlData = Utility.getData( Info.ACFileName )
    local GeneralData = Utility.getData( Info.GDFileName )
    if self.AccountType == 'Main' then
        --// only update account dropdown if main //--
        Options.Account_Dropdown:SetValue( self.RegisteredAlts or {} ) 
    end
    if self.AccountType == 'Alt' and AccountControlData then
        local MyData = AccountControlData.Accounts[Player.Name]
        if MyData then
            self:AltEvents( MyData , AccountControlData )
        end
    end
    if GeneralData and self.AccountType == 'Main' then
        local MainPartyCode , AltPartyCode = GeneralData.Rec.Parties.Main or 'None' , GeneralData.Rec.Parties.Alt or 'None'

        local MainPartyCode = type(MainPartyCode) ~= 'string' and MainPartyCode.Code or MainPartyCode
        local AltPartyCode = type(AltPartyCode) ~= 'string' and AltPartyCode.Code or AltPartyCode

        self.UIElements.MainPartyCode:SetText(  'Main Party: ' .. MainPartyCode )
        self.UIElements.AltPartyCode:SetText(  'Alt Party: ' .. AltPartyCode )
    end
    --// Auto start //--
    if GeneralData and self.UIElements.Auto_Start and self.UIElements.Auto_Start.Value and game.PlaceId == Info.Places.RecLobby then
        local Party1 , Party2 = Storage.Parties:FindFirstChild( GeneralData.Rec.Parties.Main.Party ) , Storage.Parties:FindFirstChild( GeneralData.Rec.Parties.Alt.Party )
            --// check the sizes of them //--
        if Party1 and Party2 and #Party1.Players:GetChildren() >= 5 and #Party2.Players:GetChildren() >= 5 then
            Remotes.Teleport:InvokeServer( 'Ranked Queue' )
            local AccountControlData = Utility.getData( Info.ACFileName )
            --// find other main from accountdata through party leader attribute //--
            local OtherMain = AccountControlData and AccountControlData.Accounts[Party2:GetAttribute( 'Leader' )] or AccountControlData and AccountControlData.Accounts[Party1:GetAttribute( 'Leader' )]
            if OtherMain then
                AccountControlData.Accounts[ OtherMain ].BeginMatch = true
                AccountData.saveData( Info.ACFileName , AccountControlData )
            end
        end
    end
    return true 
end

game:GetService( 'RunService' ).RenderStepped:Connect(function()
    if RecClass and getmetatable( RecClass ) then
        RecClass:Update()
    end
end)

game.Players.LocalPlayer.Destroying:Connect(function()
    local AccountControl = Utility.getData( Info.ACFileName )
    if AccountControl then
        AccountControl.Accounts[Player.Name].Online = false 
        Utility.saveData( Info.ACFileName , AccountControl )
    end
end)



return Rec