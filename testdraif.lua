-- 🎯 Ultimate RemoteFunctions Exploiter
-- loadstring(game:HttpGet("رابط_هذا_الكود"))()

local player = game.Players.LocalPlayer
local currentID = nil

-- 🔧 قائمة RemoteFunctions اللي لقيناها
local TargetFunctions = {
    {
        name = "BuyListing",
        path = "ReplicatedStorage.GameEvents.TradeEvents.Booths.BuyListing",
        object = nil,
        tested = false,
        success = false
    },
    {
        name = "Purchase",
        path = "ReplicatedStorage.GameEvents.TradeEvents.TradeTokens.Purchase",
        object = nil,
        tested = false,
        success = false
    },
    {
        name = "CanPurchase",
        path = "ReplicatedStorage.GameEvents.TradeEvents.TradeTokens.CanPurchase",
        object = nil,
        tested = false,
        success = false
    },
    {
        name = "CanSeeShopPack",
        path = "ReplicatedStorage.GameEvents.CanSeeShopPack",
        object = nil,
        tested = false,
        success = false
    },
    {
        name = "GetPlayersWithSeasonPass",
        path = "ReplicatedStorage.GameEvents.SeasonPass.GetPlayersWithSeasonPass",
        object = nil,
        tested = false,
        success = false
    },
    {
        name = "GetItemRAPHistory",
        path = "ReplicatedStorage.GameEvents.TradeEvents.TokenRAPs.GetItemRAPHistory",
        object = nil,
        tested = false,
        success = false
    },
    {
        name = "GetItemRAPById",
        path = "ReplicatedStorage.GameEvents.TradeEvents.TokenRAPs.GetItemRAPById",
        object = nil,
        tested = false,
        success = false
    },
    {
        name = "RequestItemInstance",
        path = "ReplicatedStorage.GameEvents.RequestItemInstance",
        object = nil,
        tested = false,
        success = false
    }
}

-- 🔍 تحميل الـ RemoteFunctions
local function loadFunctions()
    for _, func in ipairs(TargetFunctions) do
        local success, obj = pcall(function()
            return game:GetService("ReplicatedStorage"):FindFirstChild("GameEvents")
        end)
        
        if success and obj then
            -- بناء المسار تدريجياً
            local pathParts = func.path:split(".")
            local current = game
            
            for i = 2, #pathParts do
                if current:FindFirstChild(pathParts[i]) then
                    current = current[pathParts[i]]
                else
                    current = nil
                    break
                end
            end
            
            if current and current:IsA("RemoteFunction") then
                func.object = current
                func.status = "✅ موجود"
            else
                func.status = "❌ مش موجود"
            end
        else
            func.status = "❌ GameEvents مش موجودة"
        end
    end
end

-- ⚡ اختبار RemoteFunction واحد
local function testFunction(funcInfo, gamepassId)
    if not funcInfo.object then
        return false, "الـ RemoteFunction مش موجود"
    end
    
    -- طرق مختلفة للتجربة
    local testMethods = {
        {name = "ID مباشر", call = function() return funcInfo.object:InvokeServer(gamepassId) end},
        {name = "جدول ID", call = function() return funcInfo.object:InvokeServer({id = gamepassId}) end},
        {name = "مع buy", call = function() return funcInfo.object:InvokeServer("buy", gamepassId) end},
        {name = "مع purchase", call = function() return funcInfo.object:InvokeServer("purchase", gamepassId) end},
        {name = "مع player", call = function() return funcInfo.object:InvokeServer(player, gamepassId) end},
        {name = "جدول مفصل", call = function() return funcInfo.object:InvokeServer({gamepassId = gamepassId, playerId = player.UserId}) end}
    }
    
    for _, method in ipairs(testMethods) do
        local success, result = pcall(method.call)
        
        if success then
            funcInfo.tested = true
            funcInfo.success = true
            funcInfo.lastResult = result
            funcInfo.lastMethod = method.name
            return true, method.name .. ": ناجح - " .. tostring(result)
        end
        
        task.wait(0.2) -- تأخير بين المحاولات
    end
    
    return false, "كل الطرق فشلت"
end

-- 🎯 اختبار كل الـ RemoteFunctions
local function testAllFunctions(gamepassId)
    if not gamepassId or type(gamepassId) ~= "number" then
        return "❌ أدخل رقم صحيح لـ Gamepass ID"
    end
    
    currentID = gamepassId
    local results = {}
    local successCount = 0
    
    print("\n🎯 بدء اختبار RemoteFunctions...")
    print("🎯 Gamepass ID: " .. gamepassId)
    print("=" .. string.rep("=", 40))
    
    for _, func in ipairs(TargetFunctions) do
        if func.object then
            print("\n🔧 جرب: " .. func.name)
            
            local success, message = testFunction(func, gamepassId)
            
            if success then
                successCount = successCount + 1
                print("   ✅ " .. message)
                table.insert(results, {
                    name = func.name,
                    status = "✅",
                    message = message
                })
            else
                print("   ❌ " .. message)
                table.insert(results, {
                    name = func.name,
                    status = "❌",
                    message = message
                })
            end
        else
            table.insert(results, {
                name = func.name,
                status = "⚠️",
                message = "الـ RemoteFunction مش موجود"
            })
        end
        
        task.wait(0.5) -- تأخير بين الـ Functions
    end
    
    print("\n" .. string.rep("=", 40))
    print("📊 النتائج النهائية:")
    print("✅ ناجحة: " .. successCount)
    print("❌ فاشلة: " .. (#TargetFunctions - successCount))
    
    return {
        total = #TargetFunctions,
        success = successCount,
        failed = #TargetFunctions - successCount,
        details = results
    }
end

-- 📱 واجهة الموبايل الكاملة
local function createMobileUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "RFExploiterUI"
    screenGui.ResetOnSpawn = false
    
    -- الإطار الرئيسي
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0.98, 0, 0.7, 0)
    mainFrame.Position = UDim2.new(0.01, 0, 0.15, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
    
    -- العنوان
    local title = Instance.new("TextLabel")
    title.Text = "🎯 REMOTE FUNCTIONS EXPLOITER"
    title.Size = UDim2.new(1, 0, 0.08, 0)
    title.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 18
    
    -- حقل إدخال ID
    local idBox = Instance.new("TextBox")
    idBox.Name = "IDBox"
    idBox.PlaceholderText = "أدخل Gamepass ID هنا"
    idBox.Size = UDim2.new(0.9, 0, 0.07, 0)
    idBox.Position = UDim2.new(0.05, 0, 0.1, 0)
    idBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    idBox.TextColor3 = Color3.new(1, 1, 1)
    idBox.Font = Enum.Font.SourceSans
    idBox.TextSize = 16
    idBox.ClearTextOnFocus = false
    
    -- زر تحميل الـ Functions
    local loadBtn = Instance.new("TextButton")
    loadBtn.Text = "🔧 تحميل RemoteFunctions"
    loadBtn.Size = UDim2.new(0.44, 0, 0.07, 0)
    loadBtn.Position = UDim2.new(0.05, 0, 0.19, 0)
    loadBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    loadBtn.TextColor3 = Color3.new(1, 1, 1)
    loadBtn.Font = Enum.Font.SourceSansBold
    
    -- زر الاختبار
    local testBtn = Instance.new("TextButton")
    testBtn.Text = "⚡ اختراق Gamepass"
    testBtn.Size = UDim2.new(0.44, 0, 0.07, 0)
    testBtn.Position = UDim2.new(0.51, 0, 0.19, 0)
    testBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 0)
    testBtn.TextColor3 = Color3.new(1, 1, 1)
    testBtn.Font = Enum.Font.SourceSansBold
    
    -- إطار النتائج
    local resultsFrame = Instance.new("ScrollingFrame")
    resultsFrame.Name = "ResultsFrame"
    resultsFrame.Size = UDim2.new(0.9, 0, 0.6, 0)
    resultsFrame.Position = UDim2.new(0.05, 0, 0.29, 0)
    resultsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    resultsFrame.BorderSizePixel = 1
    resultsFrame.BorderColor3 = Color3.new(0.3, 0.3, 0.3)
    resultsFrame.ScrollBarThickness = 8
    resultsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local resultsLayout = Instance.new("UIListLayout")
    resultsLayout.Parent = resultsFrame
    resultsLayout.Padding = UDim.new(0, 5)
    
    -- العداد
    local counter = Instance.new("TextLabel")
    counter.Text = "🟢 جاهز للبدء"
    counter.Size = UDim2.new(1, 0, 0.08, 0)
    counter.Position = UDim2.new(0, 0, 0.92, 0)
    counter.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    counter.TextColor3 = Color3.new(1, 1, 1)
    counter.TextWrapped = true
    
    -- 🔧 تحميل الـ Functions وعرضها
    local function loadAndDisplayFunctions()
        loadBtn.Text = "⏳ جاري التحميل..."
        counter.Text = "🔧 يحمل RemoteFunctions..."
        
        task.spawn(function()
            loadFunctions()
            
            -- مسح المحتوى القديم
            for _, child in ipairs(resultsFrame:GetChildren()) do
                if not child:IsA("UIListLayout") then
                    child:Destroy()
                end
            end
            
            -- عرض كل الـ Functions
            for _, func in ipairs(TargetFunctions) do
                local itemFrame = Instance.new("Frame")
                itemFrame.Size = UDim2.new(1, 0, 0, 50)
                itemFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                itemFrame.BorderSizePixel = 1
                
                local nameLabel = Instance.new("TextLabel")
                nameLabel.Text = func.name
                nameLabel.Size = UDim2.new(0.6, 0, 1, 0)
                nameLabel.Position = UDim2.new(0, 0, 0, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.TextColor3 = func.object and Color3.new(0, 1, 1) or Color3.new(1, 0.5, 0.5)
                nameLabel.TextXAlignment = Enum.TextXAlignment.Left
                nameLabel.PaddingLeft = UDim.new(0, 10)
                nameLabel.Font = Enum.Font.SourceSansBold
                
                local statusLabel = Instance.new("TextLabel")
                statusLabel.Text = func.object and "✅ جاهز" or "❌ غير موجود"
                statusLabel.Size = UDim2.new(0.35, 0, 1, 0)
                statusLabel.Position = UDim2.new(0.65, 0, 0, 0)
                statusLabel.BackgroundTransparency = 1
                statusLabel.TextColor3 = func.object and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
                
                nameLabel.Parent = itemFrame
                statusLabel.Parent = itemFrame
                itemFrame.Parent = resultsFrame
            end
            
            local loadedCount = 0
            for _, func in ipairs(TargetFunctions) do
                if func.object then loadedCount = loadedCount + 1 end
            end
            
            loadBtn.Text = "🔧 تحميل RemoteFunctions"
            counter.Text = string.format("✅ حمّل %d/%d RemoteFunctions", loadedCount, #TargetFunctions)
        end)
    end
    
    -- ⚡ اختبار الـ Gamepass
    local function testGamepass()
        local idText = idBox.Text:gsub("%s+", "")
        local gamepassId = tonumber(idText)
        
        if not gamepassId then
            counter.Text = "❌ أدخل رقم صحيح لـ Gamepass ID"
            return
        end
        
        testBtn.Text = "⚡ جاري الاختراق..."
        counter.Text = "🎯 جاري اختبار ID: " .. gamepassId
        
        task.spawn(function()
            local results = testAllFunctions(gamepassId)
            
            -- تحديث العداد
            counter.Text = string.format("📊 النتائج: ✅ %d ❌ %d", results.success, results.failed)
            
            if results.success > 0 then
                counter.BackgroundColor3 = Color3.fromRGB(0, 80, 0)
            else
                counter.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
            end
            
            testBtn.Text = "⚡ اختراق Gamepass"
        end)
    end
    
    -- أحداث الأزرار
    loadBtn.MouseButton1Click:Connect(loadAndDisplayFunctions)
    testBtn.MouseButton1Click:Connect(testGamepass)
    
    -- التجميع
    title.Parent = mainFrame
    idBox.Parent = mainFrame
    loadBtn.Parent = mainFrame
    testBtn.Parent = mainFrame
    resultsFrame.Parent = mainFrame
    counter.Parent = mainFrame
    mainFrame.Parent = screenGui
    screenGui.Parent = player.PlayerGui
    
    return screenGui
end

-- أوامر الكونسول
_G.LoadRFunctions = function()
    loadFunctions()
    
    local loaded = 0
    for _, func in ipairs(TargetFunctions) do
        if func.object then loaded = loaded + 1 end
    end
    
    return string.format("حمّل %d/%d RemoteFunctions", loaded, #TargetFunctions)
end

_G.TestRF = function(gamepassId)
    if not gamepassId then
        return "أدخل: _G.TestRF(123456)"
    end
    return testAllFunctions(gamepassId)
end

_G.GetTargets = function()
    local list = {}
    for _, func in ipairs(TargetFunctions) do
        table.insert(list, {
            name = func.name,
            path = func.path,
            loaded = func.object ~= nil
        })
    end
    return list
end

-- بدء التشغيل
print([[
    
🎯 ULTIMATE REMOTE FUNCTIONS EXPLOITER
⚡ مصمم خصيصاً للـ 8 RemoteFunctions اللي لقيتها

🎯 الأهداف:
1. BuyListing - شراء القوائم
2. Purchase - شراء مباشر  
3. CanPurchase - تحقق قبل الشراء
4. CanSeeShopPack - رؤية العروض
5. GetPlayersWithSeasonPass - معلومات الـ Season Pass
6. GetItemRAPHistory - تاريخ الأسعار
7. GetItemRAPById - سعر الـ Item
8. RequestItemInstance - طلب الـ Item

📱 الاستخدام:
1. اضغط "تحميل RemoteFunctions"
2. أدخل Gamepass ID  
3. اضغط "اختراق Gamepass"
4. شاهد النتائج في الكونسول

]])

-- تحميل أولي
task.spawn(function()
    loadFunctions()
    print("🔧 جاري تحميل RemoteFunctions...")
    task.wait(1)
    
    local loaded = 0
    for _, func in ipairs(TargetFunctions) do
        if func.object then loaded = loaded + 1 end
    end
    
    print("✅ حمّل " .. loaded .. "/8 RemoteFunctions")
end)

-- إنشاء الواجهة
createMobileUI()

print("✅ RemoteFunctions Exploiter جاهز!")
