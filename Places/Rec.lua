local Rec = {}

print( 'was called here too' )
local Utility = loadstring(game:HttpGet(("https://raw.githubusercontent.com/ArtisticCloud/Artistc-Boosting-Hub/master/Modules/Utility.lua"),true))()
local Info = loadstring(game:HttpGet(("https://raw.githubusercontent.com/ArtisticCloud/Artistc-Boosting-Hub/master/Modules/Info.lua"),true))()

local Player = game.Players.LocalPlayer 
local Storage = game:GetService( 'ReplicatedStorage' )

local Remotes = Storage:WaitForChild( 'Remotes' , 20 )

function Rec.new( Hub , Window )
    print( 'was called' )
    local self = setmetatable({},{
        __index = function( Table , Index , Value )
            if not Rec[Index] then
                return Hub[Index]
            end
            return Rec[Index]
        end,
    })

    self.RecTab = Window:AddTab( 'Rec.' )
    self.UIElements = {}

    -- self.LobbyGroupBox = nil

    -- print( 'working' )
    -- self:LoadUI()
    -- self:Events()

    return self
end

function Rec:LoadUI()
    self.LobbyGroupBox = self.RecTab:AddLeftGroupbox( 'Rec. Lobby' )
    print( 'passed' )
    self.UIElements.RecBoosting = self.LobbyGroupBox:AddToggle( 'Rec Boosting' , function()
        Text = 'Rec Boosting'
        Tooltip = 'will auto inject when in rec lobby to safely join the same match'
    end)
    self.UIElements['Other_Main'] = self.LobbyGroupBox:AddDropdown( 'Other Main' ,  {
        Values = {} , 
        Text = 'Other Main' , 
    })
    print( 'passed 2' )
    self.UIElements.MainPartyCode = self.LobbyGroupBox:AddLabel( 'Main Party: None' )
    self.UIElements.AltPartyCode = self.LobbyGroupBox:AddLabel( 'Alt Party: None' )
    self.UIElements.CreateParty = self.LobbyGroupBox:AddButton( 'Create Parties' , function()
        print('passed')
        local OtherMain = self.UIElements.Other_Main.Value and Utility.isValidAlt( self.UIElements.Other_Main.Value ) then
        if OtherMain then
            print( 'create code here' )
        elseif not OtherMain then
            self.Linoria:Notify( 'Invalid Main' , 8 )
        end
    end)
end

function Rec:Events()
    
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
        self.UIElements.Other_Main:SetValue( AccountControlData.Accounts )
    end
end

return Rec