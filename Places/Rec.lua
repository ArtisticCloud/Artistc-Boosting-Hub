local Rec = {}

local Utility = loadstring(game:HttpGet(("https://raw.githubusercontent.com/ArtisticCloud/Artistc-Boosting-Hub/master/Modules/Utility.lua"),true))()
local Info = loadstring(game:HttpGet(("https://raw.githubusercontent.com/ArtisticCloud/Artistc-Boosting-Hub/master/Modules/Info.lua"),true))()

local Player = game.Players.LocalPlayer 
local Storage = game:GetService( 'ReplicatedStorage' )

local Remotes = Storage:WaitForChild( 'Remotes' , 20 )

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

    self:LoadUI()
    self:Events()

    return self
end

function Rec:LoadUI()
    self.LobbyGroupBox = self.RecTab:AddLeftGroupbox( 'Rec. Lobby' )
    self.UIElements.RecBoosting = self.LobbyGroupBox:AddToggle( 'Rec_Boosting' , {
        Text = 'Rec Boosting' , 
        Tooltip = 'doesnt do anything yet'
    })
    self.UIElements['Other_Main'] = self.LobbyGroupBox:AddDropdown( 'Other Main' ,  {
        Values = {} , 
        Text = 'Other Main' , 
    })
    self.UIElements.MainPartyCode = self.LobbyGroupBox:AddLabel( 'Main Party: None' )
    self.UIElements.AltPartyCode = self.LobbyGroupBox:AddLabel( 'Alt Party: None' )
    self.UIElements.CreateParty = self.LobbyGroupBox:AddButton( 'Create Parties' , function()
        local OtherMain = self.UIElements.Other_Main.Value and Utility.isValidAlt( self.UIElements.Other_Main.Value )
        if OtherMain then
            print( 'create code here' )
        elseif not OtherMain then
            self.Linoria:Notify( 'Invalid Main' , 8 )
        end
    end)
    self.UIElements.CreateParty = self.LobbyGroupBox:AddButton( 'Invite Alts' , function()
        local Accounts = Utility.getData( Info.ACFileName )
        if Accounts then 
            for AccountName , AccountData in pairs(Accounts.Accounts) do
                if not game.Players:FindFirstChild( AccountName ) then
                    self.Linoria:Notify( AccountName .. ' is not in your server' , 9 )
                end
            end
            return true 
        end 
    end)
end

function Rec:Events()
    self.UIElements.Other_Main:OnChanged(function()
        local AccountData = Utility.isValidAlt( self.UIElements.Other_Main.Value )
        if AccountData then
            -- self:SetPartyCodes()
        end
    end)
end

function Rec:SetPartyCodes( User1 , Code1  )
    local GeneralData = Utility.getData( Info.GDFileName )
    if GeneralData then
        GeneralData.Parties[User1] = Code1 
        Utility.saveData( GeneralData )
    end
end     

function Rec:createParty()
    return Remotes.Parties:InvokeServer( 'Start' )
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

function Rec:Update()
    local RecData = Utility.getData( Info.GDFileName )
    if RecData then
        
    end
    local AccountControlData = Utility.getData( Info.ACFileName )
    if AccountControlData then
        self.UIElements.Other_Main:SetValue( AccountControlData )
    end
end

return Rec