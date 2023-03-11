local AccountControl = {}
local Info = loadstring(game:HttpGet(("https://raw.githubusercontent.com/ArtisticCloud/Artistc-Boosting-Hub/master/Modules/Info.lua"),true))()
local Utility = loadstring(game:HttpGet(("https://raw.githubusercontent.com/ArtisticCloud/Artistc-Boosting-Hub/master/Modules/Utility.lua"),true))()

function AccountControl.new( Hub )
    local self = setmetatable({},{
        __index = function(t,index,value)
            if not AccountControl[index] then
                return Hub[index]
            end
            return AccountControl[index]
        end,
    })
    return self
end 

function AccountControl:registerAccount( Username , Userid )
    local AccountControlData = Utility.getData( Info.ACFileName )
    if AccountControlData and Utility.tableLen(AccountControlData.Accounts) < Info.MaxAlts then
        if AccountControlData.Accounts[Username] then
            self.Linoria:Notify( Username .. ' is already registered..wtf is you doin' , 8 )
        else
            AccountControlData.Accounts[Username] = Info.ACAccountData
            Utility.saveData( Info.ACFileName , AccountControlData )
            self.Linoria:Notify( Username .. ' has been successfully registered' , 8 )
            return 'Success'
        end
    elseif AccountControlData and Utility.tableLen(AccountControlData.Accounts) >= Info.MaxAlts then
        self.Linoria:Notify( 'Alt capacity reached, try deleting an alt' , 9 )
        return
    elseif not AccountControlData then
        --// Create new data
        local NewACData = Info.ACFileTemplate
        NewACData.Accounts[Username] = Info.ACAccountData
        --// nice //--
        Utility.saveData( Info.ACFileName , NewACData )
        self.Linoria:Notify( Username .. ' has been successfully registered' , 8 )
        return 'Success'
    end
end 

function AccountControl:unregisterAccount( Username , UserId )
    local AccountControlData = Utility.getData( Info.ACFileName )
    if AccountControlData then
        if AccountControlData.Accounts[Username] then
            AccountControlData.Accounts[Username] = nil
            Utility.saveData( Info.ACFileName , AccountControlData )
            self.Linoria:Notify( 'Successfully removed ' .. Username )
            return 'Success'
        else
            self.Linoria:Notify( Username .. ' is not registered..wyd' , 12 )
        end
    else
        self.Linoria:Notify( 'There is no Account Control data..' , 10 )
    end
end     

function AccountControl:changeCommand( Username , NewCommand )
    local Data = Utility.getData( Info.ACFileName )
    if Data and Data.Accounts[Username] then
        
    end
end

function AccountControl:registerRequest( PlayerName , PlayerUserId )
     --// Subtract 1 so it doesnt include the "all" section //--
     if #self.RegisteredAlts - 1 >= Info.MaxAlts then
        self.Linoria:Notify( 'Alt capacity reached. \n Try deleting an alt' , 10 )
    end
    if PlayerName == self.Main then
        self.Linoria:Notify( 'Main account cannot be set as alt' , 10 )
        return
    end
    local Feedback = self:registerAccount( PlayerName , PlayerUserId )
    if Feedback == 'Success' then
        local ChosenLabel 
        for i=1,Info.MaxAlts do
            if self.UIElements[ 'Alt Label ' .. i ].Value == 'None' then
                ChosenLabel = self.UIElements[ 'Alt Label  .. i']
            end
        end
        if ChosenLabel then
            ChosenLabel:SetText( PlayerName )
        end
    end 
end

return AccountControl