local cjson = require 'cjson'
local utils = require 'utils'

local ui = {}

local LV_HEADER = "[=== LuaViral ===]\n"
local LV_RCODE  = "->\tResponse code: "
local LV_PRMLNK = "->\tPermalink: "
local LV_SCANID = "->\tScan id: "
local LV_VTMSG  = "->\tResponse message: "
local LV_POSTVS = "->\t\tPositives: "
local LV_TOTAL  = "->\t\tTotal: "
local LV_FSCNID = "->\t\tFile scan id: "
local LV_ANTVRS = "->\t\tAnti-virus: "
local LV_DETECT = " detected: "
local LV_RESULT = " result: "

local function showVTRequest(reqData)
   assert(reqData)

   io.stdout:write(LV_HEADER)
   for key, value in pairs(reqData) do
      io.stdout:write("\t" .. key .. " = " .. value .. "\n")
   end
   io.stdout:flush()
end

local function showVTResponse(headers, stream, report, repType)
   assert(headers)
   assert(stream)

   local bodyStr = stream:get_body_as_string()
   assert(bodyStr)
   local bodyTab = cjson.decode(bodyStr)
   assert(bodyTab)

   io.stdout:write(LV_HEADER)
   local respCode = headers:get(':status')
   io.stdout:write(LV_RCODE .. respCode .. "\n")
   io.stdout:write(LV_VTMSG .. bodyTab.verbose_msg .. "\n")
   if respCode == '200' then
      if bodyTab.permalink and bodyTab.scan_id then
	 io.stdout:write(LV_PRMLNK .. bodyTab.permalink .. "\n")
	 io.stdout:write(LV_SCANID .. bodyTab.scan_id .. "\n")
      else
	 io.stdout:flush()
	 return
      end

      if report then
	 if repType == 'file' then
	    -- to do
	 elseif repType == 'url' then
	    io.stdout:write(LV_POSTVS .. bodyTab.positives .. "\n")
	    io.stdout:write(LV_TOTAL .. bodyTab.total .. "\n")
	    io.stdout:write(LV_FSCNID .. bodyTab.filescan_id .. "\n")
	    for k, v in pairs(bodyTab.scans) do
	       io.stdout:write(table.concat({
				     LV_ANTVRS, k, LV_DETECT, v.detected,
				     LV_RESULT, v.result, "\n"
	       }))
	    end
	 else
	    error("Unknown report type")
	 end
      end
   end
   io.stdout:flush()
end

ui.showVTRequest  = showVTRequest
ui.showVTResponse = showVTResponse

return ui
