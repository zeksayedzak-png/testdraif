-- 🎯 Booth Auto-Buyer (للـ Pet Trading)
-- loadstring(game:HttpGet("رابط_هذا_الكود"))()

local player = game.Players.LocalPlayer
local buyRemote = game:GetService("ReplicatedStorage").GameEvents.TradeEvents.Booths.BuyListing

-- 📱 واجهة الموبايل البسيطة
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BoothBuyer"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.95, 0, 0.4, 0)
mainFrame.Position = UDim2.new(0.025, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BackgroundTransparency = 0.1

-- 🎯 العنوان
local title = Instance.new("TextLabel")
title.Text = "🏪 BOOTH AUTO-BUYER"
title.Size = UDim2.new(1, 0, 0.15, 0)
title.BackgroundColor3 = Color3.fromRGB(200, 50, 0)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold

-- 📝 حقل إدخال Listing ID
local idInput = Instance.new("TextBox")
idInput.PlaceholderText = "أدخل Listing ID هنا"
idInput.Size = UDim2.new(0.9, 0, 0.15, 0)
idInput.Position = UDim2.new(0.05, 0, 0.2, 0)
idInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
idInput.TextColor3 = Color3.new(1, 1, 1)
idInput.Font = Enum.Font.SourceSans

-- 🔢 حقل السعر (اختياري)
local priceInput = Instance.new("TextBox")
priceInput.PlaceholderText = "السعر (ضع 0)"
priceInput.Text = "0"
priceInput.Size = UDim2.new(0.9, 0, 0.12, 0)
priceInput.Position = UDim2.new(0.05, 0, 0.4, 0)
priceInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
priceInput.TextColor3 = Color3.new(1, 1, 1)
priceInput.Font = Enum.Font.SourceSans

-- ⚡ زر الشراء
local buyBtn = Instance.new("TextButton")
buyBtn.Text = "⚡ اشترِ الآن (سعر 0)"
buyBtn.Size = UDim2.new(0.9, 0, 0.2, 0)
buyBtn.Position = UDim2.new(0.05, 0, 0.57, 0)
buyBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
buyBtn.TextColor3 = Color3.new(1, 1, 1)
buyBtn.Font = Enum.Font.SourceSansBold
buyBtn.TextSize = 18

-- 📊 النتائج
local resultLabel = Instance.new("TextLabel")
resultLabel.Text = "أدخل Listing ID واضغط ⚡"
resultLabel.Size = UDim2.new(0.9, 0, 0.2, 0)
resultLabel.Position = UDim2.new(0.05, 0, 0.82, 0)
resultLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
resultLabel.TextColor3 = Color3.new(1, 1, 1)
resultLabel.TextWrapped = true

-- ⚡ دالة الشراء
local function buyListing(listingId, price)
    if not listingId or listingId == "" then
        return false, "❌ أدخل Listing ID"
    end
    
    price = tonumber(price) or 0
    
    local payloads = {
        -- الطريقة 1: listingId مباشر
        {listingId = listingId, price = price},
        
        -- الطريقة 2: مع buyerId
        {
            listingId = listingId, 
            price = price,
            buyerId = player.UserId,
            buyerName = player.Name
        },
        
        -- الطريقة 3: جدول مفصل
        {
            id = listingId,
            cost = price,
            buyer = player.UserId,
            seller = "auto", -- جرب
            item = "pet"
        },
        
        -- الطريقة 4: مع timestamp
        {
            listingId = listingId,
            price = price,
            timestamp = os.time(),
            transactionId = "buy_" .. listingId .. "_" .. os.time()
        }
    }
    
    -- جرب كل payload
    for i, payload in ipairs(payloads) do
        local success, result = pcall(function()
            return buyRemote:InvokeServer(payload)
        end)
        
        if success then
            return true, "✅ نجح! الطريقة " .. i .. " - " .. tostring(result)
        end
        
        task.wait(0.3) -- تأخير بسيط
    end
    
    return false, "❌ كل الطرق فشلت"
end

-- 🎮 حدث الزر
buyBtn.MouseButton1Click:Connect(function()
    local listingId = idInput.Text:gsub("%s+", "")
    local price = tonumber(priceInput.Text) or 0
    
    if listingId == "" then
        resultLabel.Text = "❌ أدخل Listing ID"
        return
    end
    
    buyBtn.Text = "⏳ جاري الشراء..."
    buyBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
    resultLabel.Text = "🎯 جاري شراء " .. listingId
    
    task.spawn(function()
        local success, message = buyListing(listingId, price)
        
        if success then
            resultLabel.Text = message
            resultLabel.BackgroundColor3 = Color3.fromRGB(0, 80, 0)
            print("🎉 نجح شراء Booth!")
            print("📦 Listing ID: " .. listingId)
            print("💰 السعر: " .. price)
            print("📝 النتيجة: " .. message)
        else
            resultLabel.Text = message
            resultLabel.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
        end
        
        buyBtn.Text = "⚡ اشترِ الآن (سعر 0)"
        buyBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    end)
end)

-- 🔄 زر تجربة ID تلقائي
local autoTestBtn = Instance.new("TextButton")
autoTestBtn.Text = "🎲 جرب ID عشوائي"
autoTestBtn.Size = UDim2.new(0.44, 0, 0.1, 0)
autoTestBtn.Position = UDim2.new(0.05, 0, 0.77, 0)
autoTestBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 150)
autoTestBtn.TextColor3 = Color3.new(1, 1, 1)
autoTestBtn.Visible = false

-- إنشاء ID عشوائي للاختبار
autoTestBtn.MouseButton1Click:Connect(function()
    local randomId = "booth_" .. math.random(10000, 99999) .. "_" .. os.time()
    idInput.Text = randomId
    resultLabel.Text = "🎲 ID عشوائي: " .. randomId
end)

-- التجميع
title.Parent = mainFrame
idInput.Parent = mainFrame
priceInput.Parent = mainFrame
buyBtn.Parent = mainFrame
autoTestBtn.Parent = mainFrame
resultLabel.Parent = mainFrame
mainFrame.Parent = screenGui
screenGui.Parent = player.PlayerGui

-- 📊 أوامر الكونسول
_G.BuyBooth = function(listingId, price)
    if not listingId then
        return "أدخل: _G.BuyBooth('listing_id', 0)"
    end
    
    local success, message = buyListing(listingId, price or 0)
    return message
end

_G.TestBooth = function()
    -- جرب مع ID افتراضي
    local testId = "test_booth_" .. player.UserId
    return buyListing(testId, 0)
end

-- 📢 الإعلان
print([[
    
🏪 BOOTH AUTO-BUYER v1.0
⚡ للشراء من Booths بسعر 0

📝 كيف تستخدم:
1. أدخل Listing ID (الرقم اللي معك)
2. تأكد السعر = 0
3. اضغط "اشترِ الآن"

🎯 مثال:
• Listing ID: booth_12345_abc
• السعر: 0
• النتيجة: تحصل على Pet مجاناً!

⚡ من الكونسول:
_G.BuyBooth("listing_id", 0)

]])
