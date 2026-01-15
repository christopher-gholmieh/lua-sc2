--< Written by: Christopher Gholmieh
--< Variables (Assignment):

--< Configuration:
local Configuration = require("source.configuration")

--< Utilities:
local Logger = require("source.utilities.logger")

--< Socket:
local Socket = {}

--< Functions:
function Socket.new()
    --< Variables (Assignment):
    --< Self:
    local Self = {
        --< Host:
        HOST = Configuration.HOST;

        --< Port:
        PORT = Configuration.PORT;

        --< TCP:
        TCP = nil;
    }

    --< Logic:
    setmetatable(Self, Socket)

    --< Self:
    return Self
end

--< Methods:
function Socket:initialize()
    --< Validation:
    if self.TCP then
        --< Logger:
        Logger.log_warning("[!] Socket already has a TCP instance!")

        --< Logic:
        return false
    end

    --< Variables (Assignment):
    --< TCP:
    self.TCP = require("socket").tcp()

    if not self.TCP then
        --< Logger:
        Logger.log_warning("[!] Failed to create a TCP instance!")

        --< Logic:
        return false
    end

    --< Logic:
    return true
end

function Socket:connect()
    --< Validation:
    if not self.TCP then
        --< Logger:
        Logger.log_error("[!] Socket was not initialized or failed initialization!")

        --< Logic:
        return false
    end

    --< Variables (Assignment):
    --< Success:
    local Success, Error = self.TCP:connect(self.HOST, self.PORT)

    if not Success then
        --< Logger:
        Logger.log_error(
            Logger.format(
                --< Buffer:
                "[!] Failed to connect TCP instance to %s:%s!",

                --< Host:
                self.HOST,

                --< Port:
                self.PORT
            )
        )

        --< Logger:
        Logger.log_error("[!] Error: " .. Error)

        --< Logic:
        return false
    end

    --< Logger:
    Logger.log_information(
        Logger.format(
            --< Buffer:
            "[!] Successfully connected TCP instance to %s:%s!",

            --< Host:
            self.HOST,

            --< Port:
            self.PORT
        )
    )

    --< Logic:
    return true
end

function Socket:close()
    --< Validation:
    if not self.TCP then
        --< Logger:
        Logger.log_error("[!] Socket was not initialized or failed initialization!")

        --< Logic:
        return false
    end

    --< Socket:
    self.TCP:close()

    --< Logger:
    Logger.log_information(
        Logger.format(
            --< Buffer:
            "[!] Successfully closed TCP instance at %s:%s!",

            --< Host:
            self.HOST,

            --< Port:
            self.PORT
        )
    )

    --< Logic:
    return true
end

--< Socket:
Socket.__index = Socket
return Socket