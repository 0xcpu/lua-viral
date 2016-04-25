local cjson = require 'cjson'
local utils = require 'utils'

local ui = {}

local LV_HEADER = "[=== LuaViral ===]\n"
local LV_RCODE  = "->\tResponse code: "
local LV_PRMLNK = "->\tPermalink: "
local LV_SCANID = "->\tScan id: "
local LV_VTMSG  = "->\tResponse message: "

local function showVTRequest(reqData)
   assert(reqData)

   io.stdout:write(LV_HEADER)
   for key, value in pairs(reqData) do
      io.stdout:write("\t" .. key .. " = " .. value .. "\n")
   end
   io.stdout:flush()
end

local function showVTResponse(headers, stream)
   assert(headers)
   assert(stream)

   local bodyStr = stream:get_body_as_string()
   assert(bodyStr)
   local bodyTab = cjson.decode(bodyStr)
   assert(bodyTab)

   io.stdout:write(LV_HEADER)
   io.stdout:write(LV_RCODE .. headers:get(':status') .. "\n")
   io.stdout:write(LV_PRMLNK .. bodyTab.permalink .. "\n")
   io.stdout:write(LV_SCANID .. bodyTab.scan_id .. "\n")
   io.stdout:write(LV_VTMSG .. bodyTab.verbose_msg .. "\n")
   io.stdout:flush()
end

ui.showVTRequest  = showVTRequest
ui.showVTResponse = showVTResponse

return ui
