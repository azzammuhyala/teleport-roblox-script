-- Teleport Script By Azzam Muhyala
-- Day 2 bikin script sendiri :v

local players = game.Players
local localPlayer = players.LocalPlayer

local mouse = localPlayer:GetMouse()

local clickToTeleportTool = Instance.new("Tool")
clickToTeleportTool.Name = "Click To Teleport"
clickToTeleportTool.RequiresHandle = false
clickToTeleportTool.CanBeDropped = false
clickToTeleportTool.Activated:Connect(function ()
    localPlayer.Character.HumanoidRootPart.CFrame = mouse.Hit + Vector3.new(0, 3, 0)
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportToPlayer"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = localPlayer.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.Size = UDim2.new(0.25, 0, 0.5, 0)
mainFrame.BackgroundTransparency = 1
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local headerFrame = Instance.new("Frame")
headerFrame.Size = UDim2.new(1, 0, 0.15, 0)
headerFrame.BackgroundColor3 = Color3.fromRGB(84, 84, 84)
headerFrame.LayoutOrder = 1
headerFrame.Parent = mainFrame

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, 0, 0.85, 0)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
scrollingFrame.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
scrollingFrame.ScrollBarThickness = 0
scrollingFrame.LayoutOrder = 2
scrollingFrame.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.Text = "Teleport To Player"
titleLabel.Font = Enum.Font.SourceSans
titleLabel.TextScaled = true
titleLabel.TextWrapped = true
titleLabel.BackgroundColor3 = Color3.fromRGB(84, 84, 84)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.LayoutOrder = 1
titleLabel.Parent = headerFrame

local minimizeButton = Instance.new("ImageButton")
minimizeButton.Size = UDim2.new(1, 0, 1, 0)
minimizeButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
minimizeButton.LayoutOrder = 2
minimizeButton.BackgroundColor3 = Color3.fromRGB(84, 84, 84)
minimizeButton.Image = "rbxassetid://133258489499035"
minimizeButton.Parent = headerFrame

local closeButton = Instance.new("ImageButton")
closeButton.Size = UDim2.new(1, 0, 1, 0)
closeButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
closeButton.LayoutOrder = 3
closeButton.Image = "rbxassetid://92186614586776"
closeButton.BackgroundColor3 = Color3.fromRGB(84, 84, 84)
closeButton.Parent = headerFrame

local mainFrameLayout = Instance.new("UIListLayout")
mainFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
mainFrameLayout.FillDirection = Enum.FillDirection.Vertical
mainFrameLayout.Parent = mainFrame

local headerFrameLayout = Instance.new("UIListLayout")
headerFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
headerFrameLayout.FillDirection = Enum.FillDirection.Horizontal
headerFrameLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
headerFrameLayout.Parent = headerFrame

local scrollingFrameLayout = Instance.new("UIListLayout")
scrollingFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
scrollingFrameLayout.Padding = UDim.new(0, 5)
scrollingFrameLayout.Parent = scrollingFrame

local function updatePlayers()
    for _, child in ipairs(scrollingFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for _, plr in pairs(players:GetPlayers()) do

        if plr ~= localPlayer then
            local button = Instance.new("TextButton")

            button.Size = UDim2.new(1, 0, 0.2, 0)
            button.Text = plr.DisplayName .. " (" .. plr.Name .. ")"
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
            button.Font = Enum.Font.SourceSans
            button.TextScaled = true
            button.TextWrapped = true
            button.Parent = scrollingFrame

            button.Activated:Connect(function()
                local targetChar = plr.Character
                local myChar = localPlayer.Character

                if targetChar and myChar then
                    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
                    local myRoot = myChar:FindFirstChild("HumanoidRootPart")

                    if targetRoot and myRoot then
                        myRoot.CFrame = targetRoot.CFrame
                    end
                end
            end)
        end
    end
end

local function createClickToTeleport()
    clickToTeleportTool.Parent = localPlayer.Backpack
end

createClickToTeleport()
updatePlayers()

local updateAdded = players.PlayerAdded:Connect(updatePlayers)
local updateRemoved = players.PlayerRemoving:Connect(updatePlayers)
local updateCharAdded = localPlayer.CharacterAdded:Connect(function()
    repeat task.wait() until localPlayer:FindFirstChild("Backpack")
    if not localPlayer.Backpack:FindFirstChild("Click To Teleport") then
        createClickToTeleport()
    end
end)

minimizeButton.Activated:Connect(function()
    if scrollingFrame.Visible then
        scrollingFrame.Visible = false
        mainFrame.Active = false
    else
        scrollingFrame.Visible = true
        mainFrame.Active = true
    end
end)

closeButton.Activated:Connect(function()
    screenGui:Destroy()
    updateAdded:Disconnect()
    updateRemoved:Disconnect()
    updateCharAdded:Disconnect()

    clickToTeleportTool.Parent = nil
end)
