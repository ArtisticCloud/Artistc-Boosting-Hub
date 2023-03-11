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
        if AccountControlData.Accounts[Username] then
            self.Linoria:Notify( Username .. ' is already registered..wtf is you doin' , 8 )
        else
            AccountControlData.Accounts[Username] = Utility.ACAccountData
            self.Linoria:Notify( Username .. ' has been successfully registered' , 8 )
            return 'Success'
        end
    else
        --// Create new data
        local NewACData = Info.ACFileTemplate
        NewACData.Accounts[Username] = Utility.ACAccountData
        --// nice //--
        Utility.saveData( Info.ACFileName , NewACData )
        self.Linoria:Notify( Username .. ' has been successfully registered' , 8 )
        return 'Success'
    end
end 

function AccountControl:unregisterAccount( Username , UserId )
    self.Linoria:Notify( ('Removing ' .. Username .. '..') , 8 )
    local AccountControlData = Utility.getData( Info.ACFileName )
    if AccountControlData then
        if AccountControlData.Accounts[Username] then
            AccountControlData.Accounts[Username] = nil
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

return AccountControl