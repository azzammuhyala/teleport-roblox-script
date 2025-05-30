-- Teleport Script By Azzam Muhyala📄
-- Universal Script📌

-- bagian ini mencegah skrip ini berjalan 2 kali selama skrip ini belum di tutup
if ZAM_SCRIPT_TELEPORT_LOADED then
    return
end

-- hanya tersedia untuk executor
pcall(function() getgenv().ZAM_SCRIPT_TELEPORT_LOADED = true end)

-- untuk dragging frame teleport to players
local dragging = false
local dragInput, dragStart, startPosition

-- layanan
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")

-- mendapatkan pemain
local LocalPlayer = Players.LocalPlayer

-- mendapatkan atribut gui dan event mouse dari pemain
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Mouse = LocalPlayer:GetMouse()

-- tunggu untuk memastikan semuanya sudah siap
task.wait(1)

-- notifikasi bahwa skrip mulai dimuat dan layanan siap dipakai
StarterGui:SetCore("SendNotification", {
    Icon = "rbxassetid://12941020168",
    Title = "Teleport Script",
    Text = "Made By Azzam Muhyala",
    Duration = 5
})

-- balok indikator untuk click to teleport
local partIndicator = Instance.new("Part")
partIndicator.Name = "ZamScriptTeleportPartIndicator"
partIndicator.Shape = Enum.PartType.Ball
partIndicator.Material = Enum.Material.Neon
partIndicator.Size = Vector3.new(1, 1, 1)
partIndicator.Color = Color3.fromRGB(255, 0, 0)
partIndicator.Anchored = true
partIndicator.CanCollide = false
partIndicator.CanTouch = false

-- alat untuk click to teleport
local clickToTeleportTool = Instance.new("Tool")
clickToTeleportTool.Name = "Click To Teleport"
clickToTeleportTool.RequiresHandle = false
clickToTeleportTool.CanBeDropped = false

-- kanvas utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZamScriptTeleportToPlayer"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

-- frame utama
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.Size = UDim2.new(0.1, 100, 0.1, 200)
mainFrame.BackgroundTransparency = 1
mainFrame.Parent = ScreenGui

-- header untuk title, tombol minimize, dan tombol tutup sekaligus sebagai input dragging
local headerFrame = Instance.new("Frame")
headerFrame.Name = "HeaderFrame"
headerFrame.Size = UDim2.new(1, 0, 0.15, 0)
headerFrame.BackgroundTransparency = 1
headerFrame.LayoutOrder = 1
headerFrame.Active = true
headerFrame.Parent = mainFrame

-- navbar untuk pencarian server pemain
local navbarFrame = Instance.new("Frame")
navbarFrame.Name = "NavbarFrame"
navbarFrame.Size = UDim2.new(1, 0, 0.1, 0)
navbarFrame.BackgroundTransparency = 1
navbarFrame.LayoutOrder = 2
navbarFrame.Parent = mainFrame

-- list untuk semua pemain yang ada di server
local listPlayersScrollingFrame = Instance.new("ScrollingFrame")
listPlayersScrollingFrame.Name = "ListPlayersScrollingFrame"
listPlayersScrollingFrame.Size = UDim2.new(1, 0, 0.75, 0)
listPlayersScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
listPlayersScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
listPlayersScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
listPlayersScrollingFrame.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
listPlayersScrollingFrame.ScrollBarThickness = 4
listPlayersScrollingFrame.LayoutOrder = 3
listPlayersScrollingFrame.Parent = mainFrame

-- title
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(0.8, 0, 1, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(84, 84, 84)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.SourceSans
titleLabel.Text = "Teleport To Player"
titleLabel.TextScaled = true
titleLabel.TextWrapped = true
titleLabel.LayoutOrder = 1
titleLabel.Parent = headerFrame

-- tombol minimize untuk mengecilkan frame
local minimizeButton = Instance.new("ImageButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(1, 0, 1, 0)
minimizeButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
minimizeButton.Image = "rbxassetid://133258489499035"
minimizeButton.BackgroundColor3 = Color3.fromRGB(84, 84, 84)
minimizeButton.LayoutOrder = 2
minimizeButton.Parent = headerFrame

-- tombol tutup untuk keluar
local closeButton = Instance.new("ImageButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(1, 0, 1, 0)
closeButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
closeButton.Image = "rbxassetid://92186614586776"
closeButton.BackgroundColor3 = Color3.fromRGB(84, 84, 84)
closeButton.LayoutOrder = 3
closeButton.Parent = headerFrame

-- pencarian pemain
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

-- tombol batal pencarian (filter pencarian dihapus)
local cancelSearchButton = Instance.new("ImageButton")
cancelSearchButton.Name = "CancelSearchButton"
cancelSearchButton.Size = UDim2.new(1, 0, 1, 0)
cancelSearchButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
cancelSearchButton.Image = "rbxassetid://92186614586776"
cancelSearchButton.BackgroundColor3 = Color3.fromRGB(84, 84, 84)
cancelSearchButton.LayoutOrder = 2
cancelSearchButton.Parent = navbarFrame

-- tombol teleport ke pemain
local tpPlayerButton = Instance.new("TextButton")
tpPlayerButton.Name = "TeleportPlayer"
tpPlayerButton.Size = UDim2.new(1, 0, 0.15, 0)
tpPlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
tpPlayerButton.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
tpPlayerButton.Font = Enum.Font.SourceSans
tpPlayerButton.TextScaled = true
tpPlayerButton.TextWrapped = true

-- padding
local universalPadding = Instance.new("UIPadding")
universalPadding.PaddingRight = UDim.new(0, 2)
universalPadding.PaddingLeft = UDim.new(0, 2)
universalPadding.PaddingTop = UDim.new(0, 2)
universalPadding.PaddingBottom = UDim.new(0, 2)

universalPadding:Clone().Parent = titleLabel
universalPadding:Clone().Parent = searchBar
universalPadding:Clone().Parent = listPlayersScrollingFrame
universalPadding:Clone().Parent = tpPlayerButton

-- layout
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

-- pengecekan apakah RaycastFilterType.Exclude ada dalam suatu permainan
local RaycaseFilterTypeExclude
local success, _ = pcall(function() return Enum.RaycastFilterType.Exclude end)

if success then
    -- jika iya maka pakai Enum.RaycastFilterType.Exclude
    RaycaseFilterTypeExclude = Enum.RaycastFilterType.Exclude
else
    -- jika tidak kemungkinan permainan menggunakan versi lama dengan Enum.RaycastFilterType.Blacklist
    RaycaseFilterTypeExclude = Enum.RaycastFilterType.Blacklist
end

-- filter pencarian pemain
local function matchPlayer(displayName, username)
    local lowerKeyword = string.lower(searchBar.Text)

    return (
        not searchBar.Text or
        string.find(string.lower(displayName), lowerKeyword) or
        string.find(string.lower(username), lowerKeyword)
    )
end

-- pembaruan list pemain di dalam server
local function updatePlayers()
    -- hapus semua tombol di dalam list
    for _, child in ipairs(listPlayersScrollingFrame:GetChildren()) do
        if child:IsA("TextButton") and child.Name == "TeleportPlayer" then
            child:Destroy()
        end
    end

    -- mendapatkan semua pemain dalam server
    local listPlayers = Players:GetPlayers()

    -- urutkan berdasarkan urutan ASCII (atau abjad) dari nama display pemain
    table.sort(listPlayers, function(a, b) return a.DisplayName < b.DisplayName end)

    for _, player in pairs(listPlayers) do
        local displayName = player.DisplayName
        local username = player.Name

        -- mengecualikan pemain utama (LokalPlayer) dan mefilter pemain dari teks pencarian
        if player ~= LocalPlayer and matchPlayer(displayName, username) then
            local button = tpPlayerButton:Clone()

            button.Text = displayName .. " (@" .. username .. ")"
            button.Parent = listPlayersScrollingFrame

            -- fungsi aksi ketika tombol di tekan maka teleport ke pemain target
            button.Activated:Connect(function()
                local targetCharacter = player.Character
                local myCharacter = LocalPlayer.Character

                -- jika keduanya memiliki karakter lalu
                if targetCharacter and myCharacter then
                    local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
                    local myRoot = myCharacter:FindFirstChild("HumanoidRootPart")

                    -- jika keduanya memiliki root part lalu teleport ke target
                    if targetRoot and myRoot then
                        myRoot.CFrame = targetRoot.CFrame
                    end
                end
            end)
        end
    end
end

-- taruh tool click to teleport ke backpack pemain (jaga-jaga jika backpack belum ada atau belum siap menggunakan pcall)
pcall(function() clickToTeleportTool.Parent = LocalPlayer.Backpack end)
-- update pemain saat pertama execute
updatePlayers()

local playerAdded = Players.PlayerAdded:Connect(updatePlayers)      -- update ketika ada pemain yang baru
local playerRemoved = Players.PlayerRemoving:Connect(updatePlayers) -- update ketika ada pemain yang keluar

-- fungsi dragging
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

-- filter pemain tiap perubahan input teks
searchBar.Changed:Connect(function(property)
    if property == "Text" then
        updatePlayers()
    end
end)

-- hapus teks pencarian (tidak mefilter pemain berdasarkan pencarian)
cancelSearchButton.Activated:Connect(function()
    searchBar.Text = ""
    updatePlayers()
end)

-- saat tool diaktifkan maka taruh part indikator ke workspace
clickToTeleportTool.Equipped:Connect(function()
    partIndicator.Parent = workspace
end)

-- saat tool di nonaktifkan maka hapus part indikator dari workspace
clickToTeleportTool.Unequipped:Connect(function()
    partIndicator.Parent = nil
end)

-- saat tool di tekan
clickToTeleportTool.Activated:Connect(function()
    -- fungsi ini mefilter part indikator dan meteleportasi pemain ke posisi yang di klik
    local camera = workspace.CurrentCamera
    local unitRay = camera:ScreenPointToRay(Mouse.X, Mouse.Y)

    local rayParams = RaycastParams.new()
    rayParams.FilterType = RaycaseFilterTypeExclude
    rayParams.FilterDescendantsInstances = {partIndicator}

    local result = workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000, rayParams)
    local character = LocalPlayer.Character

    if result and character then
        local myRoot = character:FindFirstChild("HumanoidRootPart")
        if myRoot then
            myRoot.CFrame = CFrame.new(result.Position + Vector3.new(0, myRoot.Size.Y * 2, 0)) *
                            CFrame.Angles(0, myRoot.CFrame:ToEulerAnglesYXZ()) -- mempertahankan rotasi pemain
        end
    end
end)

-- update posisi part indikator tiap gerakan mouse
local updateBallPosition = Mouse.Move:Connect(function()
    if partIndicator.Parent then
        partIndicator.Position = Mouse.Hit.Position
    end
end)

-- menambahkan tool jika saat pemain mati
local enableTool = LocalPlayer.CharacterAdded:Connect(function()
    -- tunggu sampai backpack tersedia di pemain dengan menunggu selama maksimal 5 detik
    local backpack = LocalPlayer:WaitForChild("Backpack", 5)

    if backpack and LocalPlayer.Backpack:FindFirstChild("Click To Teleport") ~= clickToTeleportTool then
        clickToTeleportTool.Parent = backpack
    end
end)

-- filter posisi yaitu part indikator
local filterPosition = RunService.RenderStepped:Connect(function()
    if partIndicator.Parent then
        local camera = workspace.CurrentCamera
        local unitRay = camera:ScreenPointToRay(Mouse.X, Mouse.Y)

        local rayParams = RaycastParams.new()
        rayParams.FilterType = RaycaseFilterTypeExclude
        rayParams.FilterDescendantsInstances = {partIndicator}

        local result = workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000, rayParams)

        if result then
            partIndicator.Position = result.Position
        end
    end
end)

-- minimize frame saat tombol minimize di tekan
minimizeButton.Activated:Connect(function()
    if navbarFrame.Visible then
        navbarFrame.Visible = false
        listPlayersScrollingFrame.Visible = false

        titleLabel.BackgroundTransparency = 0.7
    else
        navbarFrame.Visible = true
        listPlayersScrollingFrame.Visible = true

        titleLabel.BackgroundTransparency = 0
    end
end)

-- tombol untuk keluar
closeButton.Activated:Connect(function()
    -- hapus kanvas, dan semua event serta tool
    ScreenGui:Destroy()
    playerAdded:Disconnect()
    playerRemoved:Disconnect()
    updateUIPosition:Disconnect()
    enableTool:Disconnect()
    updateBallPosition:Disconnect()
    filterPosition:Disconnect()

    clickToTeleportTool.Parent = nil

    -- hanya tersedia untuk executor
    pcall(function() getgenv().ZAM_SCRIPT_TELEPORT_LOADED = nil end)

    -- notifikasi bahwa semuanya telah dihapus
    StarterGui:SetCore("SendNotification", {
        Icon = "rbxassetid://12941020168",
        Title = "Teleport Script Closed",
        Text = "Bye, see you soon!",
        Duration = 5
    })
end)
