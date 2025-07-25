-- Teleport Script By Azzam Muhyala📄
-- Universal Script📌

-- bagian ini mencegah skrip ini berjalan 2 kali selama skrip ini belum di tutup
if ZAM_SCRIPT_TELEPORT_LOADED then
    return
end

-- tunggu untuk memastikan semuanya sudah siap
repeat until game:IsLoaded()
task.wait(1)

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

-- fungsi untuk menghasilkan string acak
local function randomString(length, m, n)
    length = length or 32
    m = m or 32
    n = n or 126

    local result = ""

    for _ = 1, length do
        result = result .. string.char(math.random(m, n))
    end

    return result
end

-- notifikasi bahwa skrip mulai dimuat dan layanan siap dipakai
StarterGui:SetCore("SendNotification", {
    Icon = "rbxassetid://12941020168",
    Title = "Teleport Script",
    Text = "Made By Azzam Muhyala",
    Duration = 5
})

-- balok indikator untuk click to teleport
local clickToTeleportPartIndicator = Instance.new("Part")
clickToTeleportPartIndicator.Name = "ZamScriptClickToTeleportPartIndicator - " .. randomString()
clickToTeleportPartIndicator.Shape = Enum.PartType.Ball
clickToTeleportPartIndicator.Material = Enum.Material.Neon
clickToTeleportPartIndicator.Size = Vector3.new(1, 1, 1)
clickToTeleportPartIndicator.Color = Color3.fromRGB(255, 0, 255)
clickToTeleportPartIndicator.Anchored = true
clickToTeleportPartIndicator.CanCollide = false
clickToTeleportPartIndicator.CanTouch = false

-- alat untuk click to teleport
local clickToTeleportTool = Instance.new("Tool")
clickToTeleportTool.Name = "Click To Teleport"
clickToTeleportTool.ToolTip = "Teleport to the point you clicked"
clickToTeleportTool.RequiresHandle = false
clickToTeleportTool.CanBeDropped = false

-- kanvas utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZamScriptTeleportToPlayer - " .. randomString()
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

-- frame utama
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.Size = UDim2.new(0.1, 150, 0.1, 200)
mainFrame.BackgroundTransparency = 1
mainFrame.Parent = ScreenGui

-- header untuk title, tombol minimize, dan tombol tutup sekaligus sebagai dragging
local headerFrame = Instance.new("Frame")
headerFrame.Name = "HeaderFrame"
headerFrame.Size = UDim2.new(1, 0, 0.125, 0)
headerFrame.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
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
listPlayersScrollingFrame.Size = UDim2.new(1, 0, 0.775, 0)
listPlayersScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
listPlayersScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
listPlayersScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
listPlayersScrollingFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
listPlayersScrollingFrame.ScrollBarThickness = 0
listPlayersScrollingFrame.LayoutOrder = 3
listPlayersScrollingFrame.Parent = mainFrame

-- title
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.SourceSans
titleLabel.Text = "Teleport To Player"
titleLabel.TextScaled = true
titleLabel.TextWrapped = true
titleLabel.LayoutOrder = 1
titleLabel.Parent = headerFrame

-- tombol navigasi
local navigationButton = Instance.new("ImageButton")
navigationButton.Size = UDim2.new(1, 0, 1, 0)
navigationButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
navigationButton.BackgroundTransparency = 1

-- tombol refresh untuk merefresh list pemain
local refreshButton = navigationButton:Clone()
refreshButton.Name = "RefreshButton"
refreshButton.Image = "rbxassetid://13364258627"
refreshButton.LayoutOrder = 2
refreshButton.Parent = headerFrame

-- tombol minimize untuk mengecilkan frame
local minimizeButton = navigationButton:Clone()
minimizeButton.Name = "MinimizeButton"
minimizeButton.Image = "rbxassetid://133258489499035"
minimizeButton.LayoutOrder = 3
minimizeButton.Parent = headerFrame

-- tombol tutup untuk keluar
local closeButton = navigationButton:Clone()
closeButton.Name = "CloseButton"
closeButton.Image = "rbxassetid://92186614586776"
closeButton.LayoutOrder = 4
closeButton.Parent = headerFrame

-- pencarian pemain
local searchPlayerBar = Instance.new("TextBox")
searchPlayerBar.Name = "SearchPlayerBar"
searchPlayerBar.Size = UDim2.new(1, 0, 1, 0)
searchPlayerBar.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
searchPlayerBar.TextColor3 = Color3.fromRGB(255, 255, 255)
searchPlayerBar.PlaceholderColor3 = Color3.fromRGB(110, 110, 110)
searchPlayerBar.Font = Enum.Font.SourceSans
searchPlayerBar.Text = ""
searchPlayerBar.PlaceholderText = "🔎 Search Players"
searchPlayerBar.TextScaled = true
searchPlayerBar.TextWrapped = true
searchPlayerBar.LayoutOrder = 1
searchPlayerBar.Parent = navbarFrame

-- tombol batal pencarian (filter pencarian dihapus)
local cancelSearchPlayerButton = Instance.new("ImageButton")
cancelSearchPlayerButton.Name = "CancelSearchPlayerButton"
cancelSearchPlayerButton.Size = UDim2.new(1, 0, 1, 0)
cancelSearchPlayerButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
cancelSearchPlayerButton.Image = "rbxassetid://92186614586776"
cancelSearchPlayerButton.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
cancelSearchPlayerButton.LayoutOrder = 2
cancelSearchPlayerButton.Parent = navbarFrame

-- tombol teleport ke pemain
local teleportToPlayerButton = Instance.new("TextButton")
teleportToPlayerButton.Name = "TeleportToPlayerButton"
teleportToPlayerButton.Size = UDim2.new(1, 0, 0.15, 0)
teleportToPlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportToPlayerButton.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
teleportToPlayerButton.Font = Enum.Font.SourceSans
teleportToPlayerButton.TextScaled = true
teleportToPlayerButton.TextWrapped = true

-- padding
local universalPadding = Instance.new("UIPadding")
universalPadding.PaddingRight = UDim.new(0, 2)
universalPadding.PaddingLeft = UDim.new(0, 2)
universalPadding.PaddingTop = UDim.new(0, 2)
universalPadding.PaddingBottom = UDim.new(0, 2)

universalPadding:Clone().Parent = titleLabel
universalPadding:Clone().Parent = searchPlayerBar
universalPadding:Clone().Parent = teleportToPlayerButton

local listPlayersScrollingFramePadding = universalPadding:Clone()
listPlayersScrollingFramePadding.Parent = listPlayersScrollingFrame

-- layout
local mainFrameLayout = Instance.new("UIListLayout")
mainFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
mainFrameLayout.FillDirection = Enum.FillDirection.Vertical
mainFrameLayout.Parent = mainFrame

local headerFrameLayout = Instance.new("UIListLayout")
headerFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
headerFrameLayout.FillDirection = Enum.FillDirection.Horizontal
headerFrameLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
headerFrameLayout.VerticalAlignment = Enum.VerticalAlignment.Center
headerFrameLayout.Padding = UDim.new(0, 2)
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
local function matchPlayer(displayName, name)
    local lowerKeyword = string.lower(searchPlayerBar.Text)

    return (
        not searchPlayerBar.Text or
        string.find(string.lower(displayName), lowerKeyword) or
        string.find(string.lower(name), lowerKeyword)
    )
end

-- pembaruan list pemain di dalam server
local function updatePlayers()
    -- hapus semua tombol di dalam list
    for _, child in ipairs(listPlayersScrollingFrame:GetChildren()) do
        if child:IsA("TextButton") and child.Name == teleportToPlayerButton.Name then
            child:Destroy()
        end
    end

    -- menyimpan panjang isi list
    local totalHeight = 0
    local totalButton = 0

    -- mendapatkan semua pemain dalam server
    local listPlayers = Players:GetPlayers()

    -- urutkan berdasarkan urutan ASCII dari nama display pemain
    table.sort(listPlayers, function(a, b) return a.DisplayName < b.DisplayName end)

    -- cek apakah ada setidaknya 1 pemain aktif (selain pemain utama)
    if #listPlayers - 1 == 0 then
        searchPlayerBar.PlaceholderText = "❌ No Players Found"
    else
        searchPlayerBar.PlaceholderText = "🔎 Search Players"
    end

    for _, player in pairs(listPlayers) do
        local displayName = player.DisplayName
        local name = player.Name

        -- mengecualikan pemain utama (LokalPlayer) dan mefilter pemain dari teks pencarian
        if player ~= LocalPlayer and matchPlayer(displayName, name) then
            local button = teleportToPlayerButton:Clone()

            button.Text = displayName .. " (@" .. name .. ")"
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

            totalButton = totalButton + 1
            totalHeight = totalHeight + button.AbsoluteSize.Y
        end
    end

    totalHeight = totalHeight + listPlayersScrollingFrameLayout.Padding.Offset * (totalButton - 1)

    if totalHeight > listPlayersScrollingFrame.AbsoluteSize.Y then
        -- jika total panjang list lebih besar dari ukuran layar maka aktifkan scroll bar dan padding menjadi 7
        listPlayersScrollingFrame.ScrollBarThickness = 5
        listPlayersScrollingFramePadding.PaddingRight = UDim.new(0, 7)
    else
        -- jika tidak maka nonaktifkan scroll bar dan padding menjadi 2
        listPlayersScrollingFrame.ScrollBarThickness = 0
        listPlayersScrollingFramePadding.PaddingRight = UDim.new(0, 2)
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
searchPlayerBar.Changed:Connect(function(property)
    if property == "Text" then
        updatePlayers()
    end
end)

-- hapus teks pencarian (tidak mefilter pemain berdasarkan pencarian)
cancelSearchPlayerButton.Activated:Connect(function()
    searchPlayerBar.Text = ""
    updatePlayers()
end)

-- saat tool diaktifkan maka taruh part indikator ke workspace
clickToTeleportTool.Equipped:Connect(function()
    clickToTeleportPartIndicator.Parent = workspace
end)

-- saat tool di nonaktifkan maka hapus part indikator dari workspace
clickToTeleportTool.Unequipped:Connect(function()
    clickToTeleportPartIndicator.Parent = nil
end)

-- saat tool di tekan
clickToTeleportTool.Activated:Connect(function()
    -- fungsi ini mefilter part indikator dan meteleportasi pemain ke posisi yang di klik
    local camera = workspace.CurrentCamera
    local unitRay = camera:ScreenPointToRay(Mouse.X, Mouse.Y)

    local rayParams = RaycastParams.new()
    rayParams.FilterType = RaycaseFilterTypeExclude
    rayParams.FilterDescendantsInstances = {clickToTeleportPartIndicator}

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
    if clickToTeleportPartIndicator.Parent then
        clickToTeleportPartIndicator.Position = Mouse.Hit.Position
    end
end)

-- menambahkan click to teleport tool jika belum tersedia
local function addClickToTeleportToBackpack()
    -- tunggu sampai backpack tersedia dengan menunggu selama maksimal 3 detik
    local backpack = LocalPlayer:WaitForChild("Backpack", 1)

    -- cek apakah tool sudah ada di backpack dan sesuai dengan fungsi tool,
    -- jika tidak memenuhi maka tambahkan tool ke backpack
    if backpack and backpack:WaitForChild(clickToTeleportTool.Name, 1) ~= clickToTeleportTool then
        clickToTeleportTool.Parent = backpack
    end
end

-- saat pemain mati
local enableTool = LocalPlayer.CharacterAdded:Connect(addClickToTeleportToBackpack)

-- filter posisi yaitu part indikator
local filterPosition = RunService.RenderStepped:Connect(function()
    if clickToTeleportPartIndicator.Parent then
        local camera = workspace.CurrentCamera
        local unitRay = camera:ScreenPointToRay(Mouse.X, Mouse.Y)

        local rayParams = RaycastParams.new()
        rayParams.FilterType = RaycaseFilterTypeExclude
        rayParams.FilterDescendantsInstances = {clickToTeleportPartIndicator}

        local result = workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000, rayParams)

        if result then
            clickToTeleportPartIndicator.Position = result.Position
        end
    end
end)

-- referesh list pemain
refreshButton.Activated:Connect(function()
    updatePlayers()
    addClickToTeleportToBackpack()
end)

-- minimize frame saat tombol minimize di tekan
minimizeButton.Activated:Connect(function()
    if navbarFrame.Visible then
        navbarFrame.Visible = false
        listPlayersScrollingFrame.Visible = false
        headerFrame.BackgroundTransparency = 0.75
    else
        navbarFrame.Visible = true
        listPlayersScrollingFrame.Visible = true
        headerFrame.BackgroundTransparency = 0
    end
end)

-- tombol untuk keluar (hapus semuanya)
closeButton.Activated:Connect(function()
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
