local Utility = {}
local Info = loadstring(game:HttpGet(("https://raw.githubusercontent.com/ArtisticCloud/Artistc-Boosting-Hub/master/Modules/Info.lua"),true))()
local Http = game:GetService( 'HttpService' )

--// Services // --
local Storage = game:GetService( 'ReplicatedStorage' ) 
local JDIO = 2

function Utility.findGlobalPlayer( Username )
    local UserId 
    local s,e = pcall(function()
        UserId = game.Players:GetUserIdFromNameAsync( Username )
    end)
    if UserId then
        local Exists 
        local s,e = pcall(function()
            Exists = game.Players:GetNameFromUserIdAsync( UserId )
        end)
        return Exists , UserId
    end 
end 

function Utility.findLocalPlayer( Username )
    for _,Player in game:GetService( 'Players' ):GetPlayers() do
        if Player.Name:lower():find( Username:lower() ) then
            return Player
        end 
        continue
    end 
end 

function Utility.saveData( FileName , Data )
    makefolder( Info.FolderName )
    writefile( Info.FolderName .. '/' .. FileName .. '.txt' , Http:JSONEncode( Data ) )
end 

function Utility.getData( FileName )
    local FilePath = Info.FolderName .. '/' .. FileName .. '.txt'
    if isfile( FilePath ) then
        local Data 
        local Success,Error = pcall(function()
            Data = Http:JSONDecode(readfile( FilePath ))
        end)
        return Data , Error
    end 
end 

function Utility.hasBall( Player )
    return Player.Parent and Player.Character and Player.Character:FindFirstChild( 'ball.weld' )
end  

function Utility.isValidAlt( Username )
    local AccountControlData = Utility.getData( Info.ACFileName )
    if AccountControlData and AccountControlData.Accounts[Username] then
        return AccountControlData.Accounts[Username] , AccountControlData
    end
end

function Utility.followPlayer( Player , UserId , UseData )
    local CurrentPlace = Utility.findIndexFromValue( Info.Places , game.PlaceId )
    if CurrentPlace then
        if CurrentPlace == 'Main Menu' then
            Storage.Remotes.Teleport:InvokeServer( 'Plaza' , {Slot=UseData.Slot} )
        else
            Storage.SocialFunctions.Follow:InvokeServer( UserId )
        end 
        return 
    end
    return 'Invalid Place'
end 

function Utility.teleportTo( Place , Slot )
    local Player = game:GetService( 'Players' ).LocalPlayer 
    local CurrentPlace = Utility.findIndexFromValue( Info.Places , game.PlaceId )
    if CurrentPlace and CurrentPlace:lower() ~= Place:lower() then
        if CurrentPlace == 'Main Menu' then 
            
        end
        return true
    end
    return 'Invalid Place'
end

function Utility.findOpenIndex( Table )
    for index,item in pairs(Table) do
        if item == ''  then
            return index,item
        end
        continue
    end
end 

function Utility.tableLen( Table )
    local n = 0
    for _,item in pairs(Table) do
        n = n + 1
    end
    return n
end

function Utility.findIndexFromValue( Table , Value )
    for index,value in pairs( Table ) do
        if value == Value then
            return index 
        end
    end 
end 

function Utility.sendMessageThroughBot( content , message )
    local Http = game:GetService( 'HttpService' )
    local Data = {
        username = Info.BotUsername , 
        content = content , 
        embeds = {{
            author = {name=''} , 
            title = '' , 
            description = message , 
            ['type'] = 'rich' , 
            color = 16737300 ,
        }} , 
    }
    local request = http_request or request or HttpPost or syn.request
    print( 'WEBHOOK' , Info.Webhook)
    request({
        Url = Info.Webhook,
        Body = Http:JSONEncode(Data),
        Method = "POST",
        Headers = {
            ["content-type"] = "application/json"
        }
    })
end

function Utility.Teleport( Place , Slot )
    local CurrentPlace = Utility.findIndexFromValue( game.PlaceId )

    local function tp( Place )
        Remotes.Teleport:InvokeServer( Place )
    end

    if Place == 'RecLobby' or Place == 'Park' or Place == 'Gym' then
        if CurrentPlace == 'MainMenu' then
            
        else
            Remotes.Teleport:InvokeServer( '' )
        end
    elseif Place == 'Plaza' then

    end
end

repeat task.wait() until game:IsLoaded()
local Mains = {
    'ImTooTistic' , 
    'zoryzoro' , 
}

local Remotes = game:GetService( 'ReplicatedStorage' ):WaitForChild( 'Remotes' )
local AccountType = game.Players.LocalPlayer.Name:lower() == Mains[1] and 'Main' or 'Alt'

function findParty( user )
    for _,Party in pairs( game:GetService('ReplicatedStorage'):WaitForChild('Parties'):GetChildren() ) do
        if Party:GetAttribute( 'Owner' ) and Party:GetAttribute( 'Leader' ):lower() == user:lower() then
            return Party
        end
    end
end

function ready()
    local Parties = game:GetService( 'ReplicatedStorage' ).Parties
    local PartiesReady = 0
    for _,Party in pairs(Parties:GetChildren()) do
        --// check if leader is the player //--
        if table.find( Mains , Party:GetAttribute( 'Leader' ):lower() ) and Party.Players and #Party.Players:GetChildren() >= 5 then
            PartiesReady += 1
        end
    end
    if PartiesReady == #Mains then
        return true 
    end
end

function sendToDiscord( Title , Message )
    local Http = game:GetService( 'HttpService' )
    local Data = {
        username = 'Rec Boosting Bot' , 
        content = Title , 
        embeds = {{
            author = {name=''} , 
            title = '' , 
            description = Message , 
            ['type'] = 'rich' , 
            color = 16737300 ,
        }} , 
    }
    local request = http_request or request or HttpPost or syn.request
    local Response = request({
        Url = 'https://discord.com/api/webhooks/1085658620647186542/CWysv9NFw17V4g9WhvQgMVywBRmTjdhRmzgJPPzO9HP4e9QNFVBr5eAhweDB7f9NI0rN' ,
        Body = Http:JSONEncode(Data),
        Method = "POST",
        Headers = {
            ["content-type"] = "application/json"
        }
    })
end

function partyCodes()
    task.wait(1)
    Remotes:WaitForChild( 'Parties' )
    Remotes.Parties:InvokeServer( 'Leave' )
    local Response , ResponseData = Remotes.Parties:InvokeServer( 'Start' )
    if Response then
        if AccountType == 'Alt' then
            setclipboard( tostring(ResponseData.Code) )
        end
        sendToDiscord(  '@everyone Party Code'  , AccountType .. ' Party: ' .. tostring(ResponseData.Code) )
    end
end

if table.find( Mains , game.Players.LocalPlayer.Name:lower() ) and game.PlaceId == 10207014047 then
    task.spawn(function()
        partyCodes()
    end)
    while true do task.wait()
        local rdy = ready()
        if ready() then
            game:GetService( 'ReplicatedStorage' ).Remotes.Teleport:InvokeServer( 'Ranked Queue' )
            break
        end
        continue
    end
end

repeat task.wait() until game:IsLoaded()
local Storage = game:GetService( 'ReplicatedStorage' )
local Remotes = Storage:WaitForChild( 'Remotes' )
local Http = game:GetService( 'HttpService' )

task.wait(3)

local Player = game.Players.LocalPlayer 

local foldername = 'Log Clearer'
local filepath = foldername .. '/' .. 'data.txt'

function save( data )
    makefolder( foldername )
    writefile( filepath , Http:JSONEncode( Data ) )
end

function load()
    if isfile( filepath ) then
        local data 
        local s,e  = pcall(function()
            data = readfile( data )
        end)
        return data and Http:JSONDecode( Data )
    end
end

local Snitches = { --// Automatically kick out the game if one of these joins
    'gunchowda' , 
    'isitjokes' , 
    'ljokes' ,
    'xv_nike' , 
    'errorchekz' ,
    'superfluousbacon' , 
    'zornage' , 
    'luadimer' , 
    'cooiius' , 
    'ashleydaballer' , 
    'zevroo' , 
    'kiricali' ,
    'rrhen101' , 
    'woodall25' ,
    'apathedic' ,
    'applecow14' , 
}

local startingdata = load()
if not startingdata then
    save({
        Loops = 0 , 
    })
end

local VirtualUser = game:GetService( 'VirtualUser' )
Player.Idled:Connect(function()
    VirtualUser:CaptureController() 
    VirtualUser:ClickButton2(Vector2.new()) 
end)

if game.PlaceId == 10207014047 then
    local data = load()
    if data then
        
    end
    while task.wait(0.5) do
        Remotes.Teleport:InvokeServer( 'Ranked Queue' )
    end
elseif game.PlaceId == 10240522770 then
    task.spawn(function()
        task.wait(5)
        --// check if theres a snitch in the server //--
        local SnitchesInServer = {} do
            for _,CurrentPlayer in pairs( game.Players:GetPlayers() ) do
                if table.find( Snitches , CurrentPlayer.Name:lower() ) then
                    table.insert( SnitchesInServer , CurrentPlayer )
                end
                continue
            end
        end
        if #SnitchesInServer > 0 then
            Player:Kick( 'Some snitches joined lol, snitches: ' .. tostring(unpack(SnitchesInServer)) )
        end
    end)
    local BackToMenu = Player:WaitForChild( 'PlayerGui' ):WaitForChild( 'MainUI' ):WaitForChild( 'BackToLobby' )
    repeat task.wait(0.1) until BackToMenu.Visible
    while task.wait(0.5) do
        Remotes.Teleport:InvokeServer( 'Rec' )
    end
end

repeat task.wait() until game:IsLoaded()

local Player = game.Players.LocalPlayer

local WhoToJoin = ''

local Storage = game:GetService( 'ReplicatedStorage' )
local Remotes = Storage:WaitForChild( 'Remotes' )
local Http = game:GetService( 'HttpService' )

local Main = 'ImTooTistic'
local Alt = 'zoryzoro'

local Gui = Instance.new( 'ScreenGui' , game.CoreGui )

local Alts = {
    ['76ffe22'] = 'Main' ,
    ['8Ozh'] = 'Alt' , 
    ['YouxsHoeAhNhggh'] = 'Main' ,
    ['BhjtchAzsHoes'] = 'Alt' ,
    ['UncleFetch'] = 'Alt' ,
    ['callusyum'] = 'Main' ,
    ['Rehoyrd'] = 'Main' ,
    ['1okkrvo'] = 'Alt' ,
}

local foldername = 'Auto Party Starter'
local filepath = foldername .. '/' .. 'data.txt'

function save( Data ) 
    makefolder( foldername )
    writefile( filepath , Http:JSONEncode( Data ) )
end

function load()
    if isfile(filepath) then
        return Http:JSONDecode( readfile( filepath ) )
    end
end

function createGui( Type )
    local Textbox = Instance.new( 'TextBox' , Gui )
    Textbox.Position = UDim2.fromScale( 0.892 , 0.802 + (0.035 * #Gui:GetChildren()) )
    Textbox.Size = UDim2.fromScale( 0.1 , 0.029 )
    Textbox.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Textbox.Font = Enum.Font.GothamBold 
    Textbox.TextXAlignment = Enum.TextXAlignment.Right
    Textbox.TextScaled = true 
    Textbox.TextColor3 = Color3.fromRGB( 255 , 255 , 255 )
    Textbox.PlaceholderText = Type .. ' Code'
    Textbox.ClearTextOnFocus = false

    local Stroke = Instance.new( 'UIStroke' , Textbox )
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Color = Color3.fromRGB( 255 , 255 , 255 )

    --// Events //--
    Textbox.FocusLost:Connect(function(enterPressed)
        if enterPressed and Textbox.Text ~= '' then
            --// validate the code //--
            local InputCode = TextBox.Text:split("")
            if #InputCode == 6 and tonumber(InputCode[2]) and tonumber(InputCode[4]) and tonumber(InputCode[6]) then
                local Data = load()
                if not Data then return end
                Data.Parties[Type] = Textbox.Text 
                save(Data)
            end
        end
        return true
    end)
    return true
end
 
function find_party( user )
    for _,party in pairs(Storage:WaitForChild( 'Parties' )) do
        if party:GetAttribute('Leader'):lower() == user:lower() then
            return party
        end
    end
    return true
end

function isInParty( user )
    for _,party in pairs(Storage:WaitForChild( 'Parties' )) do
        if party.Players:FindFirstChild( user ) then
            return party
        end
    end
    return true
end

function run()
    local NowData = load()
    createGui( 'Main Party' )
    createGui( 'Alt Party' )
    if not NowData then
        save({
            Parties = {} , 
        })
    end
    local Data 
    local AccountType == Alts[Player.Name]
    repeat task.wait(0.1) 
        pcall(function()
            Data = load()
        end)
    until AccountType == 'Main' and Data.Parties.Main or Data.Parties.Alt
    if isInParty(Player.Name) then
        return
    end
    Remotes.Parties:InvokeServer( 'Leave' )
    if Data.Parties.Main and AccountType == 'Main' then
        Remotes.Parties:InvokeServer( 'Join' , Data.Parties.Main )
    elseif Data.Parties.Alt and AccountType == 'Alt' then
        Remotes.Parties:InvokeServer( 'Join' , Data.Parties.Alt )
    end
end

if Alts[Player.Name] and game.PlaceId == '' then
    run()
end

return Utility