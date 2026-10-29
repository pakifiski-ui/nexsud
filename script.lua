local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Gui = gethui and gethui() or game:GetService("CoreGui")

local Settings = {
    Aimbot = false,
    TargetPart = "Head",
    FOV = 200,
    MaxDist = 1500,
    ESPSkeleton = true,
    ESPHealth = true,
    ESPDist = true,
    ESPName = false
}

if Gui:FindFirstChild("NexusHardcoreHub") then Gui.NexusHardcoreHub:Destroy() end

local SG = Instance.new("ScreenGui", Gui)
SG.Name = "NexusHardcoreHub"
SG.ResetOnSpawn = false
SG.IgnoreGuiInset = true

-- Главное меню (Перетаскиваемое)
local MF = Instance.new("Frame", SG)
MF.Size = UDim2.fromOffset(230, 390)
MF.Position = UDim2.new(0.05, 0, 0.15, 0)
MF.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MF.BackgroundTransparency = 0.1
MF.BorderSizePixel = 0
Instance.new("UICorner", MF).CornerRadius = UDim.new(0, 10)
local MS = Instance.new("UIStroke", MF)
MS.Thickness = 1.5
MS.Color = Color3.fromRGB(255, 50, 50)

local Head = Instance.new("TextButton", MF)
Head.Size = UDim2.new(1, 0, 0, 32)
Head.BackgroundColor3 = Color3.fromRGB(30, 15, 15)
Head.BackgroundTransparency = 0.2
Head.Text = "  ⚡ NEXUS | Smart ESP Hub"
Head.TextXAlignment = Enum.TextXAlignment.Left
Head.TextColor3 = Color3.fromRGB(255, 80, 80)
Head.Font = Enum.Font.GothamBold
Head.TextSize = 12
Instance.new("UICorner", Head).CornerRadius = UDim.new(0, 10)

-- Кнопка закрытия меню (✕)
local CloseBtn = Instance.new("TextButton", Head)
CloseBtn.Size = UDim2.fromOffset(24, 24)
CloseBtn.Position = UDim2.new(1, -28, 0, 4)
CloseBtn.BackgroundColor3 = Color3.fromRGB(50, 20, 20)
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 11
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- Кнопка открытия меню (Open ⚡)
local OpenBtn = Instance.new("TextButton", SG)
OpenBtn.Size = UDim2.fromOffset(75, 32)
OpenBtn.Position = UDim2.new(0.85, 0, 0.05, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
OpenBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
OpenBtn.Text = "OPEN ⚡"
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 11
OpenBtn.Visible = false
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 8)
local OpenStroke = Instance.new("UIStroke", OpenBtn)
OpenStroke.Thickness = 1.5
OpenStroke.Color = Color3.fromRGB(255, 50, 50)

-- Механика перетаскивания окон/кнопок
local function MakeDraggable(uiObj)
    local dragging, dragStart, startPos
    uiObj.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = i.Position
            startPos = uiObj.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = i.Position - dragStart
            uiObj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end
MakeDraggable(MF)
MakeDraggable(OpenBtn)

CloseBtn.Activated:Connect(function()
    MF.Visible = false
    OpenBtn.Position = UDim2.new(0, MF.AbsolutePosition.X, 0, MF.AbsolutePosition.Y)
    OpenBtn.Visible = true
end)

OpenBtn.Activated:Connect(function()
    MF.Visible = true
    OpenBtn.Visible = false
end)

-- Плавающая кнопка АИМа
local AimBtn = Instance.new("TextButton", SG)
AimBtn.Size = UDim2.fromOffset(90, 45)
AimBtn.Position = UDim2.new(0.8, 0, 0.5, 0)
AimBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
AimBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
AimBtn.Font = Enum.Font.GothamBold
AimBtn.TextSize = 11
AimBtn.Text = "AIM: OFF"
Instance.new("UICorner", AimBtn).CornerRadius = UDim.new(0, 10)
local AS = Instance.new("UIStroke", AimBtn)
AS.Thickness = 1.5
AS.Color = Color3.fromRGB(150, 40, 40)
MakeDraggable(AimBtn)

AimBtn.Activated:Connect(function()
    Settings.Aimbot = not Settings.Aimbot
    if Settings.Aimbot then
        AimBtn.Text = "AIM: ON"
        AimBtn.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
        AS.Color = Color3.fromRGB(255, 80, 80)
        AimBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        AimBtn.Text = "AIM: OFF"
        AimBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
        AS.Color = Color3.fromRGB(150, 40, 40)
        AimBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

local function MakeToggle(name, y, key)
    local btn = Instance.new("TextButton", MF)
    btn.Size = UDim2.new(1, -20, 0, 24)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Settings[key] and Color3.fromRGB(140, 20, 20) or Color3.fromRGB(25, 25, 35)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.Text = "  " .. name .. ": " .. (Settings[key] and "ON" or "OFF")
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local st = Instance.new("UIStroke", btn)
    st.Thickness = 1
    st.Color = Settings[key] and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(45, 45, 60)
    
    btn.Activated:Connect(function()
        Settings[key] = not Settings[key]
        btn.Text = "  " .. name .. ": " .. (Settings[key] and "ON" or "OFF")
        btn.BackgroundColor3 = Settings[key] and Color3.fromRGB(140, 20, 20) or Color3.fromRGB(25, 25, 35)
        st.Color = Settings[key] and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(45, 45, 60)
    end)
end

MakeToggle("Skeleton ESP", 38, "ESPSkeleton")
MakeToggle("Health Bar (Снизу-Вверх)", 66, "ESPHealth")
MakeToggle("Distance (Метры)", 94, "ESPDist")
MakeToggle("Names (Ники)", 122, "ESPName")

-- Переключение части тела
local PartBtn = Instance.new("TextButton", MF)
PartBtn.Size = UDim2.new(1, -20, 0, 24)
PartBtn.Position = UDim2.new(0, 10, 0, 150)
PartBtn.BackgroundColor3 = Color3.fromRGB(35, 20, 20)
PartBtn.TextColor3 = Color3.fromRGB(255, 120, 120)
PartBtn.Font = Enum.Font.GothamBold
PartBtn.TextSize = 10
PartBtn.Text = "  Target Part: HEAD"
PartBtn.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", PartBtn).CornerRadius = UDim.new(0, 6)

PartBtn.Activated:Connect(function()
    if Settings.TargetPart == "Head" then
        Settings.TargetPart = "Torso"
        PartBtn.Text = "  Target Part: TORSO"
    else
        Settings.TargetPart = "Head"
        PartBtn.Text = "  Target Part: HEAD"
    end
end)

-- Поле ввода дистанции
local DistLabel = Instance.new("TextLabel", MF)
DistLabel.Size = UDim2.new(1, -20, 0, 12)
DistLabel.Position = UDim2.new(0, 10, 0, 180)
DistLabel.BackgroundTransparency = 1
DistLabel.TextColor3 = Color3.fromRGB(200, 150, 150)
DistLabel.Font = Enum.Font.GothamMedium
DistLabel.TextSize = 9
DistLabel.TextXAlignment = Enum.TextXAlignment.Left
DistLabel.Text = "Max Distance (Метры):"

local DistBox = Instance.new("TextBox", MF)
DistBox.Size = UDim2.new(1, -20, 0, 24)
DistBox.Position = UDim2.new(0, 10, 0, 196)
DistBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
DistBox.TextColor3 = Color3.fromRGB(255, 255, 255)
DistBox.Font = Enum.Font.GothamBold
DistBox.TextSize = 11
DistBox.Text = tostring(Settings.MaxDist)
DistBox.ClearTextOnFocus = false
Instance.new("UICorner", DistBox).CornerRadius = UDim.new(0, 6)
local BoxStroke = Instance.new("UIStroke", DistBox)
BoxStroke.Thickness = 1
BoxStroke.Color = Color3.fromRGB(150, 40, 40)

DistBox.FocusLost:Connect(function()
    local num = tonumber(DistBox.Text)
    if num and num > 0 then
        Settings.MaxDist = num
        DistBox.Text = tostring(num)
    else
        DistBox.Text = tostring(Settings.MaxDist)
    end
end)

-- Слайдер FOV
local function MakeSlider(name, y, defVal, minVal, maxVal, suffix, callback)
    local lbl = Instance.new("TextLabel", MF)
    lbl.Size = UDim2.new(1, -20, 0, 12)
    lbl.Position = UDim2.new(0, 10, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(200, 150, 150)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 9
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = name .. ": " .. defVal .. suffix

    local cont = Instance.new("Frame", MF)
    cont.Size = UDim2.new(1, -20, 0, 5)
    cont.Position = UDim2.new(0, 10, 0, y + 13)
    cont.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Instance.new("UICorner", cont).CornerRadius = UDim.new(0, 3)

    local btn = Instance.new("TextButton", cont)
    btn.Size = UDim2.fromOffset(10, 10)
    local initPercent = (defVal - minVal) / (maxVal - minVal)
    btn.Position = UDim2.new(initPercent, -5, 0, -2.5)
    btn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    btn.Text = ""
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    local draggingSlider = false
    btn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = true end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = false end
    end)
    UIS.InputChanged:Connect(function(i)
        if draggingSlider and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then
            local p = math.clamp((i.Position.X - cont.AbsolutePosition.X) / cont.AbsoluteSize.X, 0, 1)
            btn.Position = UDim2.new(p, -5, 0, -2.5)
            local val = math.floor(minVal + (p * (maxVal - minVal)))
            lbl.Text = name .. ": " .. val .. suffix
            callback(val)
        end
    end)
end

MakeSlider("Aim FOV (Radius)", 230, Settings.FOV, 50, 400, "px", function(v) Settings.FOV = v end)

-- Проверка видимости (рейкаст)
local function IsVisible(targetPart)
    local myChar = LP.Character
    if not myChar or not myChar:FindFirstChild("Head") then return false end
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {myChar, targetPart.Parent}
    raycastParams.IgnoreWater = true

    local origin = Cam.CFrame.Position
    local direction = (targetPart.Position - origin)
    local result = workspace:Raycast(origin, direction, raycastParams)

    return result == nil
end

-- Скелет ESP логика
local function CreateLine()
    local line = Instance.new("Frame", SG)
    line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    line.BorderSizePixel = 0
    line.Visible = false
    return line
end

local ESPCache = {}

local function CreateESP(player)
    if player == LP or ESPCache[player] then return end

    local skeletonLines = {
        HeadToTorso = CreateLine(),
        LeftUpperArm = CreateLine(),
        RightUpperArm = CreateLine(),
        LeftUpperLeg = CreateLine(),
        RightUpperLeg = CreateLine(),
    }

    local hpBg = Instance.new("Frame", SG)
    hpBg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    hpBg.BorderSizePixel = 0
    hpBg.Visible = false

    local hpBar = Instance.new("Frame", hpBg)
    hpBar.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    hpBar.BorderSizePixel = 0
    hpBar.AnchorPoint = Vector2.new(0, 1)
    hpBar.Position = UDim2.new(0, 0, 1, 0)

    local distText = Instance.new("TextLabel", SG)
    distText.BackgroundTransparency = 1
    distText.Font = Enum.Font.GothamBold
    distText.TextSize = 10
    distText.TextColor3 = Color3.fromRGB(255, 255, 255)
    distText.TextStrokeTransparency = 0.3
    distText.Visible = false

    local nameText = Instance.new("TextLabel", SG)
    nameText.BackgroundTransparency = 1
    nameText.Font = Enum.Font.GothamBold
    nameText.TextSize = 10
    nameText.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameText.TextStrokeTransparency = 0.3
    nameText.Visible = false

    ESPCache[player] = {
        Lines = skeletonLines,
        HpBg = hpBg,
        HpBar = hpBar,
        Dist = distText,
        Name = nameText
    }
end

local function RemoveESP(player)
    if ESPCache[player] then
        for _, line in pairs(ESPCache[player].Lines) do line:Destroy() end
        ESPCache[player].HpBg:Destroy()
        ESPCache[player].Dist:Destroy()
        ESPCache[player].Name:Destroy()
        ESPCache[player] = nil
    end
end

for _, p in ipairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(CreateESP)
Players.PlayerRemoving:Connect(RemoveESP)

local function IsTeam(p)
    if p == LP then return true end
    if LP.Team and p.Team then return LP.Team == p.Team end
    return false
end

local function DrawLine(lineFrame, p1, p2, color)
    local v1, on1 = Cam:WorldToViewportPoint(p1)
    local v2, on2 = Cam:WorldToViewportPoint(p2)

    if on1 or on2 then
        local vector1 = Vector2.new(v1.X, v1.Y)
        local vector2 = Vector2.new(v2.X, v2.Y)
        local distance = (vector1 - vector2).Magnitude
        local center = (vector1 + vector2) / 2

        lineFrame.Size = UDim2.fromOffset(1.5, distance)
        lineFrame.Position = UDim2.fromOffset(center.X - 0.75, center.Y - distance / 2)
        lineFrame.Rotation = math.deg(math.atan2(vector2.Y - vector1.Y, vector2.X - vector1.X)) + 90
        lineFrame.BackgroundColor3 = color
        lineFrame.Visible = true
    else
        lineFrame.Visible = false
    end
end

local function GetTarget()
    local closest, shortestDist = nil, Settings.FOV
    local center = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y / 2)
    local myChar = LP.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and not IsTeam(p) then
            local char = p.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local part = char:FindFirstChild(Settings.TargetPart) or char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                if part and myHRP then
                    local dist3D = (myHRP.Position - part.Position).Magnitude
                    if dist3D <= Settings.MaxDist then
                        local pos, onScreen = Cam:WorldToViewportPoint(part.Position)
                        if onScreen then
                            local dist2D = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                            if dist2D <= shortestDist then
                                shortestDist = dist2D
                                closest = part
                            end
                        end
                    end
                end
            end
        end
    end
    return closest
end

RS.RenderStepped:Connect(function()
    local myChar = LP.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")

    if Settings.Aimbot then
        local targetPart = GetTarget()
        if targetPart then
            Cam.CFrame = CFrame.new(Cam.CFrame.Position, targetPart.Position)
            if myHRP then
                local lookPos = Vector3.new(targetPart.Position.X, myHRP.Position.Y, targetPart.Position.Z)
                myHRP.CFrame = CFrame.new(myHRP.Position, lookPos)
            end
            UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
        else
            UIS.MouseBehavior = Enum.MouseBehavior.Default
        end
    else
        UIS.MouseBehavior = Enum.MouseBehavior.Default
    end

    -- 1. Сначала находим абсолютного самого близкого игрока среди ВСЕХ (даже сзади)
    local closestPlayerByDist = nil
    local shortestDistVal = math.huge

    for player, _ in pairs(ESPCache) do
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        if char and hrp and hum and hum.Health > 0 and not IsTeam(player) and myHRP then
            local dist = (myHRP.Position - hrp.Position).Magnitude
            if dist <= Settings.MaxDist and dist < shortestDistVal then
                shortestDistVal = dist
                closestPlayerByDist = player
            end
        end
    end

    -- 2. Отрисовка ESP с умными цветами
    for player, esp in pairs(ESPCache) do
        local char = player.Character
        local hum = char and char:FindFirstChild("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")
        local torso = char and (char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
        local lArm = char and (char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftUpperArm"))
        local rArm = char and (char:FindFirstChild("Right Arm") or char:FindFirstChild("RightUpperArm"))
        local lLeg = char and (char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftUpperLeg"))
        local rLeg = char and (char:FindFirstChild("Right Leg") or char:FindFirstChild("RightUpperLeg"))

        if char and hum and hrp and head and torso and hum.Health > 0 and not IsTeam(player) then
            local distMeters = myHRP and math.floor((myHRP.Position - hrp.Position).Magnitude) or 0

            if distMeters <= Settings.MaxDist then
                -- Определение цвета по старой классике:
                -- Зеленый = самый близкий И виден
                -- Желтый = самый близкий, но за стеной
                -- Красный = не самый близкий, но виден
                -- Белый = не самый близкий и за стеной
                local visible = IsVisible(head)
                local isClosest = (player == closestPlayerByDist)
                local espColor = Color3.fromRGB(255, 255, 255) -- Белый по умолчанию

                if isClosest then
                    espColor = visible and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 0) -- Зеленый или Желтый
                else
                    espColor = visible and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 255) -- Красный или Белый
                end

                if Settings.ESPSkeleton and lArm and rArm and lLeg and rLeg then
                    DrawLine(esp.Lines.HeadToTorso, head.Position, torso.Position, espColor)
                    DrawLine(esp.Lines.LeftUpperArm, torso.Position, lArm.Position, espColor)
                    DrawLine(esp.Lines.RightUpperArm, torso.Position, rArm.Position, espColor)
                    DrawLine(esp.Lines.LeftUpperLeg, torso.Position, lLeg.Position, espColor)
                    DrawLine(esp.Lines.RightUpperLeg, torso.Position, rLeg.Position, espColor)
                    for _, line in pairs(esp.Lines) do line.Visible = true end
                else
                    for _, line in pairs(esp.Lines) do line.Visible = false end
                end

                local headPos = Cam:WorldToViewportPoint(head.Position)
                local legPos = Cam:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                local boxHeight = math.abs(headPos.Y - legPos.Y)
                local boxWidth = boxHeight * 0.5
                local boxPos = Vector2.new(headPos.X - (boxWidth / 2), headPos.Y)

                if Settings.ESPHealth then
                    local hpPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                    esp.HpBg.Size = UDim2.fromOffset(3, boxHeight)
                    esp.HpBg.Position = UDim2.fromOffset(boxPos.X - 8, boxPos.Y)
                    esp.HpBg.Visible = true

                    esp.HpBar.Size = UDim2.new(1, 0, hpPercent, 0)
                    esp.HpBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0):Lerp(Color3.fromRGB(0, 255, 100),hpPercent)
                else
                    esp.HpBg.Visible = false
                end

                if Settings.ESPDist then
                    esp.Dist.Text = distMeters .. "m"
                    esp.Dist.Size = UDim2.fromOffset(boxWidth, 14)
                    esp.Dist.Position = UDim2.fromOffset(boxPos.X, boxPos.Y + boxHeight + 2)
                    esp.Dist.TextColor3 = espColor
                    esp.Dist.Visible = true
                else
                    esp.Dist.Visible = false
                end

                if Settings.ESPName then
                    esp.Name.Text = player.Name
                    esp.Name.Size = UDim2.fromOffset(boxWidth, 14)
                    esp.Name.Position = UDim2.fromOffset(boxPos.X, boxPos.Y - 16)
                    esp.Name.TextColor3 = espColor
                    esp.Name.Visible = true
                else
                    esp.Name.Visible = false
                end
            else
                for _, line in pairs(esp.Lines) do line.Visible = false end
                esp.HpBg.Visible = false
                esp.Dist.Visible = false
                esp.Name.Visible = false
            end
        else
            for _, line in pairs(esp.Lines) do line.Visible = false end
            esp.HpBg.Visible = false
            esp.Dist.Visible = false
            esp.Name.Visible = false
        end
    end
end)
