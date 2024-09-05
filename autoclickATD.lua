-- Đã chạy
if getgenv()["Already Running"] then return else getgenv()["Already Running"] = true end

-- Dịch vụ
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Biến
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local flags = {Auto_Clicking = false, Mouse_Locked = false}
local TaskWait = task.wait

-- Lấy Keybind
local getKeycode = function(bind)
    return (pcall(function() return Enum.KeyCode[bind] end) and Enum.KeyCode[bind] or bind)
end

-- Vẽ
local Draw = function(obj, props)
    local NewObj = Drawing.new(obj)

    for i, v in next, props do
        NewObj[i] = v
    end

    return NewObj
end

-- Tạo GUI
local Text = Draw("Text", {
    Size = 18,
    Outline = true,
    OutlineColor = Color3.fromRGB(255, 255, 255),
    Color = Color3.fromRGB(0, 0, 0),
    Text = "Auto Clicking : TRUE\nMouse Locked : TRUE",
    Visible = true,
})

-- Vị trí khóa chuột
local mouseLockPositions = {
    Vector2.new(429.973969, 303.925781),
    Vector2.new(223.802078, 276.723633)
}

local currentMouseLockIndex = 1

-- Hàm để chuyển đổi vị trí khóa chuột
local function switchMouseLockPosition()
    currentMouseLockIndex = (currentMouseLockIndex % #mouseLockPositions) + 1
    flags.Mouse_Locked_Position = mouseLockPositions[currentMouseLockIndex]
end

-- Key Bind
UIS.InputBegan:Connect(function(inputObj, GPE)
    if (not GPE) then
        if (inputObj.KeyCode == getKeycode(Settings["Auto Click Keybind"])) then
            flags.Auto_Clicking = not flags.Auto_Clicking
        end
        
        if (inputObj.KeyCode == getKeycode(Settings["Lock Mouse Position Keybind"])) then
            switchMouseLockPosition()
            flags.Mouse_Locked = not flags.Mouse_Locked
        end

        Text.Text = ("Auto Clicking : %s\nMouse Locked : %s"):format(tostring(flags.Auto_Clicking):upper(), tostring(flags.Mouse_Locked):upper())
    end
end)

-- Auto Click
while (true) do
    Text.Visible = Settings.GUI
    Text.Position = Vector2.new(Camera.ViewportSize.X - 133, Camera.ViewportSize.Y - 48)

    if (flags.Auto_Clicking) then
        for i = 1, 2 do
            if (flags.Mouse_Locked) then
                VIM:SendMouseButtonEvent(flags.Mouse_Locked_Position.X, flags.Mouse_Locked_Position.Y, Settings["Right Click"] and 1 or 0, i == 1, nil, 0)
            else
                local Mouse = UIS:GetMouseLocation()
                VIM:SendMouseButtonEvent(Mouse.X, Mouse.Y, Settings["Right Click"] and 1 or 0, i == 1, nil, 0)
            end
        end
    end

    if (Settings.Delay <= 0) then
        RunService.RenderStepped:Wait()
    else
        TaskWait(Settings.Delay)
    end
end
