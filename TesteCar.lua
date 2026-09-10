--------------------------------------------------
-- TXTUI TURBO - GUI VERTICAL / WHITE + BLACK
-- Rebuild visual: compact, vertical, white background,
-- black controls and white text.
--------------------------------------------------

local TXTUI_CONFIG = {
    LogoImage = "rbxassetid://0",
    DiscordLink = "https://discord.gg/ENHYznSPmM"
}

local GuiInput = game:GetService("UserInputService")
local GuiTween = game:GetService("TweenService")
local GuiCore = game:GetService("CoreGui")

local GuiPalette = {
    Background = Color3.fromRGB(255, 255, 255),
    Surface = Color3.fromRGB(245, 245, 245),
    Card = Color3.fromRGB(0, 0, 0),
    CardHover = Color3.fromRGB(35, 35, 35),
    Text = Color3.fromRGB(255, 255, 255),
    Muted = Color3.fromRGB(70, 70, 70),
    Stroke = Color3.fromRGB(0, 0, 0),
    Success = Color3.fromRGB(255, 255, 255)
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
        CornerRadius = UDim.new(0, radius or 8),
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
        TweenInfo.new(duration or 0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        properties
    ):Play()
end

local function GuiHover(button, normalColor, hoverColor)
    button.MouseEnter:Connect(function()
        GuiTweenTo(button, 0.12, {BackgroundColor3 = hoverColor})
    end)

    button.MouseLeave:Connect(function()
        GuiTweenTo(button, 0.12, {BackgroundColor3 = normalColor})
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

    -- Compact vertical window
    self.Main = GuiCreate("Frame", {
        Name = "Main",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(330, 540),
        BackgroundColor3 = GuiPalette.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = self.ScreenGui
    }, {
        self.Scale
    })

    GuiCorner(self.Main, 12)
    GuiStroke(self.Main, Color3.fromRGB(0, 0, 0), 1.5, 0.15)

    -- Header
    self.Header = GuiCreate("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 52),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Parent = self.Main
    })

    GuiCreate("TextLabel", {
        Name = "Title",
        Position = UDim2.fromOffset(14, 6),
        Size = UDim2.new(1, -95, 0, 24),
        BackgroundTransparency = 1,
        Text = title or "TXTUI TURBO",
        TextColor3 = GuiPalette.Text,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Header
    })

    GuiCreate("TextLabel", {
        Position = UDim2.fromOffset(14, 29),
        Size = UDim2.new(1, -100, 0, 14),
        BackgroundTransparency = 1,
        Text = "VEHICLE SYSTEM",
        TextColor3 = Color3.fromRGB(210, 210, 210),
        TextSize = 8,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Header
    })

    local minimizeButton = GuiCreate("TextButton", {
        Name = "Minimize",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -43, 0.5, 0),
        Size = UDim2.fromOffset(30, 30),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Text = "—",
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        Parent = self.Header
    })
    GuiCorner(minimizeButton, 7)

    local closeButton = GuiCreate("TextButton", {
        Name = "Close",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -8, 0.5, 0),
        Size = UDim2.fromOffset(30, 30),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Text = "×",
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextSize = 19,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        Parent = self.Header
    })
    GuiCorner(closeButton, 7)

    GuiHover(minimizeButton, Color3.fromRGB(255,255,255), Color3.fromRGB(220,220,220))
    GuiHover(closeButton, Color3.fromRGB(255,255,255), Color3.fromRGB(220,220,220))

    -- Vertical navigation
    self.Navigation = GuiCreate("Frame", {
        Name = "Navigation",
        Position = UDim2.fromOffset(0, 52),
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Parent = self.Main
    })

    self.Tabs = GuiCreate("ScrollingFrame", {
        Name = "Tabs",
        Position = UDim2.fromOffset(8, 6),
        Size = UDim2.new(1, -16, 0, 30),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.X,
        ScrollingDirection = Enum.ScrollingDirection.X,
        Parent = self.Navigation
    })

    GuiCreate("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.Tabs
    })

    self.Content = GuiCreate("Frame", {
        Name = "Content",
        Position = UDim2.fromOffset(8, 101),
        Size = UDim2.new(1, -16, 1, -109),
        BackgroundTransparency = 1,
        Parent = self.Main
    })

    self.ToastHolder = GuiCreate("Frame", {
        Name = "Toasts",
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -8, 1, -8),
        Size = UDim2.fromOffset(285, 130),
        BackgroundTransparency = 1,
        Parent = self.Main
    })

    GuiCreate("UIListLayout", {
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0, 5),
        Parent = self.ToastHolder
    })

    -- Dragging
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
            math.min(viewport.X / 370, viewport.Y / 580),
            0.70,
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

        GuiTweenTo(self.Main, 0.18, {
            Size = self.Minimized
                and UDim2.fromOffset(330, 52)
                or UDim2.fromOffset(330, 540)
        })
    end)

    closeButton.MouseButton1Click:Connect(function()
        self:toggle()
    end)

    return self
end

function Window:setTheme()
    -- Mantido para compatibilidade.
end

function Window:toggle()
    self.ScreenGui.Enabled = not self.ScreenGui.Enabled
end

function Window:notify(message)
    local toast = GuiCreate("Frame", {
        Size = UDim2.fromOffset(275, 42),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Parent = self.ToastHolder
    })

    GuiCorner(toast, 8)

    GuiCreate("TextLabel", {
        Position = UDim2.fromOffset(12, 0),
        Size = UDim2.new(1, -18, 1, 0),
        BackgroundTransparency = 1,
        Text = tostring(message),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 11,
        Font = Enum.Font.GothamMedium,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = toast
    })

    toast.BackgroundTransparency = 1
    GuiTweenTo(toast, 0.15, {BackgroundTransparency = 0})

    task.delay(2.5, function()
        if toast.Parent then
            GuiTweenTo(toast, 0.18, {BackgroundTransparency = 1})
            task.wait(0.2)
            toast:Destroy()
        end
    end)
end

function Window:_selectPage(selectedPage)
    self.ActivePage = selectedPage

    for _, page in ipairs(self.Pages) do
        local active = page == selectedPage
        page.Frame.Visible = active
        page.Tab.BackgroundColor3 = active
            and Color3.fromRGB(0, 0, 0)
            or Color3.fromRGB(245, 245, 245)
        page.Tab.TextColor3 = active
            and Color3.fromRGB(255, 255, 255)
            or Color3.fromRGB(0, 0, 0)
        page.TabStroke.Color = Color3.fromRGB(0, 0, 0)
        page.TabStroke.Transparency = active and 0 or 0.75
    end

    self:_applySearch("")
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
        Size = UDim2.fromOffset(98, 30),
        BackgroundColor3 = Color3.fromRGB(245, 245, 245),
        BorderSizePixel = 0,
        Text = string.upper(page.Name),
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextSize = 9,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        Parent = self.Tabs
    })

    GuiCorner(page.Tab, 7)
    page.TabStroke = GuiStroke(page.Tab, Color3.fromRGB(0, 0, 0), 1, 0.75)

    page.Tab.MouseEnter:Connect(function()
        if self.ActivePage ~= page then
            GuiTweenTo(page.Tab, 0.1, {
                BackgroundColor3 = Color3.fromRGB(225, 225, 225)
            })
        end
    end)

    page.Tab.MouseLeave:Connect(function()
        if self.ActivePage ~= page then
            GuiTweenTo(page.Tab, 0.1, {
                BackgroundColor3 = Color3.fromRGB(245, 245, 245)
            })
        end
    end)

    page.Frame = GuiCreate("ScrollingFrame", {
        Name = page.Name .. "Page",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        Parent = self.Content
    })

    GuiPadding(page.Frame, 2, 4, 2, 8)

    GuiCreate("UIListLayout", {
        Padding = UDim.new(0, 7),
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
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Parent = self.Frame
    })

    GuiCorner(section.Frame, 8)
    GuiStroke(section.Frame, Color3.fromRGB(0, 0, 0), 1, 0.75)
    GuiPadding(section.Frame, 7, 7, 7, 7)

    GuiCreate("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = section.Frame
    })

    GuiCreate("TextLabel", {
        Name = "SectionTitle",
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        Text = string.upper(section.Name),
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextSize = 9,
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
        Size = UDim2.new(1, 0, 0, height or 38),
        BackgroundColor3 = GuiPalette.Card,
        BorderSizePixel = 0,
        Parent = self.Frame
    })

    GuiCorner(control, 7)

    table.insert(self.Controls, {
        Object = control,
        SearchName = string.lower(tostring(name))
    })

    return control
end

function Section:addButton(name, callback)
    local button = self:_newControl(name, 38, "TextButton")
    button.AutoButtonColor = false
    button.Text = tostring(name)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 11
    button.Font = Enum.Font.GothamBold
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.TextTruncate = Enum.TextTruncate.AtEnd
    GuiPadding(button, 12, 12, 0, 0)

    GuiHover(button, GuiPalette.Card, GuiPalette.CardHover)

    button.MouseButton1Click:Connect(function()
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
    local button = self:_newControl(name, 38, "TextButton")
    button.AutoButtonColor = false
    button.Text = ""
    GuiHover(button, GuiPalette.Card, GuiPalette.CardHover)

    GuiCreate("TextLabel", {
        Position = UDim2.fromOffset(12, 0),
        Size = UDim2.new(1, -76, 1, 0),
        BackgroundTransparency = 1,
        Text = tostring(name),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = button
    })

    local switch = GuiCreate("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.fromOffset(42, 20),
        BackgroundColor3 = state and Color3.fromRGB(255,255,255) or Color3.fromRGB(45,45,45),
        BorderSizePixel = 0,
        Parent = button
    })
    GuiCorner(switch, 10)

    local knob = GuiCreate("Frame", {
        Position = state and UDim2.fromOffset(24, 3) or UDim2.fromOffset(3, 3),
        Size = UDim2.fromOffset(14, 14),
        BackgroundColor3 = state and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255),
        BorderSizePixel = 0,
        Parent = switch
    })
    GuiCorner(knob, 7)

    local function render()
        GuiTweenTo(switch, 0.14, {
            BackgroundColor3 = state and Color3.fromRGB(255,255,255) or Color3.fromRGB(45,45,45)
        })
        GuiTweenTo(knob, 0.14, {
            Position = state and UDim2.fromOffset(24, 3) or UDim2.fromOffset(3, 3),
            BackgroundColor3 = state and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255)
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
    local row = self:_newControl(name, 56, "Frame")

    GuiCreate("TextLabel", {
        Position = UDim2.fromOffset(11, 3),
        Size = UDim2.new(1, -75, 0, 22),
        BackgroundTransparency = 1,
        Text = tostring(name),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row
    })

    local valueLabel = GuiCreate("TextLabel", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -10, 0, 4),
        Size = UDim2.fromOffset(52, 20),
        BackgroundColor3 = Color3.fromRGB(255,255,255),
        BorderSizePixel = 0,
        Text = tostring(math.floor(value + 0.5)),
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextSize = 9,
        Font = Enum.Font.GothamBold,
        Parent = row
    })
    GuiCorner(valueLabel, 5)

    local track = GuiCreate("Frame", {
        Position = UDim2.new(0, 11, 1, -16),
        Size = UDim2.new(1, -22, 0, 5),
        BackgroundColor3 = Color3.fromRGB(65,65,65),
        BorderSizePixel = 0,
        Parent = row
    })
    GuiCorner(track, 3)

    local fill = GuiCreate("Frame", {
        Size = UDim2.new((value - minimum) / math.max(maximum - minimum, 1), 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(255,255,255),
        BorderSizePixel = 0,
        Parent = track
    })
    GuiCorner(fill, 3)

    local knob = GuiCreate("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new((value - minimum) / math.max(maximum - minimum, 1), 0, 0.5, 0),
        Size = UDim2.fromOffset(12, 12),
        BackgroundColor3 = Color3.fromRGB(255,255,255),
        BorderSizePixel = 0,
        Parent = track
    })
    GuiCorner(knob, 6)

    local hitbox = GuiCreate("TextButton", {
        Position = UDim2.new(0, -4, 0, -9),
        Size = UDim2.new(1, 8, 1, 18),
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
    local row = self:_newControl(name, 38, "TextButton")
    row.AutoButtonColor = false
    row.Text = ""
    GuiHover(row, GuiPalette.Card, GuiPalette.CardHover)

    GuiCreate("TextLabel", {
        Position = UDim2.fromOffset(12, 0),
        Size = UDim2.new(1, -110, 1, 0),
        BackgroundTransparency = 1,
        Text = tostring(name),
        TextColor3 = Color3.fromRGB(255,255,255),
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row
    })

    local keyLabel = GuiCreate("TextLabel", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.fromOffset(82, 24),
        BackgroundColor3 = Color3.fromRGB(255,255,255),
        BorderSizePixel = 0,
        Text = keyCode.Name,
        TextColor3 = Color3.fromRGB(0,0,0),
        TextSize = 9,
        Font = Enum.Font.GothamBold,
        Parent = row
    })
    GuiCorner(keyLabel, 6)

    row.MouseButton1Click:Connect(function()
        capturing = true
        keyLabel.Text = "PRESSIONE..."
        keyLabel.TextColor3 = Color3.fromRGB(80,80,80)
    end)

    GuiInput.InputBegan:Connect(function(input, processed)
        if capturing then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                capturing = false
                keyCode = input.KeyCode
                keyLabel.Text = keyCode.Name
                keyLabel.TextColor3 = Color3.fromRGB(0,0,0)

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
    local row = self:_newControl(name, 42, "Frame")
    row.ClipsDescendants = true

    GuiCreate("TextLabel", {
        Position = UDim2.fromOffset(11, 0),
        Size = UDim2.new(0.42, -8, 0, 42),
        BackgroundTransparency = 1,
        Text = tostring(name),
        TextColor3 = Color3.fromRGB(255,255,255),
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row
    })

    local selector = GuiCreate("TextButton", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -10, 0, 7),
        Size = UDim2.new(0.53, 0, 0, 28),
        BackgroundColor3 = Color3.fromRGB(255,255,255),
        BorderSizePixel = 0,
        Text = selected .. "  ▾",
        TextColor3 = Color3.fromRGB(0,0,0),
        TextSize = 9,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        Parent = row
    })
    GuiCorner(selector, 6)

    local optionsHeight = math.min(#options * 30, 150)
    local holder = GuiCreate("ScrollingFrame", {
        Position = UDim2.fromOffset(10, 42),
        Size = UDim2.new(1, -20, 0, optionsHeight),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Color3.fromRGB(255,255,255),
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = row
    })

    GuiCreate("UIListLayout", {
        Padding = UDim.new(0, 3),
        Parent = holder
    })

    local function closeDropdown()
        opened = false
        selector.Text = selected .. "  ▾"
        GuiTweenTo(row, 0.15, {Size = UDim2.new(1, 0, 0, 42)})
    end

    for _, option in ipairs(options) do
        local optionValue = option
        local optionButton = GuiCreate("TextButton", {
            Size = UDim2.new(1, -3, 0, 27),
            BackgroundColor3 = Color3.fromRGB(255,255,255),
            BorderSizePixel = 0,
            Text = tostring(optionValue),
            TextColor3 = Color3.fromRGB(0,0,0),
            TextSize = 9,
            Font = Enum.Font.GothamMedium,
            AutoButtonColor = false,
            Parent = holder
        })
        GuiCorner(optionButton, 5)

        optionButton.MouseEnter:Connect(function()
            optionButton.BackgroundColor3 = Color3.fromRGB(225,225,225)
        end)

        optionButton.MouseLeave:Connect(function()
            optionButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
        end)

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
        GuiTweenTo(row, 0.15, {
            Size = opened
                and UDim2.new(1, 0, 0, 48 + optionsHeight)
                or UDim2.new(1, 0, 0, 42)
        })
    end)

    return row
end

local Venyx = VenyxLibrary.new("TXTUI TURBO")

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
