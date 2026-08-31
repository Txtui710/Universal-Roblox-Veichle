--------------------------------------------------
-- TXTUI TURBO - TECHNOLOGY UI
-- Para usar a logo enviada, publique a imagem no Roblox e troque
-- rbxassetid://0 abaixo pelo ID fornecido pelo Roblox.
--------------------------------------------------

local TXTUI_CONFIG = {
    LogoImage = "rbxassetid://0",
    DiscordLink = "https://discord.gg/ENHYznSPmM"
}

local GuiInput = game:GetService("UserInputService")
local GuiTween = game:GetService("TweenService")
local GuiCore = game:GetService("CoreGui")

local GuiPalette = {
    Background = Color3.fromRGB(7, 10, 16),
    Surface = Color3.fromRGB(13, 18, 27),
    Card = Color3.fromRGB(17, 24, 35),
    CardHover = Color3.fromRGB(22, 34, 49),
    Blue = Color3.fromRGB(39, 169, 255),
    BlueLight = Color3.fromRGB(103, 205, 255),
    BlueDark = Color3.fromRGB(9, 87, 190),
    Text = Color3.fromRGB(103, 205, 255),
    Muted = Color3.fromRGB(91, 126, 153),
    Stroke = Color3.fromRGB(32, 104, 163),
    Success = Color3.fromRGB(44, 225, 185)
}

local function GuiCreate(className, properties, children)
    local object = Instance.new(className)

    for property, value in pairs(properties or {}) do
        object[property] = value
    end

    for _, child in ipairs(children or {}) do
        child.Parent = object
    end

    return object
end

local function GuiCorner(parent, radius)
    return GuiCreate("UICorner", {
        CornerRadius = UDim.new(0, radius or 10),
        Parent = parent
    })
end

local function GuiStroke(parent, color, thickness, transparency)
    return GuiCreate("UIStroke", {
        Color = color or GuiPalette.Stroke,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        Parent = parent
    })
end

local function GuiPadding(parent, left, right, top, bottom)
    return GuiCreate("UIPadding", {
        PaddingLeft = UDim.new(0, left or 0),
        PaddingRight = UDim.new(0, right or 0),
        PaddingTop = UDim.new(0, top or 0),
        PaddingBottom = UDim.new(0, bottom or 0),
        Parent = parent
    })
end

local function GuiTweenTo(object, duration, properties)
    GuiTween:Create(
        object,
        TweenInfo.new(duration or 0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        properties
    ):Play()
end

local function GuiHover(button, normalColor, hoverColor)
    button.MouseEnter:Connect(function()
        GuiTweenTo(button, 0.16, {BackgroundColor3 = hoverColor})
    end)

    button.MouseLeave:Connect(function()
        GuiTweenTo(button, 0.16, {BackgroundColor3 = normalColor})
    end)
end

local VenyxLibrary = {}
local Window = {}
local Page = {}
local Section = {}

Window.__index = Window
Page.__index = Page
Section.__index = Section

function VenyxLibrary.new(title)
    local self = setmetatable({}, Window)
    self.Pages = {}
    self.ActivePage = nil
    self.Minimized = false

    local guiParent = GuiCore
    pcall(function()
        if type(gethui) == "function" then
            guiParent = gethui()
        end
    end)

    local previous = guiParent:FindFirstChild("TXTUI_TURBO_TECH")
    if previous then
        previous:Destroy()
    end

    self.ScreenGui = GuiCreate("ScreenGui", {
        Name = "TXTUI_TURBO_TECH",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = guiParent
    })

    pcall(function()
        if type(syn) == "table" and type(syn.protect_gui) == "function" then
            syn.protect_gui(self.ScreenGui)
        end
    end)

    self.Scale = GuiCreate("UIScale", {
        Scale = 1
    })

    self.Main = GuiCreate("Frame", {
        Name = "Main",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(860, 540),
        BackgroundColor3 = GuiPalette.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = self.ScreenGui
    }, {
        self.Scale
    })
    GuiCorner(self.Main, 16)
    GuiStroke(self.Main, GuiPalette.Blue, 1.5, 0.22)

    GuiCreate("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 20, 33)),
            ColorSequenceKeypoint.new(0.5, GuiPalette.Background),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 8, 13))
        }),
        Rotation = 125,
        Parent = self.Main
    })

    self.Header = GuiCreate("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 64),
        BackgroundColor3 = GuiPalette.Surface,
        BorderSizePixel = 0,
        Parent = self.Main
    })

    GuiCreate("Frame", {
        Name = "AccentLine",
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = GuiPalette.Blue,
        BackgroundTransparency = 0.48,
        BorderSizePixel = 0,
        Parent = self.Header
    })

    local logoBadge = GuiCreate("Frame", {
        Name = "LogoBadge",
        Position = UDim2.fromOffset(14, 10),
        Size = UDim2.fromOffset(44, 44),
        BackgroundColor3 = Color3.fromRGB(8, 25, 43),
        BorderSizePixel = 0,
        Parent = self.Header
    })
    GuiCorner(logoBadge, 12)
    GuiStroke(logoBadge, GuiPalette.Blue, 1.2, 0.15)

    local logoImage = GuiCreate("ImageLabel", {
        Name = "LogoImage",
        Position = UDim2.fromOffset(4, 4),
        Size = UDim2.new(1, -8, 1, -8),
        BackgroundTransparency = 1,
        Image = TXTUI_CONFIG.LogoImage,
        ScaleType = Enum.ScaleType.Fit,
        Visible = TXTUI_CONFIG.LogoImage ~= "rbxassetid://0"
            and TXTUI_CONFIG.LogoImage ~= "",
        Parent = logoBadge
    })

    GuiCreate("TextLabel", {
        Name = "LogoFallback",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = "TXT",
        TextColor3 = GuiPalette.BlueLight,
        TextSize = 13,
        Font = Enum.Font.GothamBlack,
        Visible = not logoImage.Visible,
        Parent = logoBadge
    })

    GuiCreate("TextLabel", {
        Name = "Title",
        Position = UDim2.fromOffset(70, 10),
        Size = UDim2.new(0, 300, 0, 24),
        BackgroundTransparency = 1,
        Text = title or "TXTUI TURBO",
        TextColor3 = GuiPalette.BlueLight,
        TextSize = 19,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Header
    })

    GuiCreate("TextLabel", {
        Position = UDim2.fromOffset(70, 33),
        Size = UDim2.new(0, 360, 0, 18),
        BackgroundTransparency = 1,
        Text = "UNIVERSAL VEHICLE SYSTEM  •  TECH EDITION",
        TextColor3 = GuiPalette.Muted,
        TextSize = 10,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Header
    })

    local status = GuiCreate("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -104, 0.5, 0),
        Size = UDim2.fromOffset(92, 28),
        BackgroundColor3 = Color3.fromRGB(10, 36, 42),
        BorderSizePixel = 0,
        Parent = self.Header
    })
    GuiCorner(status, 14)
    GuiStroke(status, GuiPalette.Success, 1, 0.55)

    GuiCreate("Frame", {
        Position = UDim2.fromOffset(11, 10),
        Size = UDim2.fromOffset(8, 8),
        BackgroundColor3 = GuiPalette.Success,
        BorderSizePixel = 0,
        Parent = status
    })
    GuiCorner(status:FindFirstChildOfClass("Frame"), 8)

    GuiCreate("TextLabel", {
        Position = UDim2.fromOffset(25, 0),
        Size = UDim2.new(1, -28, 1, 0),
        BackgroundTransparency = 1,
        Text = "ONLINE",
        TextColor3 = GuiPalette.Success,
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = status
    })

    local minimizeButton = GuiCreate("TextButton", {
        Name = "Minimize",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -55, 0.5, 0),
        Size = UDim2.fromOffset(34, 34),
        BackgroundColor3 = GuiPalette.Card,
        BorderSizePixel = 0,
        Text = "—",
        TextColor3 = GuiPalette.BlueLight,
        TextSize = 17,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        Parent = self.Header
    })
    GuiCorner(minimizeButton, 10)
    GuiStroke(minimizeButton, GuiPalette.Stroke, 1, 0.45)
    GuiHover(minimizeButton, GuiPalette.Card, GuiPalette.CardHover)

    local closeButton = GuiCreate("TextButton", {
        Name = "Close",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -13, 0.5, 0),
        Size = UDim2.fromOffset(34, 34),
        BackgroundColor3 = GuiPalette.Card,
        BorderSizePixel = 0,
        Text = "×",
        TextColor3 = GuiPalette.BlueLight,
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        Parent = self.Header
    })
    GuiCorner(closeButton, 10)
    GuiStroke(closeButton, GuiPalette.Stroke, 1, 0.45)
    GuiHover(closeButton, GuiPalette.Card, Color3.fromRGB(53, 27, 39))

    self.Navigation = GuiCreate("Frame", {
        Name = "Navigation",
        Position = UDim2.fromOffset(0, 64),
        Size = UDim2.new(1, 0, 0, 58),
        BackgroundColor3 = Color3.fromRGB(9, 14, 22),
        BorderSizePixel = 0,
        Parent = self.Main
    })

    self.Tabs = GuiCreate("ScrollingFrame", {
        Name = "Tabs",
        Position = UDim2.fromOffset(14, 10),
        Size = UDim2.new(1, -272, 0, 38),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = GuiPalette.Blue,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.X,
        ScrollingDirection = Enum.ScrollingDirection.X,
        Parent = self.Navigation
    })
    GuiCreate("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.Tabs
    })

    local searchShell = GuiCreate("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -14, 0, 10),
        Size = UDim2.fromOffset(236, 38),
        BackgroundColor3 = GuiPalette.Surface,
        BorderSizePixel = 0,
        Parent = self.Navigation
    })
    GuiCorner(searchShell, 10)
    GuiStroke(searchShell, GuiPalette.Stroke, 1, 0.55)

    GuiCreate("TextLabel", {
        Position = UDim2.fromOffset(11, 0),
        Size = UDim2.fromOffset(22, 38),
        BackgroundTransparency = 1,
        Text = "⌕",
        TextColor3 = GuiPalette.Blue,
        TextSize = 19,
        Font = Enum.Font.GothamBold,
        Parent = searchShell
    })

    self.Search = GuiCreate("TextBox", {
        Position = UDim2.fromOffset(36, 0),
        Size = UDim2.new(1, -44, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        PlaceholderText = "Buscar função...",
        PlaceholderColor3 = GuiPalette.Muted,
        TextColor3 = GuiPalette.BlueLight,
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        ClearTextOnFocus = false,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = searchShell
    })

    self.Content = GuiCreate("Frame", {
        Name = "Content",
        Position = UDim2.fromOffset(14, 136),
        Size = UDim2.new(1, -28, 1, -150),
        BackgroundTransparency = 1,
        Parent = self.Main
    })

    self.ToastHolder = GuiCreate("Frame", {
        Name = "Toasts",
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -20, 1, -18),
        Size = UDim2.fromOffset(310, 160),
        BackgroundTransparency = 1,
        Parent = self.Main
    })
    GuiCreate("UIListLayout", {
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0, 8),
        Parent = self.ToastHolder
    })

    local dragging = false
    local dragStart
    local startPosition

    self.Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = self.Main.Position
        end
    end)

    GuiInput.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            self.Main.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)

    GuiInput.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    local function updateScale()
        local camera = workspace.CurrentCamera
        if not camera then
            return
        end

        local viewport = camera.ViewportSize
        self.Scale.Scale = math.clamp(
            math.min(viewport.X / 940, viewport.Y / 620),
            0.67,
            1
        )
    end

    updateScale()
    if workspace.CurrentCamera then
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
    end

    minimizeButton.MouseButton1Click:Connect(function()
        self.Minimized = not self.Minimized
        self.Navigation.Visible = not self.Minimized
        self.Content.Visible = not self.Minimized
        self.ToastHolder.Visible = not self.Minimized

        GuiTweenTo(self.Main, 0.22, {
            Size = self.Minimized
                and UDim2.fromOffset(860, 64)
                or UDim2.fromOffset(860, 540)
        })
    end)

    closeButton.MouseButton1Click:Connect(function()
        self:toggle()
    end)

    self.Search:GetPropertyChangedSignal("Text"):Connect(function()
        self:_applySearch(self.Search.Text)
    end)

    return self
end

function Window:setTheme()
    -- Mantido somente para compatibilidade com a versão antiga.
end

function Window:toggle()
    self.ScreenGui.Enabled = not self.ScreenGui.Enabled
end

function Window:notify(message)
    local toast = GuiCreate("Frame", {
        Size = UDim2.fromOffset(300, 46),
        BackgroundColor3 = GuiPalette.Card,
        BackgroundTransparency = 0.03,
        BorderSizePixel = 0,
        Parent = self.ToastHolder
    })
    GuiCorner(toast, 11)
    GuiStroke(toast, GuiPalette.Blue, 1, 0.25)

    GuiCreate("Frame", {
        Size = UDim2.fromOffset(4, 46),
        BackgroundColor3 = GuiPalette.Blue,
        BorderSizePixel = 0,
        Parent = toast
    })

    GuiCreate("TextLabel", {
        Position = UDim2.fromOffset(16, 0),
        Size = UDim2.new(1, -24, 1, 0),
        BackgroundTransparency = 1,
        Text = tostring(message),
        TextColor3 = GuiPalette.BlueLight,
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = toast
    })

    toast.BackgroundTransparency = 1
    GuiTweenTo(toast, 0.18, {BackgroundTransparency = 0.03})

    task.delay(2.6, function()
        if toast.Parent then
            GuiTweenTo(toast, 0.2, {BackgroundTransparency = 1})
            task.wait(0.22)
            toast:Destroy()
        end
    end)
end

function Window:_selectPage(selectedPage)
    self.ActivePage = selectedPage

    for _, page in ipairs(self.Pages) do
        local active = page == selectedPage
        page.Frame.Visible = active
        page.Tab.TextColor3 = active and GuiPalette.BlueLight or GuiPalette.Muted
        page.Tab.BackgroundColor3 = active
            and Color3.fromRGB(13, 48, 77)
            or GuiPalette.Surface
        page.TabStroke.Color = active and GuiPalette.Blue or GuiPalette.Stroke
        page.TabStroke.Transparency = active and 0.12 or 0.62
    end

    self:_applySearch(self.Search.Text)
end

function Window:_applySearch(query)
    local page = self.ActivePage
    if not page then
        return
    end

    query = string.lower(tostring(query or ""))

    for _, section in ipairs(page.Sections) do
        local titleMatch = query == ""
            or string.find(string.lower(section.Name), query, 1, true) ~= nil
        local visibleControls = 0

        for _, control in ipairs(section.Controls) do
            local visible = query == ""
                or titleMatch
                or string.find(control.SearchName, query, 1, true) ~= nil
            control.Object.Visible = visible
            if visible then
                visibleControls += 1
            end
        end

        section.Frame.Visible = titleMatch or visibleControls > 0
    end
end

function Window:addPage(name)
    local page = setmetatable({}, Page)
    page.Window = self
    page.Name = tostring(name)
    page.Sections = {}

    page.Tab = GuiCreate("TextButton", {
        Name = page.Name,
        Size = UDim2.fromOffset(132, 36),
        BackgroundColor3 = GuiPalette.Surface,
        BorderSizePixel = 0,
        Text = string.upper(page.Name),
        TextColor3 = GuiPalette.Muted,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        Parent = self.Tabs
    })
    GuiCorner(page.Tab, 10)
    page.TabStroke = GuiStroke(page.Tab, GuiPalette.Stroke, 1, 0.62)

    page.Tab.MouseEnter:Connect(function()
        if self.ActivePage ~= page then
            GuiTweenTo(page.Tab, 0.16, {BackgroundColor3 = GuiPalette.CardHover})
        end
    end)

    page.Tab.MouseLeave:Connect(function()
        if self.ActivePage ~= page then
            GuiTweenTo(page.Tab, 0.16, {BackgroundColor3 = GuiPalette.Surface})
        end
    end)

    page.Frame = GuiCreate("ScrollingFrame", {
        Name = page.Name .. "Page",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = GuiPalette.Blue,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        Parent = self.Content
    })
    GuiPadding(page.Frame, 2, 8, 2, 12)
    GuiCreate("UIListLayout", {
        Padding = UDim.new(0, 12),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = page.Frame
    })

    table.insert(self.Pages, page)

    page.Tab.MouseButton1Click:Connect(function()
        self:_selectPage(page)
    end)

    if not self.ActivePage then
        self:_selectPage(page)
    end

    return page
end

function Page:addSection(name)
    local section = setmetatable({}, Section)
    section.Page = self
    section.Name = tostring(name)
    section.Controls = {}

    section.Frame = GuiCreate("Frame", {
        Name = section.Name,
        Size = UDim2.new(1, -4, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = GuiPalette.Surface,
        BorderSizePixel = 0,
        Parent = self.Frame
    })
    GuiCorner(section.Frame, 13)
    GuiStroke(section.Frame, GuiPalette.Stroke, 1, 0.56)
    GuiPadding(section.Frame, 13, 13, 12, 13)
    GuiCreate("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = section.Frame
    })

    GuiCreate("TextLabel", {
        Name = "SectionTitle",
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundTransparency = 1,
        Text = string.upper(section.Name),
        TextColor3 = GuiPalette.Blue,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = section.Frame
    })

    table.insert(self.Sections, section)
    return section
end

function Section:_newControl(name, height, className)
    local control = GuiCreate(className or "Frame", {
        Name = tostring(name),
        Size = UDim2.new(1, 0, 0, height or 48),
        BackgroundColor3 = GuiPalette.Card,
        BorderSizePixel = 0,
        Parent = self.Frame
    })
    GuiCorner(control, 10)
    GuiStroke(control, GuiPalette.Stroke, 1, 0.72)

    table.insert(self.Controls, {
        Object = control,
        SearchName = string.lower(tostring(name))
    })

    return control
end

function Section:addButton(name, callback)
    local button = self:_newControl(name, 48, "TextButton")
    button.AutoButtonColor = false
    button.Text = ""
    GuiHover(button, GuiPalette.Card, GuiPalette.CardHover)

    GuiCreate("TextLabel", {
        Position = UDim2.fromOffset(14, 0),
        Size = UDim2.new(1, -58, 1, 0),
        BackgroundTransparency = 1,
        Text = tostring(name),
        TextColor3 = GuiPalette.Text,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = button
    })

    local action = GuiCreate("TextLabel", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -12, 0.5, 0),
        Size = UDim2.fromOffset(28, 28),
        BackgroundColor3 = Color3.fromRGB(11, 55, 92),
        BorderSizePixel = 0,
        Text = "›",
        TextColor3 = GuiPalette.BlueLight,
        TextSize = 21,
        Font = Enum.Font.GothamBold,
        Parent = button
    })
    GuiCorner(action, 8)

    button.MouseButton1Click:Connect(function()
        GuiTweenTo(action, 0.1, {BackgroundColor3 = GuiPalette.BlueDark})
        task.delay(0.12, function()
            if action.Parent then
                GuiTweenTo(action, 0.12, {BackgroundColor3 = Color3.fromRGB(11, 55, 92)})
            end
        end)

        if callback then
            task.spawn(function()
                local ok, message = pcall(callback)
                if not ok then
                    warn("TXTUI TURBO: " .. tostring(message))
                end
            end)
        end
    end)

    return button
end

function Section:addToggle(name, default, callback)
    local state = default == true
    local button = self:_newControl(name, 48, "TextButton")
    button.AutoButtonColor = false
    button.Text = ""
    GuiHover(button, GuiPalette.Card, GuiPalette.CardHover)

    GuiCreate("TextLabel", {
        Position = UDim2.fromOffset(14, 0),
        Size = UDim2.new(1, -78, 1, 0),
        BackgroundTransparency = 1,
        Text = tostring(name),
        TextColor3 = GuiPalette.Text,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = button
    })

    local switch = GuiCreate("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -13, 0.5, 0),
        Size = UDim2.fromOffset(48, 24),
        BackgroundColor3 = state and GuiPalette.BlueDark or Color3.fromRGB(34, 44, 56),
        BorderSizePixel = 0,
        Parent = button
    })
    GuiCorner(switch, 12)
    GuiStroke(switch, state and GuiPalette.Blue or GuiPalette.Stroke, 1, 0.35)

    local knob = GuiCreate("Frame", {
        Position = state and UDim2.fromOffset(27, 3) or UDim2.fromOffset(3, 3),
        Size = UDim2.fromOffset(18, 18),
        BackgroundColor3 = state and GuiPalette.BlueLight or GuiPalette.Muted,
        BorderSizePixel = 0,
        Parent = switch
    })
    GuiCorner(knob, 9)

    local function render()
        GuiTweenTo(switch, 0.18, {
            BackgroundColor3 = state and GuiPalette.BlueDark or Color3.fromRGB(34, 44, 56)
        })
        GuiTweenTo(knob, 0.18, {
            Position = state and UDim2.fromOffset(27, 3) or UDim2.fromOffset(3, 3),
            BackgroundColor3 = state and GuiPalette.BlueLight or GuiPalette.Muted
        })
    end

    button.MouseButton1Click:Connect(function()
        state = not state
        render()
        if callback then
            local ok, message = pcall(callback, state)
            if not ok then
                warn("TXTUI TURBO: " .. tostring(message))
            end
        end
    end)

    return button
end

function Section:addSlider(name, default, minimum, maximum, callback)
    minimum = tonumber(minimum) or 0
    maximum = tonumber(maximum) or 100
    local value = math.clamp(tonumber(default) or minimum, minimum, maximum)
    local row = self:_newControl(name, 62, "Frame")

    GuiCreate("TextLabel", {
        Position = UDim2.fromOffset(14, 5),
        Size = UDim2.new(1, -100, 0, 30),
        BackgroundTransparency = 1,
        Text = tostring(name),
        TextColor3 = GuiPalette.Text,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row
    })

    local valueLabel = GuiCreate("TextLabel", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -13, 0, 8),
        Size = UDim2.fromOffset(72, 25),
        BackgroundColor3 = Color3.fromRGB(9, 41, 68),
        BorderSizePixel = 0,
        Text = tostring(math.floor(value + 0.5)),
        TextColor3 = GuiPalette.BlueLight,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        Parent = row
    })
    GuiCorner(valueLabel, 7)

    local track = GuiCreate("Frame", {
        Position = UDim2.new(0, 14, 1, -17),
        Size = UDim2.new(1, -28, 0, 5),
        BackgroundColor3 = Color3.fromRGB(30, 47, 64),
        BorderSizePixel = 0,
        Parent = row
    })
    GuiCorner(track, 3)

    local fill = GuiCreate("Frame", {
        Size = UDim2.new((value - minimum) / math.max(maximum - minimum, 1), 0, 1, 0),
        BackgroundColor3 = GuiPalette.Blue,
        BorderSizePixel = 0,
        Parent = track
    })
    GuiCorner(fill, 3)
    GuiCreate("UIGradient", {
        Color = ColorSequence.new(GuiPalette.BlueDark, GuiPalette.BlueLight),
        Parent = fill
    })

    local knob = GuiCreate("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new((value - minimum) / math.max(maximum - minimum, 1), 0, 0.5, 0),
        Size = UDim2.fromOffset(14, 14),
        BackgroundColor3 = GuiPalette.BlueLight,
        BorderSizePixel = 0,
        Parent = track
    })
    GuiCorner(knob, 7)
    GuiStroke(knob, Color3.fromRGB(211, 245, 255), 1, 0.18)

    local hitbox = GuiCreate("TextButton", {
        Position = UDim2.new(0, -4, 0, -10),
        Size = UDim2.new(1, 8, 1, 20),
        BackgroundTransparency = 1,
        Text = "",
        Parent = track
    })

    local sliding = false
    local function setFromX(x)
        local alpha = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        value = math.floor((minimum + (maximum - minimum) * alpha) + 0.5)
        local visualAlpha = (value - minimum) / math.max(maximum - minimum, 1)
        fill.Size = UDim2.new(visualAlpha, 0, 1, 0)
        knob.Position = UDim2.new(visualAlpha, 0, 0.5, 0)
        valueLabel.Text = tostring(value)
        if callback then
            local ok, message = pcall(callback, value)
            if not ok then
                warn("TXTUI TURBO: " .. tostring(message))
            end
        end
    end

    hitbox.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true
            setFromX(input.Position.X)
        end
    end)

    GuiInput.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            setFromX(input.Position.X)
        end
    end)

    GuiInput.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)

    return row
end

function Section:addKeybind(name, defaultKey, callback, changedCallback)
    local keyCode = defaultKey or Enum.KeyCode.Unknown
    local capturing = false
    local row = self:_newControl(name, 48, "TextButton")
    row.AutoButtonColor = false
    row.Text = ""
    GuiHover(row, GuiPalette.Card, GuiPalette.CardHover)

    GuiCreate("TextLabel", {
        Position = UDim2.fromOffset(14, 0),
        Size = UDim2.new(1, -132, 1, 0),
        BackgroundTransparency = 1,
        Text = tostring(name),
        TextColor3 = GuiPalette.Text,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row
    })

    local keyLabel = GuiCreate("TextLabel", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -13, 0.5, 0),
        Size = UDim2.fromOffset(104, 28),
        BackgroundColor3 = Color3.fromRGB(9, 41, 68),
        BorderSizePixel = 0,
        Text = keyCode.Name,
        TextColor3 = GuiPalette.BlueLight,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        Parent = row
    })
    GuiCorner(keyLabel, 8)
    GuiStroke(keyLabel, GuiPalette.Stroke, 1, 0.55)

    row.MouseButton1Click:Connect(function()
        capturing = true
        keyLabel.Text = "PRESSIONE..."
        keyLabel.TextColor3 = GuiPalette.Success
    end)

    GuiInput.InputBegan:Connect(function(input, processed)
        if capturing then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                capturing = false
                keyCode = input.KeyCode
                keyLabel.Text = keyCode.Name
                keyLabel.TextColor3 = GuiPalette.BlueLight
                if changedCallback then
                    local ok, message = pcall(changedCallback, input)
                    if not ok then
                        warn("TXTUI TURBO: " .. tostring(message))
                    end
                end
            end
            return
        end

        if not processed and input.KeyCode == keyCode and callback then
            task.spawn(function()
                local ok, message = pcall(callback)
                if not ok then
                    warn("TXTUI TURBO: " .. tostring(message))
                end
            end)
        end
    end)

    return row
end

function Section:addDropdown(name, options, callback)
    options = options or {}
    local opened = false
    local selected = "Selecionar"
    local row = self:_newControl(name, 52, "Frame")
    row.ClipsDescendants = true

    GuiCreate("TextLabel", {
        Position = UDim2.fromOffset(14, 0),
        Size = UDim2.new(0.45, -14, 0, 52),
        BackgroundTransparency = 1,
        Text = tostring(name),
        TextColor3 = GuiPalette.Text,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row
    })

    local selector = GuiCreate("TextButton", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -12, 0, 10),
        Size = UDim2.new(0.52, 0, 0, 32),
        BackgroundColor3 = Color3.fromRGB(9, 41, 68),
        BorderSizePixel = 0,
        Text = selected .. "  ▾",
        TextColor3 = GuiPalette.BlueLight,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        Parent = row
    })
    GuiCorner(selector, 8)
    GuiStroke(selector, GuiPalette.Stroke, 1, 0.52)

    local optionsHeight = math.min(#options * 34, 170)
    local holder = GuiCreate("ScrollingFrame", {
        Position = UDim2.fromOffset(12, 52),
        Size = UDim2.new(1, -24, 0, optionsHeight),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = GuiPalette.Blue,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = row
    })
    GuiCreate("UIListLayout", {
        Padding = UDim.new(0, 4),
        Parent = holder
    })

    local function closeDropdown()
        opened = false
        selector.Text = selected .. "  ▾"
        GuiTweenTo(row, 0.18, {Size = UDim2.new(1, 0, 0, 52)})
    end

    for _, option in ipairs(options) do
        local optionValue = option
        local optionButton = GuiCreate("TextButton", {
            Size = UDim2.new(1, -4, 0, 30),
            BackgroundColor3 = Color3.fromRGB(19, 33, 48),
            BorderSizePixel = 0,
            Text = tostring(optionValue),
            TextColor3 = GuiPalette.Text,
            TextSize = 11,
            Font = Enum.Font.GothamMedium,
            AutoButtonColor = false,
            Parent = holder
        })
        GuiCorner(optionButton, 7)
        GuiHover(optionButton, Color3.fromRGB(19, 33, 48), GuiPalette.CardHover)

        optionButton.MouseButton1Click:Connect(function()
            selected = tostring(optionValue)
            closeDropdown()
            if callback then
                local ok, message = pcall(callback, optionValue)
                if not ok then
                    warn("TXTUI TURBO: " .. tostring(message))
                end
            end
        end)
    end

    selector.MouseButton1Click:Connect(function()
        opened = not opened
        selector.Text = selected .. (opened and "  ▴" or "  ▾")
        GuiTweenTo(row, 0.18, {
            Size = opened
                and UDim2.new(1, 0, 0, 58 + optionsHeight)
                or UDim2.new(1, 0, 0, 52)
        })
    end)

    return row
end

local Venyx = VenyxLibrary.new("TXTUI TURBO")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

--------------------------------------------------
-- THEME
--------------------------------------------------

local Theme = {
    Background = Color3.fromRGB(18, 18, 18),
    Glow = Color3.fromRGB(255, 255, 255),
    Accent = Color3.fromRGB(42, 42, 42),
    LightContrast = Color3.fromRGB(70, 70, 70),
    DarkContrast = Color3.fromRGB(10, 10, 10),
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
-- SAVED POSITIONS
--------------------------------------------------

local savedPositionPage =
    Venyx:addPage(
        "Salvar posição",
        6031068421
    )

local savedPositionSection =
    savedPositionPage:addSection(
        "Posições salvas"
    )

--------------------------------------------------
-- TWO INDEPENDENT SAVED POINTS
--------------------------------------------------

local savedVehicleCFrameK = nil
local savedVehicleCFrameU = nil

--------------------------------------------------
-- SAVE POINT K
--------------------------------------------------

savedPositionSection:addButton(
    "Salvar ponto K",

    function()

        local Vehicle =
            GetCurrentVehicle()

        if not Vehicle then
            Venyx:notify("Entre em um veículo para salvar o ponto K.")
            return
        end

        local success, result =
            pcall(function()

                return Vehicle:GetPivot()

            end)

        if success and result then

            savedVehicleCFrameK =
                result

            Venyx:notify("Ponto K salvo com sucesso.")

        end

    end
)

--------------------------------------------------
-- TELEPORT TO POINT K
--------------------------------------------------

savedPositionSection:addButton(
    "Teleportar para o ponto K",

    function()

        if not savedVehicleCFrameK then
            Venyx:notify("O ponto K ainda não foi salvo.")
            return
        end

        TeleportVehicle(
            savedVehicleCFrameK
        )

    end
)

--------------------------------------------------
-- CLEAR POINT K
--------------------------------------------------

savedPositionSection:addButton(
    "Limpar ponto K",

    function()

        savedVehicleCFrameK =
            nil

        Venyx:notify("Ponto K removido.")

    end
)

--------------------------------------------------
-- SAVE POINT U
--------------------------------------------------

savedPositionSection:addButton(
    "Salvar ponto U",

    function()

        local Vehicle =
            GetCurrentVehicle()

        if not Vehicle then
            Venyx:notify("Entre em um veículo para salvar o ponto U.")
            return
        end

        local success, result =
            pcall(function()

                return Vehicle:GetPivot()

            end)

        if success and result then

            savedVehicleCFrameU =
                result

            Venyx:notify("Ponto U salvo com sucesso.")

        end

    end
)

--------------------------------------------------
-- TELEPORT TO POINT U
--------------------------------------------------

savedPositionSection:addButton(
    "Teleportar para o ponto U",

    function()

        if not savedVehicleCFrameU then
            Venyx:notify("O ponto U ainda não foi salvo.")
            return
        end

        TeleportVehicle(
            savedVehicleCFrameU
        )

    end
)

--------------------------------------------------
-- CLEAR POINT U
--------------------------------------------------

savedPositionSection:addButton(
    "Limpar ponto U",

    function()

        savedVehicleCFrameU =
            nil

        Venyx:notify("Ponto U removido.")

    end
)

--------------------------------------------------
-- K HOTKEY
--------------------------------------------------

UserInputService.InputBegan:Connect(
    function(input, gameProcessedEvent)

        if gameProcessedEvent then
            return
        end

        if input.KeyCode == Enum.KeyCode.K then

            if savedVehicleCFrameK then

                TeleportVehicle(
                    savedVehicleCFrameK
                )

            end

        end

    end
)

--------------------------------------------------
-- U HOTKEY
--------------------------------------------------

UserInputService.InputBegan:Connect(
    function(input, gameProcessedEvent)

        if gameProcessedEvent then
            return
        end

        if input.KeyCode == Enum.KeyCode.U then

            if savedVehicleCFrameU then

                TeleportVehicle(
                    savedVehicleCFrameU
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

local discordInviteCode =
    TXTUI_CONFIG.DiscordLink:match("discord%.gg/([^/?]+)")
    or TXTUI_CONFIG.DiscordLink:match("discord%.com/invite/([^/?]+)")

local canOpenDiscord =
    type(syn) == "table"
    and type(syn.request) == "function"

discordSection:addButton(
    canOpenDiscord
        and "Abrir servidor do Discord"
        or "Copiar link do Discord",

    function()

        if canOpenDiscord and discordInviteCode then

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
                                discordInviteCode

                        },

                        nonce =
                            game:GetService(
                                "HttpService"
                            ):GenerateGUID(false)

                    })

            })

            Venyx:notify("Convite do Discord aberto.")

            return

        end

        if setclipboard then

            setclipboard(
                TXTUI_CONFIG.DiscordLink
            )

            Venyx:notify("Link do Discord copiado.")

            return

        end

        Venyx:notify(TXTUI_CONFIG.DiscordLink)

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
