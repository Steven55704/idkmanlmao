print("Successfully Loaded")

hookfunction(error, warn)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local PlayerScripts = LocalPlayer.PlayerScripts
local ClientGameScript = PlayerScripts:WaitForChild("ClientGameScript")
local MobileService = require(ClientGameScript:WaitForChild("MobileService"))

getgenv().Settings = {
    AutoType = true,
    AutoJoin = true,
    TypeTime = 0
}

local Response = game:HttpGet("https://raw.githubusercontent.com/Steven55704/idkmanlmao/main/Word%20Karen/words.txt")
local Words = {}

for line in string.gmatch(Response,"[^\r\n]*") do
    if line ~= "" then
        table.insert(Words, line)
    end
end
    
local KeyCodes = {
    A = 0x41,
    B = 0x42,
    C = 0x43,
    D = 0x44,
    E = 0x45,
    F = 0x46,
    G = 0x47,
    H = 0x48,
    I = 0x49,
    J = 0x4A,
    K = 0x4B,
    L = 0x4C,
    M = 0x4D,
    N = 0x4E,
    O = 0x4F,
    P = 0x50,
    Q = 0x51,
    R = 0x52,
    S = 0x53,
    T = 0x54,
    U = 0x55,
    V = 0x56,
    W = 0x57,
    X = 0x58,
    Y = 0x59,
    Z = 0x5B
}

local ui_options = {
	main_color = Color3.fromRGB(41, 74, 122),
	min_size = Vector2.new(400, 300),
	toggle_key = Enum.KeyCode.RightShift,
	can_resize = true,
}

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Steven55704/idkmanlmao/main/Word%20Karen/karengui.lua"))()

local Used = {}
local Random = Random.new()

local Typing = false

function CanType()
    local GameSpace = PlayerGui.GameUI.Container.GameSpace
    if GameSpace:FindFirstChild("DefaultUI") and GameSpace.DefaultUI:FindFirstChild("GameContainer") and GameSpace.DefaultUI.GameContainer:FindFirstChild("DesktopContainer") then
        return GameSpace.DefaultUI.GameContainer.DesktopContainer.Typebar.Typebox.Visible
    end
    return false
end

function GetJoinButton()
    local GameSpace = PlayerGui.GameUI.Container.GameSpace
    if GameSpace:FindFirstChild("DefaultUI") and GameSpace.DefaultUI:FindFirstChild("DesktopFrame") then
        return GameSpace.DefaultUI.DesktopFrame:FindFirstChild("JoinButton")
    end
end

function GetCurrentPattern()
    local GameSpace = PlayerGui.GameUI.Container.GameSpace
    if GameSpace:FindFirstChild("DefaultUI") and GameSpace.DefaultUI:FindFirstChild("GameContainer") and GameSpace.DefaultUI.GameContainer:FindFirstChild("DesktopContainer") then
        local Pattern = ""
        for _, LetterFrame in next, GameSpace.DefaultUI.GameContainer.DesktopContainer.InfoFrameContainer.InfoFrame.TextFrame:GetChildren() do
            if LetterFrame:IsA("Frame") and LetterFrame.Visible == true and LetterFrame.Letter.ImageColor3 ~= Color3.new(255, 255, 255) then
                Pattern ..= LetterFrame.Letter.TextLabel.Text
            end
        end
        return Pattern
    end
end
    
function FindWord(Pattern)
    for _, Word in next, Words do
        if string.find(Word, Pattern) and not table.find(Used, Word) then
            table.insert(Used, Word)
            return Word
        end
    end
    --[[local theword = total[math.random(1, #Used)]
    table.insert(Used, theword)
    return theword]]--
end
    
--[[function Type(Word)
    local Typebox = PlayerGui.GameUI.Container.GameSpace.DefaultUI.GameContainer.DesktopContainer.Typebar.Typebox
    local WaitTime = Settings.TypeTime / string.len(Word)
    for _, Letter in next, string.split(Word, "") do
        Typebox.Text ..= Letter
        wait(WaitTime)
    end
    firesignal(Typebox.FocusLost, true)
end]]-- --new type function but patched

function Type(Word)
    local Typebox = PlayerGui.GameUI.Container.GameSpace.DefaultUI.GameContainer.DesktopContainer.Typebar.Typebox
    local  WaitTime = (Settings.TypeTime / 3) / 10
    --[local WaitTime = Settings.TypeTime / string.len(Word)]-- --wordbomb.today Type Time
    if math.random(1, 5) == 1 then
        for _, Letter in next, string.split(Word, "") do
            if math.random(1, 5) == 1 then
                Typebox.Text ..= string.char(math.random(string.byte('A'), string.byte('Z')))
                wait(WaitTime / 2.5)
                Typebox.Text ..= string.char(math.random(string.byte('A'), string.byte('Z')))
                wait(WaitTime * 2.5)
                Typebox.Text = Typebox.Text:sub(0, -2)
                wait(WaitTime / 1.8)
                Typebox.Text = Typebox.Text:sub(0, -2)
                wait(WaitTime / 1.8)
                Typebox.Text ..= Letter
                wait(WaitTime)
            else
                Typebox.Text ..= Letter
                wait(WaitTime)
            end
        end
        firesignal(Typebox.FocusLost, true)
    else
        for _, Letter in next, string.split(Word, "") do
            Typebox.Text ..= Letter
            wait(WaitTime)
        end
        firesignal(Typebox.FocusLost, true)
    end
end
    
function TypeWord(Pattern)
    local Word = FindWord(string.lower(Pattern))
    if Word then
        Type(Word)
    end
    wait(0.25)
    Typing = false
end

do
    local Window = library:AddWindow("Karen", {
        main_color = Color3.fromRGB(41, 74, 122),
        min_size = Vector2.new(500, 150),
        toggle_key = Enum.KeyCode.RightShift,
        can_resize = true
    })

    local Tab = Window:AddTab("Found Black!")
    
    local AutoJoinSwitch = Tab:AddSwitch("Auto Fight", function(Value)
        Settings.AutoJoin = Value
    end)
    AutoJoinSwitch:Set(Settings.AutoJoin)
    
    local AutoTypeSwitch = Tab:AddSwitch("Auto Racist", function(Value)
        Settings.AutoType = Value
    end)
    AutoTypeSwitch:Set(Settings.AutoType)

    local TypeTimeSlider = Tab:AddSlider("Time Rap", function(Value)
        Settings.TypeTime = Value
    end, {
        ["min"] = 0,
        ["max"] = 5,
        ["readonly"] = false
    })
    TypeTimeSlider:Set(Settings.TypeTime)

    Tab:Show()
    library:FormatWindows()
end

while wait() do
    if CanType() then
        if not Typing then
            Typing = true
            TypeWord(GetCurrentPattern())
        end
    end
    local JoinButton = GetJoinButton()
    if JoinButton then
        Used = {}
        firesignal(JoinButton.MouseButton1Down)
    end
    if Settings.AutoType and CanType() then
        if not Typing then
            Typing = true
            TypeWord(GetCurrentPattern())
        end
    end
    if Settings.AutoJoin then
        local JoinButton = GetJoinButton()
        
    end
end
