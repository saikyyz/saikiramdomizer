-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "RandomizerGUI"
gui.ResetOnSpawn = false
gui.Parent = localPlayer:WaitForChild("PlayerGui")
gui.Enabled = false -- for fade-in

-- Fade-in animation
task.delay(0.1, function()
    gui.Enabled = true
    for _, obj in ipairs(gui:GetDescendants()) do
        if obj:IsA("GuiObject") then
            obj.BackgroundTransparency = 1
            obj.TextTransparency = 1
            task.spawn(function()
                for i = 1, 10 do
                    obj.BackgroundTransparency = 1 - (i * 0.1)
                    obj.TextTransparency = 1 - (i * 0.1)
                    task.wait(0.02)
                end
            end)
        end
    end
end)

-- Draggable frame for buttons
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 140)
mainFrame.Position = UDim2.new(1, -210, 0, 60)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

-- Styling
local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 10)

local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Transparency = 0.7
stroke.Thickness = 1.5

local layout = Instance.new("UIListLayout", mainFrame)
layout.FillDirection = Enum.FillDirection.Vertical
layout.Padding = UDim.new(0, 6)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top

-- Spacer
local pad = Instance.new("UIPadding", mainFrame)
pad.Top = UDim.new(0, 10)
pad.Left = UDim.new(0, 10)
pad.Right = UDim.new(0, 10)

-- Button creator
local function createStyledButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 30)
    button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Text = text
    button.TextScaled = true
    button.Font = Enum.Font.GothamSemibold
    button.AutoButtonColor = false

    local corner = Instance.new("UICorner", button)
    corner.CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", button)
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 1.2
    stroke.Transparency = 0.4

    local gradient = Instance.new("UIGradient", button)
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(65, 65, 65)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 25))
    }
    gradient.Rotation = 90

    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    end)

    button.MouseButton1Click:Connect(callback)

    button.Parent = mainFrame
    return button
end

-- Button callbacks
local stopBtn
stopBtn = createStyledButton("[A] Auto Stop: ON", function()
    autoStopOn = not autoStopOn
    stopBtn.Text = autoStopOn and "[A] Auto Stop: ON" or "[A] Auto Stop: OFF"
end)

createStyledButton("❓ Info", function()
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Info",
            Text = "Auto Stop when found: Raccoon, Dragonfly, Queen Bee, Red Fox, Disco Bee, Butterfly.",
            Duration = 5
        })
    end)
end)

createStyledButton("[B] Reroll Pet Display", function()
    for objectId, data in pairs(displayedEggs) do
        local pet = getNonRepeatingRandomPet(data.eggName, data.lastPet)
        if pet and data.label then
            data.label.Text = data.eggName .. " | " .. pet
            data.lastPet = pet
        end
    end
end)
