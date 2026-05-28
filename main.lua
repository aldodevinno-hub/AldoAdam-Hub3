-- AldoAdam Hub Loader (Fixed)
local genv = getgenv and getgenv()
if not genv then return end

if genv.aldo_execute_debounce and (tick() - genv.aldo_execute_debounce) <= 5 then 
    return 
end
genv.aldo_execute_debounce = tick()

if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

-- LANGSUNG LOAD SCRIPT TANPA CACHE (lebih simpel)
local scriptUrl = "https://raw.githubusercontent.com/aldodevinno-hub/AldoAdam-Hub2/main/kick.lua"

local success, response = pcall(function()
    return game:HttpGet(scriptUrl, true)
end)

if success and response and response ~= "" then
    local func, err = loadstring(response)
    if func then
        task.spawn(func)
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "AldoAdam Error",
            Text = "Loadstring failed: " .. tostring(err),
            Duration = 10
        })
    end
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "AldoAdam Hub Error",
        Text = "Cannot fetch script. Check URL or internet.",
        Duration = 10
    })
end
