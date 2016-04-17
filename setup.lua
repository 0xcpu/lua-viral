local lfs   = require 'lfs'
local utils = require 'src/utils'

local rootDirPath      = os.getenv('HOME')
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
   assert(apiKey)

   local cd, err1 = lfs.chdir(rootDirPath .. '/' .. configDirPath)
   assert(cd, err1)

   local fh, err2 = io.open(configApiKeyFile, 'w')
   assert(fh, err2)

   fh:write(apiKey)
   fh:close()

   io.stdout:write("API key was succesfully saved at " .. configDirPath ..
		      "/" .. configApiKeyFile .. "\n")
end

local function readUserApiKey()
   io.stdout:write("Please input your API key: ")

   return io.read()
end

local function setup()
   io.stdout:write("=== Setup started\n")

   local cd, err = lfs.chdir(rootDirPath .. '/' .. configDirPath)
   if cd then
      io.stdout:write("Configuration directory already exists.\n")

      if utils.fileExists(configApiKeyFile) then
	 io.stdout:write("Do you want to update API key file [y/n]? ")

	 if io.read():lower() == 'y' then
	    goto writeApiKey
	 else
	    goto setupEnd
	 end
      else
	 goto writeApiKey
      end
   end

   createConfigDir()

   ::writeApiKey::
   createApiKeyFile(readUserApiKey())

   ::setupEnd::
   io.stdout:write("=== Setup is finished\n")
end

setup()
