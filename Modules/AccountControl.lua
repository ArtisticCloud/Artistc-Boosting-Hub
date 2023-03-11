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
    self.Linoria:Notify( ('Registering ' .. Username .. '..') , 8 )
    local AccountControlData = Utility.getData( Info.ACFileName )
    if AccountControlData then
        if AccountControlData[Username] then
            self.Linoria:Notify( Username .. ' is already registered..wtf is you doin' )
        else
            AccountControlData[Username] = Utility.ACAccountData
        end
    else
        --// Create new data
        local NewACData = Info.ACFileTemplate
        NewACData.Accounts[Username] = Utility.ACAccountData
        --// nice //--
        Utility.saveData( Utility.ACFileName , NewACData )
        self.Linoria:Notify( Username .. ' has been successfully registered' )
    end
end 

function AccountControl:unregisterAccount( Username , UserId )
    local Data = Utility.getData( Info.ACFileName ) or {}
end     

return AccountControl