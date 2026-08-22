```
local VenyxLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/Documantation12/Universal-Vehicle-Script/main/Library.lua"))()
local Venyx = VenyxLibrary.new("Universal Vehicle Script", 5013109572)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

--------------------------------------------------
-- THEME
--------------------------------------------------

local Theme = {
    Background = Color3.fromRGB(61, 60, 124),
    Glow = Color3.fromRGB(60, 63, 221),
    Accent = Color3.fromRGB(55, 52, 90),
    LightContrast = Color3.fromRGB(64, 65, 128),
    DarkContrast = Color3.fromRGB(32, 33, 64),
    TextColor = Color3.fromRGB(255, 255, 255)
}

for index, value in pairs(Theme) do
    pcall(Venyx.setTheme, Venyx, index, value)
end

--------------------------------------------------
-- VEHICLE DETECTION
--------------------------------------------------

local function GetVehicleFromDescendant(Descendant)

    if not Descendant then
        return nil
    end

    return
        Descendant:FindFirstAncestor(LocalPlayer.Name .. "'s Car")
        or
        (Descendant:FindFirstAncestor("Body")
        and Descendant:FindFirstAncestor("Body").Parent)
        or
        (Descendant:FindFirstAncestor("Misc")
        and Descendant:FindFirstAncestor("Misc").Parent)
        or
        Descendant:FindFirstAncestorWhichIsA("Model")
end

--------------------------------------------------
-- GET CURRENT VEHICLE
--------------------------------------------------

local function GetCurrentVehicle()

    local Character = LocalPlayer.Character

    if not Character then
        return nil
    end

    local Humanoid =
        Character:FindFirstChildWhichIsA("Humanoid")

    if not Humanoid then
        return nil
    end

    local SeatPart = Humanoid.SeatPart

    if not SeatPart then
        return nil
    end

    if not SeatPart:IsA("VehicleSeat") then
        return nil
    end

    return GetVehicleFromDescendant(SeatPart)
end

--------------------------------------------------
-- TELEPORT VEHICLE
--------------------------------------------------

local function TeleportVehicle(CoordinateFrame)

    if not CoordinateFrame then
        return false
    end

    local Vehicle = GetCurrentVehicle()

    if not Vehicle then
        return false
    end

    if not Vehicle:IsA("Model") then
        return false
    end

    local Character = LocalPlayer.Character

    local success = pcall(function()

        Vehicle:PivotTo(CoordinateFrame)

    end)

    if not success then

        success = pcall(function()

            if not Vehicle.PrimaryPart then
                Vehicle.PrimaryPart =
                    Vehicle:FindFirstChildWhichIsA("BasePart")
            end

            if Vehicle.PrimaryPart then
                Vehicle:SetPrimaryPartCFrame(CoordinateFrame)
            end

        end)

    end

    if success then

        local Humanoid =
            Character
            and Character:FindFirstChildWhichIsA("Humanoid")

        local SeatPart =
            Humanoid
            and Humanoid.SeatPart

        if SeatPart and SeatPart:IsA("VehicleSeat") then

            SeatPart.AssemblyLinearVelocity =
                Vector3.zero

            SeatPart.AssemblyAngularVelocity =
                Vector3.zero

        end

    end

    return success
end

--------------------------------------------------
-- GUI
--------------------------------------------------

local vehiclePage =
    Venyx:addPage("Vehicle", 8356815386)

--------------------------------------------------
-- USAGE
--------------------------------------------------

local usageSection =
    vehiclePage:addSection("Usage")

local velocityEnabled = true

usageSection:addToggle(
    "Keybinds Active",
    velocityEnabled,
    function(v)
        velocityEnabled = v
    end
)

--------------------------------------------------
-- FLIGHT
--------------------------------------------------

local flightSection =
    vehiclePage:addSection("Flight")

local flightEnabled = false
local flightSpeed = 1

flightSection:addToggle(
    "Enabled",
    false,
    function(v)
        flightEnabled = v
    end
)

flightSection:addSlider(
    "Speed",
    100,
    0,
    800,
    function(v)
        flightSpeed = v / 100
    end
)

local defaultCharacterParent = nil

RunService.Stepped:Connect(function()

    local Character = LocalPlayer.Character

    if flightEnabled then

        if Character and typeof(Character) == "Instance" then

            local Humanoid =
                Character:FindFirstChildWhichIsA("Humanoid")

            if Humanoid and typeof(Humanoid) == "Instance" then

                local SeatPart = Humanoid.SeatPart

                if SeatPart
                    and typeof(SeatPart) == "Instance"
                    and SeatPart:IsA("VehicleSeat") then

                    local Vehicle =
                        GetVehicleFromDescendant(SeatPart)

                    if Vehicle and Vehicle:IsA("Model") then

                        Character.Parent = Vehicle

                        if not Vehicle.PrimaryPart then

                            if SeatPart.Parent == Vehicle then

                                Vehicle.PrimaryPart =
                                    SeatPart

                            else

                                Vehicle.PrimaryPart =
                                    Vehicle:FindFirstChildWhichIsA("BasePart")

                            end

                        end

                        if Vehicle.PrimaryPart then

                            local PrimaryPartCFrame =
                                Vehicle:GetPrimaryPartCFrame()

                            local Camera =
                                workspace.CurrentCamera

                            if Camera then

                                local moveX = 0
                                local moveY = 0
                                local moveZ = 0

                                if not UserInputService:GetFocusedTextBox() then

                                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                                        moveX = flightSpeed
                                    elseif UserInputService:IsKeyDown(Enum.KeyCode.A) then
                                        moveX = -flightSpeed
                                    end

                                    if UserInputService:IsKeyDown(Enum.KeyCode.E) then
                                        moveY = flightSpeed / 2
                                    elseif UserInputService:IsKeyDown(Enum.KeyCode.Q) then
                                        moveY = -flightSpeed / 2
                                    end

                                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                                        moveZ = flightSpeed
                                    elseif UserInputService:IsKeyDown(Enum.KeyCode.W) then
                                        moveZ = -flightSpeed
                                    end

                                end

                                local newCFrame =
                                    CFrame.new(
                                        PrimaryPartCFrame.Position,
                                        PrimaryPartCFrame.Position
                                            + Camera.CFrame.LookVector
                                    )
                                    *
                                    CFrame.new(
                                        moveX,
                                        moveY,
                                        moveZ
                                    )

                                pcall(function()
                                    Vehicle:SetPrimaryPartCFrame(
                                        newCFrame
                                    )
                                end)

                            end

                            SeatPart.AssemblyLinearVelocity =
                                Vector3.zero

                            SeatPart.AssemblyAngularVelocity =
                                Vector3.zero

                        end

                    end

                end

            end

        end

    else

        if Character and typeof(Character) == "Instance" then

            if defaultCharacterParent then
                Character.Parent =
                    defaultCharacterParent
            end

        end

    end

end)

--------------------------------------------------
-- ACCELERATION
--------------------------------------------------

local speedSection =
    vehiclePage:addSection("Acceleration")

local velocityMult = 0.025

speedSection:addSlider(
    "Multiplier (Thousandths)",
    25,
    0,
    50,
    function(v)
        velocityMult = v / 1000
    end
)

local velocityEnabledKeyCode =
    Enum.KeyCode.W

speedSection:addKeybind(
    "Velocity Enabled",
    velocityEnabledKeyCode,

    function()

        if not velocityEnabled then
            return
        end

        while UserInputService:IsKeyDown(
            velocityEnabledKeyCode
        ) do

            task.wait()

            local Character =
                LocalPlayer.Character

            if Character then

                local Humanoid =
                    Character:FindFirstChildWhichIsA(
                        "Humanoid"
                    )

                if Humanoid then

                    local SeatPart =
                        Humanoid.SeatPart

                    if SeatPart
                        and SeatPart:IsA("VehicleSeat") then

                        SeatPart.AssemblyLinearVelocity *=
                            Vector3.new(
                                1 + velocityMult,
                                1,
                                1 + velocityMult
                            )

                    end

                end

            end

            if not velocityEnabled then
                break
            end

        end

    end,

    function(v)
        velocityEnabledKeyCode =
            v.KeyCode
    end
)

--------------------------------------------------
-- DECELERATION
--------------------------------------------------

local decelerateSelection =
    vehiclePage:addSection("Deceleration")

local qbEnabledKeyCode =
    Enum.KeyCode.S

local velocityMult2 =
    150e-3

decelerateSelection:addSlider(
    "Brake Force (Thousandths)",
    velocityMult2 * 1e3,
    0,
    300,

    function(v)
        velocityMult2 =
            v / 1000
    end
)

decelerateSelection:addKeybind(
    "Quick Brake Enabled",
    qbEnabledKeyCode,

    function()

        if not velocityEnabled then
            return
        end

        while UserInputService:IsKeyDown(
            qbEnabledKeyCode
        ) do

            task.wait()

            local Character =
                LocalPlayer.Character

            if Character then

                local Humanoid =
                    Character:FindFirstChildWhichIsA(
                        "Humanoid"
                    )

                if Humanoid then

                    local SeatPart =
                        Humanoid.SeatPart

                    if SeatPart
                        and SeatPart:IsA("VehicleSeat") then

                        SeatPart.AssemblyLinearVelocity *=
                            Vector3.new(
                                1 - velocityMult2,
                                1,
                                1 - velocityMult2
                            )

                    end

                end

            end

            if not velocityEnabled then
                break
            end

        end

    end,

    function(v)
        qbEnabledKeyCode =
            v.KeyCode
    end
)

--------------------------------------------------
-- STOP VEHICLE
--------------------------------------------------

decelerateSelection:addKeybind(
    "Stop the Vehicle",
    Enum.KeyCode.P,

    function()

        if not velocityEnabled then
            return
        end

        local Character =
            LocalPlayer.Character

        if not Character then
            return
        end

        local Humanoid =
            Character:FindFirstChildWhichIsA(
                "Humanoid"
            )

        if not Humanoid then
            return
        end

        local SeatPart =
            Humanoid.SeatPart

        if SeatPart
            and SeatPart:IsA("VehicleSeat") then

            SeatPart.AssemblyLinearVelocity =
                Vector3.zero

            SeatPart.AssemblyAngularVelocity =
                Vector3.zero

        end

    end
)

--------------------------------------------------
-- SPRINGS
--------------------------------------------------

local springSection =
    vehiclePage:addSection("Springs")

springSection:addToggle(
    "Visible",
    false,

    function(v)

        local Vehicle =
            GetCurrentVehicle()

        if not Vehicle then
            return
        end

        for _, SpringConstraint in
            pairs(Vehicle:GetDescendants()) do

            if SpringConstraint:IsA(
                "SpringConstraint"
            ) then

                SpringConstraint.Visible =
                    v

            end

        end

    end
)

--------------------------------------------------
-- SAVED POSITION + ROUTE RECORDER
--------------------------------------------------

local savedPositionSection =
    vehiclePage:addSection(
        "Saved Position"
    )

local savedVehicleCFrame = nil

--------------------------------------------------
-- SAVE POSITION
--------------------------------------------------

savedPositionSection:addButton(
    "Save Vehicle Position",

    function()

        local Vehicle =
            GetCurrentVehicle()

        if not Vehicle then
            return
        end

        local success, result =
            pcall(function()
                return Vehicle:GetPivot()
            end)

        if success and result then
            savedVehicleCFrame = result
        end

    end
)

--------------------------------------------------
-- TELEPORT TO SAVED POSITION
--------------------------------------------------

savedPositionSection:addButton(
    "Teleport to Saved Position",

    function()

        if not savedVehicleCFrame then
            return
        end

        TeleportVehicle(
            savedVehicleCFrame
        )

    end
)

--------------------------------------------------
-- CLEAR SAVED POSITION
--------------------------------------------------

savedPositionSection:addButton(
    "Clear Saved Position",

    function()
        savedVehicleCFrame = nil
    end
)

--------------------------------------------------
-- ROUTE RECORDER
--------------------------------------------------

local routeSection =
    vehiclePage:addSection(
        "Route Recorder"
    )

local routeRecording = false
local routePlaying = false
local routePoints = {}

-- Interval between captured points.
-- Smaller values make the route more precise,
-- but create more points.
local routeRecordInterval = 0.10

-- Minimum distance between points.
-- Prevents thousands of nearly identical points.
local routeMinDistance = 2

local lastRouteRecordTime = 0
local lastRoutePosition = nil

local function ClearRoute()
    routePoints = {}
    lastRouteRecordTime = 0
    lastRoutePosition = nil
end

local function StartRouteRecording()

    if routePlaying then
        return
    end

    ClearRoute()
    routeRecording = true

    local Vehicle = GetCurrentVehicle()

    if Vehicle then
        local success, result = pcall(function()
            return Vehicle:GetPivot()
        end)

        if success and result then
            table.insert(routePoints, result)
            lastRoutePosition = result.Position
            lastRouteRecordTime = tick()
        end
    end
end

local function StopRouteRecording()
    routeRecording = false
end

local function ToggleRouteRecording()

    if routeRecording then
        StopRouteRecording()
    else
        StartRouteRecording()
    end

end

--------------------------------------------------
-- ROUTE RECORD LOOP
--------------------------------------------------

RunService.Heartbeat:Connect(function()

    if not routeRecording then
        return
    end

    if routePlaying then
        return
    end

    local now = tick()

    if now - lastRouteRecordTime < routeRecordInterval then
        return
    end

    local Vehicle = GetCurrentVehicle()

    if not Vehicle then
        return
    end

    local success, currentCFrame = pcall(function()
        return Vehicle:GetPivot()
    end)

    if not success or not currentCFrame then
        return
    end

    local currentPosition = currentCFrame.Position

    if not lastRoutePosition
        or (currentPosition - lastRoutePosition).Magnitude >= routeMinDistance then

        table.insert(routePoints, currentCFrame)

        lastRoutePosition = currentPosition
        lastRouteRecordTime = now

    end

end)

--------------------------------------------------
-- PLAY ROUTE
--------------------------------------------------

local function PlayRoute()

    if routeRecording then
        StopRouteRecording()
    end

    if routePlaying then
        return
    end

    if #routePoints < 2 then
        return
    end

    routePlaying = true

    task.spawn(function()

        for index, CoordinateFrame in ipairs(routePoints) do

            if not routePlaying then
                break
            end

            local Vehicle = GetCurrentVehicle()

            if not Vehicle then
                break
            end

            local currentCFrame = Vehicle:GetPivot()
            local distance =
                (currentCFrame.Position - CoordinateFrame.Position).Magnitude

            -- Move through the saved route points.
            -- The wait is based on distance so the playback
            -- does not run through the entire route instantly.
            local travelTime = math.clamp(
                distance / 80,
                0.03,
                0.35
            )

            TeleportVehicle(CoordinateFrame)
            task.wait(travelTime)

        end

        routePlaying = false

    end)

end

local function StopRoutePlayback()
    routePlaying = false
end

--------------------------------------------------
-- ROUTE BUTTONS
--------------------------------------------------

routeSection:addButton(
    "Start / Stop Recording",
    function()
        ToggleRouteRecording()
    end
)

routeSection:addButton(
    "Play Recorded Route",
    function()
        PlayRoute()
    end
)

routeSection:addButton(
    "Stop Route Playback",
    function()
        StopRoutePlayback()
    end
)

routeSection:addButton(
    "Clear Recorded Route",
    function()
        StopRoutePlayback()
        StopRouteRecording()
        ClearRoute()
    end
)

--------------------------------------------------
-- L HOTKEY - RECORD ROUTE
--------------------------------------------------

UserInputService.InputBegan:Connect(
    function(input, gameProcessedEvent)

        if gameProcessedEvent then
            return
        end

        if input.KeyCode == Enum.KeyCode.L then
            ToggleRouteRecording()
        end

    end
)

--------------------------------------------------
-- K HOTKEY - SAVED POSITION
--------------------------------------------------

UserInputService.InputBegan:Connect(
    function(input, gameProcessedEvent)

        if gameProcessedEvent then
            return
        end

        if input.KeyCode == Enum.KeyCode.K then

            if savedVehicleCFrame then
                TeleportVehicle(
                    savedVehicleCFrame
                )
            end

        end

    end
)

--------------------------------------------------
-- GAME SPECIFIC PAGES
--------------------------------------------------

repeat
    task.wait()
until game:IsLoaded()
    and game.PlaceId > 0

--------------------------------------------------
-- DRIVING EMPIRE
--------------------------------------------------

if game.PlaceId == 3351674303 then

    local drivingEmpirePage =
        Venyx:addPage(
            "Wayfort",
            8357222903
        )

    local dealershipSection =
        drivingEmpirePage:addSection(
            "Vehicle Dealership"
        )

    local dealershipList = {}

    for _, value in pairs(
        workspace
            :WaitForChild("Game")
            :WaitForChild("Dealerships")
            :WaitForChild("Dealerships")
            :GetChildren()
    ) do

        table.insert(
            dealershipList,
            value.Name
        )

    end

    dealershipSection:addDropdown(
        "Dealership",
        dealershipList,

        function(v)

            game:GetService(
                "ReplicatedStorage"
            )
            .Remotes.Location
            :FireServer(
                "Enter",
                v
            )

        end
    )

--------------------------------------------------
-- GREENVILLE
--------------------------------------------------

elseif game.PlaceId == 891852901 then

    Venyx:addPage(
        "Greenville",
        8360925727
    )

--------------------------------------------------
-- ULTIMATE DRIVING
--------------------------------------------------

elseif game.PlaceId == 54865335 then

    Venyx:addPage(
        "Westover",
        8360954483
    )

--------------------------------------------------
-- PACIFICO
--------------------------------------------------

elseif game.PlaceId == 5232896677 then

    Venyx:addPage(
        "Pacifico",
        3028235557
    )

end

--------------------------------------------------
-- INFORMATION
--------------------------------------------------

local infoPage =
    Venyx:addPage(
        "Information",
        8356778308
    )

local discordSection =
    infoPage:addSection(
        "Discord"
    )

discordSection:addButton(
    syn
        and "Join the Discord server"
        or "Copy Discord Link",

    function()

        if syn then

            syn.request({

                Url =
                    "http://127.0.0.1:6463/rpc?v=1",

                Method =
                    "POST",

                Headers = {

                    ["Content-Type"] =
                        "application/json",

                    ["Origin"] =
                        "https://discord.com"

                },

                Body =
                    game:GetService(
                        "HttpService"
                    ):JSONEncode({

                        cmd =
                            "INVITE_BROWSER",

                        args = {

                            code =
                                "ENHYznSPmM"

                        },

                        nonce =
                            game:GetService(
                                "HttpService"
                            ):GenerateGUID(false)

                    })

            })

            return

        end

        if setclipboard then

            setclipboard(
                "https://www.discord.com/invite/ENHYznSPmM"
            )

        end

    end
)

--------------------------------------------------
-- CLOSE GUI
--------------------------------------------------

local function CloseGUI()

    Venyx:toggle()

end

UserInputService.InputBegan:Connect(
    function(
        input,
        gameProcessedEvent
    )

        if not gameProcessedEvent
            and input.KeyCode ==
                Enum.KeyCode.RightBracket then

            CloseGUI()

        end

    end
)
```
