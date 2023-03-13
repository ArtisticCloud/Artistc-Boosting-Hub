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

    self:LoadUI()
    self:Events()

    RecClass = self 

    return self
end

function Rec:LoadUI()
    if self.AccountType == 'Main' then
        self.LobbyGroupBox = self.RecTab:AddLeftGroupbox( 'Rec. Lobby' )
        self.UIElements.RecBoosting = self.LobbyGroupBox:AddToggle( 'Rec_Boosting' , {
            Text = 'Rec Boosting' , 
            Tooltip = 'doesnt do anything yet'
        })
        self.UIElements.AutoStart = self.LobbyGroupBox:AddToggle( 'Auto_Start' , {
            Text = 'Auto Start' , 
            Tooltip = 'Automatically starts when both parties are full'
        })
        self.LobbyGroupBox:AddDropdown( 'Account_Dropdown' , {
            Values = self.RegisteredAlts , 
            Text = 'Other Main' , 
        })
        self.UIElements.MainPartyCode = self.LobbyGroupBox:AddLabel( 'Main Party: None' )
        self.UIElements.AltPartyCode = self.LobbyGroupBox:AddLabel( 'Alt Party: None' )
        self.UIElements.CreateParty = self.LobbyGroupBox:AddButton( 'Create Parties' , function()
            local OtherMain = Options.Account_Dropdown.Value and Utility.isValidAlt( Options.Account_Dropdown.Value )
            if OtherMain and game.Players:FindFirstChild( Options.Account_Dropdown.Value ) then
                local Response = self:createPartyCodes( Options.Account_Dropdown.Value )
            elseif not OtherMain or not game.Players:FindFirstChild( Options.Account_Dropdown.Value ) then
                self.Linoria:Notify( 'Invalid Main' , 8 )
            elseif not game.Players:FindFirstChild( Options.Account_Dropdown.Value ) then
                self.Linoria:Notify( 'Other main isnt in your server' )
            end
        end)
        self.UIElements.PartyCodeInput = self.LobbyGroupBox:AddInput( 'Party Code' , {
            Text = 'Party Code' , 
            Placeholder = 'Code..' , 
        })
        self.UIElements.InviteAlts = self.LobbyGroupBox:AddButton( 'Invite Alts' , function()
            local Accounts = Utility.getData( Info.ACFileName )
            if Accounts then 
                --// Make all the alts join the alt party //--
                for AccountName , AccountData in pairs(Accounts.Accounts) do
                    if not game.Players:FindFirstChild( AccountName ) then
                        self.Linoria:Notify( AccountName .. ' is not in your server' , 9 )
                    elseif game.Players:FindFirstChild( AccountName ) and AccountName ~= self.Main and self.AltParty and not Accounts.Accounts[AccountName].PartyToJoin then
                        --// Join an alt party //--
                        Accounts.Accounts[AccountName].PartyToJoin = self.AltParty
                    end
                    Utility.saveData( Info.ACFileName , Accounts )
                end
                return true 
            end 
        end)
    end
    return true 
end

function Rec:Events()
    if self.UIElements.Other_Main then
        self.UIElements.Other_Main:OnChanged(function()
            local AccountData = Utility.isValidAlt( self.UIElements.Other_Main.Value )
            if AccountData then
                -- self:SetPartyCodes()
            end
        end)
    end
    return true
end

function Rec:createPartyCodes( OtherMain )
    local GeneralData = Utility.getData( Info.GDFileName )
    if GeneralData and Remotes:FindFirstChild( 'Parties' ) then
        local Response , ResponseData = Remotes.Parties:InvokeServer( 'Start' )
        if Response then
            local AccountData , AccountControlData = Utility.isValidAlt( OtherMain )
            if AccountData then
                AccountControlData.Accounts[OtherMain].CreateParty = true 
            end
            print( 'code' , ResponseData.Code )
            GeneralData.Rec.Parties.Main = ResponseData.Code
            Utility.saveData( Info.GDFileName , GeneralData ) 
            self.Linoria:Notify( 'Successfully created main party. Code: ' .. tostring(ResponseData.Code) )
        else
            self.Linoria:Notify( 'Could not start the main party. Error: ' .. tostring(ResponseData.Code) , 8 )
            return
        end
    elseif not Remotes:FindFirstChild( 'Parties' ) then
        self.Linoria:Notify( 'bro your not even in rec' , 8  )
    end
end     

function Rec:JoinParty( Code )
    Remotes.Parties:InvokeServer( 'Leave' )
    local Response = Remotes.Parties:InvokeServer( 'Join' , tostring(Code) )
    if Response == false then
        self.Linoria:Notify( 'there was an error joining the party..' , 10 )
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
                GeneralData.Rec.Parties.Alt = ResponseData.Code
                Utility.saveData( Info.GDFileName , GeneralData )
            end)
            Utility.saveData( Info.ACFileName , AccountControlData )
        end 
    end
    if AccountData.PartyToJoin then
        local Response = self:JoinParty( AccountData.PartyToJoin )
        AccountControlData.Accounts[Player.Name].PartyToJoin = nil 
        Utility.saveData( Info.ACFileName , AccountControlData )
    end
    return true
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
            self:AltEvents()
        end
    end
    if GeneralData then
        local MainPartyCode , AltPartyCode = GeneralData.Rec.Parties.Main or 'None' , GeneralData.Rec.Parties.Alt or 'None'
        self.UIElements.MainPartyCode:SetText(  'Main Party: ' .. MainPartyCode )
        self.UIElements.AltPartyCode:SetText(  'Alt Party: ' .. AltPartyCode )
    end
    return true 
end

game:GetService( 'RunService' ).RenderStepped:Connect(function()
    if RecClass and getmetatable( RecClass ) then
        RecClass:Update()
    end
end)

return Rec
