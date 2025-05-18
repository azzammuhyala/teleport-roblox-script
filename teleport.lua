-- Teleport Script By Azzam Muhyala
-- Day 3 bikin script sendiri :v

local players = game.Players
local localPlayer = players.LocalPlayer

local mouse = localPlayer:GetMouse()

local clickToTeleportTool = Instance.new("Tool")
clickToTeleportTool.Name = "Click To Teleport"
clickToTeleportTool.RequiresHandle = false
clickToTeleportTool.CanBeDropped = false
clickToTeleportTool.Activated:Connect(function()
    localPlayer.Character.HumanoidRootPart.CFrame = mouse.Hit + Vector3.new(0, 3, 0)
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZamScriptTeleportToPlayer"
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
headerFrame.BackgroundTransparency = 1
headerFrame.LayoutOrder = 1
headerFrame.Parent = mainFrame

local navbarFrame = Instance.new("Frame")
navbarFrame.Size = UDim2.new(1, 0, 0.1, 0)
navbarFrame.BackgroundTransparency = 1
navbarFrame.LayoutOrder = 2
navbarFrame.Parent = mainFrame

local listPlayersScrollingFrame = Instance.new("ScrollingFrame")
listPlayersScrollingFrame.Size = UDim2.new(1, 0, 0.75, 0)
listPlayersScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
listPlayersScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
listPlayersScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
listPlayersScrollingFrame.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
listPlayersScrollingFrame.ScrollBarThickness = 0
listPlayersScrollingFrame.LayoutOrder = 3
listPlayersScrollingFrame.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(84, 84, 84)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.SourceSans
titleLabel.Text = "Teleport To Player"
titleLabel.TextScaled = true
titleLabel.TextWrapped = true
titleLabel.LayoutOrder = 1
titleLabel.Parent = headerFrame

local minimizeButton = Instance.new("ImageButton")
minimizeButton.Size = UDim2.new(1, 0, 1, 0)
minimizeButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
minimizeButton.Image = "rbxassetid://133258489499035"
minimizeButton.BackgroundColor3 = Color3.fromRGB(84, 84, 84)
minimizeButton.LayoutOrder = 2
minimizeButton.Parent = headerFrame

local closeButton = Instance.new("ImageButton")
closeButton.Size = UDim2.new(1, 0, 1, 0)
closeButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
closeButton.Image = "rbxassetid://92186614586776"
closeButton.BackgroundColor3 = Color3.fromRGB(84, 84, 84)
closeButton.LayoutOrder = 3
closeButton.Parent = headerFrame

local searchBar = Instance.new("TextBox")
searchBar.Size = UDim2.new(1, 0, 1, 0)
searchBar.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
searchBar.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBar.PlaceholderColor3 = Color3.fromRGB(106, 106, 106)
searchBar.Font = Enum.Font.SourceSans
searchBar.Text = ""
searchBar.PlaceholderText = "Search Player"
searchBar.TextScaled = true
searchBar.TextWrapped = true
searchBar.LayoutOrder = 1
searchBar.Parent = navbarFrame

local cancelSearchButton = Instance.new("ImageButton")
cancelSearchButton.Size = UDim2.new(1, 0, 1, 0)
cancelSearchButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
cancelSearchButton.Image = "rbxassetid://92186614586776"
cancelSearchButton.BackgroundColor3 = Color3.fromRGB(84, 84, 84)
cancelSearchButton.LayoutOrder = 2
cancelSearchButton.Parent = navbarFrame

local mainFrameLayout = Instance.new("UIListLayout")
mainFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
mainFrameLayout.FillDirection = Enum.FillDirection.Vertical
mainFrameLayout.Parent = mainFrame

local headerFrameLayout = Instance.new("UIListLayout")
headerFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
headerFrameLayout.FillDirection = Enum.FillDirection.Horizontal
headerFrameLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
headerFrameLayout.Parent = headerFrame

local navbarFrameLayout = Instance.new("UIListLayout")
navbarFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
navbarFrameLayout.FillDirection = Enum.FillDirection.Horizontal
navbarFrameLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
navbarFrameLayout.Parent = navbarFrame

local scrollingFrameLayout = Instance.new("UIListLayout")
scrollingFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
scrollingFrameLayout.Padding = UDim.new(0, 5)
scrollingFrameLayout.Parent = listPlayersScrollingFrame

local function matchPlayer(displayName, username)
    local lowerDisplayName = string.lower(displayName)
    local lowerUsername = string.lower(username)
    local lowerKeyword = string.lower(searchBar.Text)

    if string.find(lowerDisplayName, lowerKeyword) or string.find(lowerUsername, lowerKeyword) then
        return true
    end

    return false
end

local function updatePlayers()
    for _, child in ipairs(listPlayersScrollingFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for _, plr in pairs(players:GetPlayers()) do

        local displayName = plr.DisplayName
        local username = plr.Name

        if plr ~= localPlayer and matchPlayer(displayName, username) then
            local button = Instance.new("TextButton")

            button.Size = UDim2.new(1, 0, 0.2, 0)
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
            button.Font = Enum.Font.SourceSans
            button.Text = displayName .. " (" .. username .. ")"
            button.TextScaled = true
            button.TextWrapped = true
            button.Parent = listPlayersScrollingFrame

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

clickToTeleportTool.Parent = localPlayer.Backpack
updatePlayers()

local updateAdded = players.PlayerAdded:Connect(updatePlayers)
local updateRemoved = players.PlayerRemoving:Connect(updatePlayers)
local updateCharAdded = localPlayer.CharacterAdded:Connect(function()
    repeat task.wait() until localPlayer:FindFirstChild("Backpack")
    if not localPlayer.Backpack:FindFirstChild("Click To Teleport") then
        clickToTeleportTool.Parent = localPlayer.Backpack
    end
end)

searchBar.Changed:Connect(function(property)
    if property == "Text" then
        updatePlayers()
    end
end)

cancelSearchButton.Activated:Connect(function()
    searchBar.Text = ""
    updatePlayers()
end)

minimizeButton.Activated:Connect(function()
    if listPlayersScrollingFrame.Visible then
        mainFrame.Active = false
        navbarFrame.Visible = false
        listPlayersScrollingFrame.Visible = false

        titleLabel.BackgroundTransparency = 0.5
    else
        mainFrame.Active = true
        navbarFrame.Visible = true
        listPlayersScrollingFrame.Visible = true

        titleLabel.BackgroundTransparency = 0
    end
end)

closeButton.Activated:Connect(function()
    screenGui:Destroy()
    updateAdded:Disconnect()
    updateRemoved:Disconnect()
    updateCharAdded:Disconnect()

    clickToTeleportTool.Parent = nil
end)
