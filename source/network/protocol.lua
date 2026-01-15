--< Written by: Christopher Gholmieh
--< Variables (Assignment):

--< Utilities:
local Logger = require("source.utilities.logger")

--< Protocol:
local Protocol = {}

--< Functions:
function Protocol.build_default_codec()
    --< Variables (Assignment):
    --< Protobuf:
    local protobuf_success, Protobuf = pcall(require, "pb")

    --< Protoc:
    local protoc_success, Protoc = pcall(require, "protoc")

    --< Validation:
    if not protobuf_success or not protoc_success then
        return nil, "[!] Missing protobuf dependencies: protoc/pb!"
    end

    --< Protoc:
    Protoc.include = {"./"}

    --< Variables (Assignment):
    --< Success:
    local success, error = pcall(Protoc.loadfile, "s2clientprotocol/sc2api.proto")

    if not success then
        return nil, "[!] Failed to load s2clientprotocol/sc2api.proto: " .. tostring(error)
    end

    --< Codec:
    return {
        --< Decode:
        decode = function(_, type_name, payload)
            return Protobuf.decode(type_name, payload)
        end;

        --< Encode:
        encode = function(_, type_name, value)
            return Protobuf.encode(type_name, value)
        end;
    }
end

function Protocol.decode_response(codec, payload)
    --< Variables (Assignment):
    --< Response:
    local response, error = codec:decode("SC2APIProtocol.Response", payload)

    if not response then
        --< Logger:
        Logger.log_error("[!] Failed to decode response: " .. tostring(error))

        --< Logic:
        return nil
    end

    --< Response:
    return response;
end

function Protocol.validate_socket(socket)
    --< Validation:
    if not socket then
        --< Logger:
        Logger.log_error("[!] ")

        --< Logic:
        return false
    end

    --< Logic:
    return true
end

function Protocol.new(socket, options)
    --< Variables (Assignment):
    --< Self:
    local Self = {
        --< Options:
        options = options or {};

        --< Socket:
        socket = socket;

        --< Codec:
        codec = nil;
    }

    --< Logic:
    setmetatable(Self, Protocol)

    --< Self:
    return Self
end

--< Methods:
function Protocol:initialize()
    --< Case:
    if self.codec then
        return true
    end

    --< Variables (Assignment):
    --< Codec:
    local codec, error = Protocol.build_default_codec()

    if not codec then
        --< Logger:
        Logger.log_error(error)

        --< Logic:
        return false
    end

    --< Codec:
    self.codec = codec

    --< Logic:
    return true
end

function Protocol:send(request)
    --< Validation:
    if not self:initialize() then
        return false
    end

    if not Protocol.validate_socket(self.socket) then
        return false
    end

    --< Variables (Assignment):
    --< Payload:
    local payload, error = self.codec:encode("Sc2APIProtocol.Request", request)

    if not payload then
        --< Logger:
        Logger.log_error("[!] Failed to encode request: " .. tostring(error))

        --< Logic:
        return false
    end

    --< Success:
    local success = self.socket:send_frame(payload, 0x02)

    if not success then
        --< Logger:
        Logger.log_error("[!] Failed to send request!")

        --< Logic:
        return false
    end

    --< Logic:
    return true
end

function Protocol:receive()
    --< Validation:
    if not self:initialize() then
        return nil
    end

    if not Protocol.validate_socket(self.socket) then
        return nil
    end

    --< Logic:
    while true do
        --< Variables (Assignment):
        --< Payload:
        local payload, code = self.socket:receive()

        if not payload then
            --< Logger:
            Logger.log_error("[!] Failed to receive socket frame: " .. tostring(code))

            --< Logic:
            return nil
        end

        --< Case:
        if code == 0x08 then
            --< Logger:
            Logger.log_warning("[*] Connection closed by server!")

            --< Logic:
            return nil
        end

        --< Logic:
        if code == 0x09 then
            self.socket:send(payload, 0xA)
        elseif code == 0x02 then
            --< Debug:
            if self.options.debug then
                --< Logger:
                Logger.log_information(Logger.format("[>] Socket payload length: %s", tostring(#payload)))
            end

            --< Logic:
            return Protocol.decode_response(self.codec, payload)
        end
    end
end

--< Protocol:
Protocol.__index = Protocol
return Protocol