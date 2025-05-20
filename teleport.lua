-- Teleport Script By Azzam Muhyala
-- Day 5 bikin script sendiri :v

if ZAM_SCRIPT_TELEPORT_LOADED then
    return
end

local dragging = false
local dragInput = nil
local dragStart = nil
local startPosition = nil

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")

-- only for executor
pcall(function()
    getgenv().ZAM_SCRIPT_TELEPORT_LOADED = true
end)

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

pcall(function()
    LocalPlayer:WaitForChild("PlayerGui", 5)

    task.wait(1)

    StarterGui:SetCore("SendNotification", {
        Title = "Teleport Script",
        Text = "Made By Azzam Muhyala",
        Duration = 5
    })
end)

local ballPartIndicator = Instance.new("Part")
ballPartIndicator.Name = "ZamScriptTeleportBallIndicator"
ballPartIndicator.Shape = Enum.PartType.Ball
ballPartIndicator.Size = Vector3.new(1, 1, 1)
ballPartIndicator.Color = Color3.fromRGB(255, 0, 0)
ballPartIndicator.Material = Enum.Material.Neon
ballPartIndicator.Anchored = true
ballPartIndicator.CanCollide = false
ballPartIndicator.CanTouch = false

local clickToTeleportTool = Instance.new("Tool")
clickToTeleportTool.Name = "Click To Teleport"
clickToTeleportTool.RequiresHandle = false
clickToTeleportTool.CanBeDropped = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZamScriptTeleportToPlayer"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = LocalPlayer.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.Size = UDim2.new(0.25, 0, 0.5, 0)
mainFrame.BackgroundTransparency = 1
mainFrame.Parent = ScreenGui

local headerFrame = Instance.new("Frame")
headerFrame.Name = "HeaderFrame"
headerFrame.Size = UDim2.new(1, 0, 0.15, 0)
headerFrame.BackgroundTransparency = 1
headerFrame.LayoutOrder = 1
headerFrame.Active = true
headerFrame.Parent = mainFrame

local navbarFrame = Instance.new("Frame")
navbarFrame.Name = "NavbarFrame"
navbarFrame.Size = UDim2.new(1, 0, 0.1, 0)
navbarFrame.BackgroundTransparency = 1
navbarFrame.LayoutOrder = 2
navbarFrame.Parent = mainFrame

local listPlayersScrollingFrame = Instance.new("ScrollingFrame")
listPlayersScrollingFrame.Name = "ListPlayersScrollingFrame"
listPlayersScrollingFrame.Size = UDim2.new(1, 0, 0.75, 0)
listPlayersScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
listPlayersScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
listPlayersScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
listPlayersScrollingFrame.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
listPlayersScrollingFrame.ScrollBarThickness = 5
listPlayersScrollingFrame.LayoutOrder = 3
listPlayersScrollingFrame.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
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
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(1, 0, 1, 0)
minimizeButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
minimizeButton.Image = "rbxassetid://133258489499035"
minimizeButton.BackgroundColor3 = Color3.fromRGB(84, 84, 84)
minimizeButton.LayoutOrder = 2
minimizeButton.Parent = headerFrame

local closeButton = Instance.new("ImageButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(1, 0, 1, 0)
closeButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
closeButton.Image = "rbxassetid://92186614586776"
closeButton.BackgroundColor3 = Color3.fromRGB(84, 84, 84)
closeButton.LayoutOrder = 3
closeButton.Parent = headerFrame

local searchBar = Instance.new("TextBox")
searchBar.Name = "SearchBar"
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
cancelSearchButton.Name = "CancelSearchButton"
cancelSearchButton.Size = UDim2.new(1, 0, 1, 0)
cancelSearchButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
cancelSearchButton.Image = "rbxassetid://92186614586776"
cancelSearchButton.BackgroundColor3 = Color3.fromRGB(84, 84, 84)
cancelSearchButton.LayoutOrder = 2
cancelSearchButton.Parent = navbarFrame

local listPlayersScrollingFramePadding = Instance.new("UIPadding")
listPlayersScrollingFramePadding.PaddingRight = UDim.new(0, 5)
listPlayersScrollingFramePadding.PaddingLeft = UDim.new(0, 5)
listPlayersScrollingFramePadding.Parent = listPlayersScrollingFrame

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

local listPlayersScrollingFrameLayout = Instance.new("UIListLayout")
listPlayersScrollingFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
listPlayersScrollingFrameLayout.Padding = UDim.new(0, 5)
listPlayersScrollingFrameLayout.Parent = listPlayersScrollingFrame

local success, _ = pcall(function()
    return Enum.RaycastFilterType.Exclude
end)

local RaycaseFilterTypeExclude

if success then
    RaycaseFilterTypeExclude = Enum.RaycastFilterType.Exclude
else
    -- old version
    RaycaseFilterTypeExclude = Enum.RaycastFilterType.Blacklist
end

local function matchPlayer(displayName, username)
    local lowerKeyword = string.lower(searchBar.Text)

    return (
        not searchBar.Text or
        string.find(string.lower(displayName), lowerKeyword) or
        string.find(string.lower(username), lowerKeyword)
    )
end

local function updatePlayers()
    for _, child in ipairs(listPlayersScrollingFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    local listPlayers = Players:GetPlayers()

    table.sort(listPlayers, function(a, b)
        return a.DisplayName < b.DisplayName
    end)

    for _, player in pairs(listPlayers) do
        local displayName = player.DisplayName
        local username = player.Name

        if player ~= LocalPlayer and matchPlayer(displayName, username) then
            local button = Instance.new("TextButton")

            button.Size = UDim2.new(1, 0, 0.15, 0)
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
            button.Font = Enum.Font.SourceSans
            button.Text = displayName .. " (" .. username .. ")"
            button.TextScaled = true
            button.TextWrapped = true
            button.Parent = listPlayersScrollingFrame

            button.Activated:Connect(function()
                local targetCharacter = player.Character
                local myCharacter = LocalPlayer.Character
                if targetCharacter and myCharacter then
                    local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
                    local myRoot = myCharacter:FindFirstChild("HumanoidRootPart")
                    if targetRoot and myRoot then
                        myRoot.CFrame = targetRoot.CFrame
                    end
                end
            end)
        end
    end
end

pcall(function()
    clickToTeleportTool.Parent = LocalPlayer.Backpack
end)
updatePlayers()

local playerAdded = Players.PlayerAdded:Connect(updatePlayers)
local playerRemoved = Players.PlayerRemoving:Connect(updatePlayers)

headerFrame.InputBegan:Connect(function(input)
    if
        input.UserInputType == Enum.UserInputType.MouseButton1 or
        input.UserInputType == Enum.UserInputType.Touch
    then
        dragging = true
        dragStart = input.Position
        startPosition = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

headerFrame.InputChanged:Connect(function(input)
    if
        input.UserInputType == Enum.UserInputType.MouseMovement or
        input.UserInputType == Enum.UserInputType.Touch
    then
        dragInput = input
    end
end)

local updateUIPosition = UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPosition.X.Scale, startPosition.X.Offset + delta.X,
            startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
        )
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

clickToTeleportTool.Equipped:Connect(function()
    ballPartIndicator.Parent = workspace
end)

clickToTeleportTool.Unequipped:Connect(function()
    ballPartIndicator.Parent = nil
end)

clickToTeleportTool.Activated:Connect(function()
    local camera = workspace.CurrentCamera
    local unitRay = camera:ScreenPointToRay(Mouse.X, Mouse.Y)

    local rayParams = RaycastParams.new()
    rayParams.FilterType = RaycaseFilterTypeExclude
    rayParams.FilterDescendantsInstances = {ballPartIndicator, LocalPlayer.Character}

    local result = workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000, rayParams)
    local character = LocalPlayer.Character

    if result and character then
        local myRoot = character:FindFirstChild("HumanoidRootPart")
        if myRoot then
            myRoot.CFrame = CFrame.new(result.Position + Vector3.new(0, myRoot.Size.Y * 2, 0)) *
                            CFrame.Angles(0, myRoot.CFrame:ToEulerAnglesYXZ())
        end
    end
end)

local updateBallPosition = Mouse.Move:Connect(function()
    if ballPartIndicator.Parent then
        ballPartIndicator.Position = Mouse.Hit.Position
    end
end)

local enableTool = LocalPlayer.CharacterAdded:Connect(function()
    LocalPlayer:WaitForChild("Backpack")
    if LocalPlayer.Backpack:FindFirstChild("Click To Teleport") ~= clickToTeleportTool then
        clickToTeleportTool.Parent = LocalPlayer.Backpack
    end
end)

local filterPosition = RunService.RenderStepped:Connect(function()
    if ballPartIndicator.Parent then
        local camera = workspace.CurrentCamera
        local unitRay = camera:ScreenPointToRay(Mouse.X, Mouse.Y)

        local rayParams = RaycastParams.new()
        rayParams.FilterType = RaycaseFilterTypeExclude
        rayParams.FilterDescendantsInstances = {ballPartIndicator, LocalPlayer.Character}

        local result = workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000, rayParams)

        if result then
            ballPartIndicator.Position = result.Position
        end
    end
end)

minimizeButton.Activated:Connect(function()
    if navbarFrame.Visible then
        navbarFrame.Visible = false
        listPlayersScrollingFrame.Visible = false

        titleLabel.BackgroundTransparency = 0.5
    else
        navbarFrame.Visible = true
        listPlayersScrollingFrame.Visible = true

        titleLabel.BackgroundTransparency = 0
    end
end)

closeButton.Activated:Connect(function()
    ScreenGui:Destroy()
    playerAdded:Disconnect()
    playerRemoved:Disconnect()
    updateUIPosition:Disconnect()
    enableTool:Disconnect()
    updateBallPosition:Disconnect()
    filterPosition:Disconnect()

    clickToTeleportTool.Parent = nil

    pcall(function()
        getgenv().ZAM_SCRIPT_TELEPORT_LOADED = nil
    end)

    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Bye!",
            Text = "See you soon!",
            Duration = 5
        })
    end)
end)
