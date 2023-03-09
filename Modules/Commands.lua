local Commands = {}

function Commands.new()
    local self = setmetatable({},{__index=Commands})    
    
    return self
end




return Commands