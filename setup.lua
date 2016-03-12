local lfs = require "lfs"

local rootDirPath      = os.getenv("HOME")
local configDirPath    = '.luaviral'
local configApiKeyFile = 'api_key'

local function createConfigDir()
   local cd, err = lfs.chdir(rootDirPath)
   assert(cd, err)
   
   local dh, err1 = lfs.mkdir(configDirPath)
   assert(dh, err1)

   io.stdout:write("config directory created at " .. configDirPath .. "\n")
end

local function createApiKeyFile(apiKey)
   local cd, err1 = lfs.chdir(rootDirPath .. '/' .. configDirPath)
   assert(cd, err1)

   local fh, err2 = io.open(configApiKeyFile, 'w')
   assert(fh, err2)

   fh:write(apiKey)
   fh:close()

   io.stdout:write("API key was succesfully saved at " .. configDirPath ..
		      "/" .. configApiKeyFile .. "\n")
end

local function setup()
   io.stdout:write("Setup started\n")
   io.stdout:write("Please input your API key: ")
   local apiKey = io.read()

   createConfigDir()
   createApiKeyFile(apiKey)

   io.stdout:write("Setup is finished\n")
end

setup()
