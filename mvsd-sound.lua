local url = "https://purplesstrat.github.io/pew.mp3"
local filename = "pew.mp3"

if isfile(filename) then return end

local req = syn and syn.request or http and http.request or http_request
if not req then
    warn("Your executor does not support HTTP requests.")
    return
end

local response = req({
    Url = url,
    Method = "GET"
})

if response and response.StatusCode == 200 then
    writefile(filename, response.Body)
    print("MP3 downloaded as " .. filename)
else
    warn("Failed to download MP3: ", response and (response.StatusCode or "no response"))
end
