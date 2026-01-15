--< Written by: Christopher Gholmieh
--< Variables (Assignment):

--< Configuration:
local Configuration = require("source.configuration")

--< Utilities:
local Cryptography = require("source.utilities.cryptography")
local Manipulation = require("source.utilities.manipulation")
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

		--< Seeded:
		seeded = false;
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
    return self:handshake()
end

function Socket:generate_random_bytes(length)
	if not self.seeded then
		--< Seed:
		math.randomseed(os.time())

		--< Seed:
		self.seeded = true
	end

	--< Variables (Assignment):
	--< Bytes:
	local bytes = {}

	--< Logic:
	for iterator = 1, length do
		bytes[iterator] = string.char(math.random(0, 255))
	end

	--< Bytes:
	return table.concat(bytes)
end

function Socket:receive_until(terminator, max_bytes)
	--< Validation:
	if not self.TCP then
		--< Logger:
		Logger.log_error("[!] Socket was not initialized or failed initialization!")

		--< Logic:
		return false
	end

	--< Variables (Assignment):
	--< Buffer:
	local buffer = {}

	--< Length:
	local length = 0

	--< Logic:
	while length < max_bytes do
		--< Variables (Assignment):
		--< Data:
		local data, error, partial = self.TCP:receive(1)

		if not data then
			if partial and #partial == 1 then
				data = partial
			else
				return nil, error
			end
		end

		--< Length:
		length = length + 1

		--< Logic:
		buffer[length] = data

		if length >= #terminator then
			--< Variables (Assignment):
			--< Tail:
			local tail = table.concat(buffer, "", length - #terminator + 1, length)

			if tail == terminator then
				return table.concat(buffer)
			end
		end
	end

	return nil, "[!] Header is too large!"
end

function Socket:receive_exact(length)
	--< Validation:
	if not self.TCP then
		--< Logger:
		Logger.log_error("[!] Socket was not initialized or failed initialization!")

		--< Logic:
		return false
	end

	--< Variables (Assignment):
	--< Chunks:
	local chunks = {}

	--< Remaining:
	local remaining = length

	--< Logic:
	while remaining > 0 do
		--< Variables (Assignment):
		--< Data:
		local data, error, partial = self.TCP:receive(remaining)

		--< Logic:
		if not data then
			if partial and #partial > 0 then
				--< Variables (Assignment):
				--< Chunks:
				chunks[#chunks + 1] = partial

				--< Remaining:
				remaining = remaining - #partial
			elseif error then
				return nil, error
			end
		else
			--< Variables (Assignment):
			--< Chunks:
			chunks[#chunks + 1] = data

			--< Remaining:
			remaining = remaining - #data
		end
	end

	--< Chunks:
	return table.concat(chunks)
end

function Socket:handshake()
	--< Validation:
	if not self.TCP then
		--< Logger:
		Logger.log_error("[!] Socket was not initialized or failed initialization!")

		--< Logic:
		return false
	end

	--< Variables (Assignment):
	--< Key:
	local key = Cryptography.base64_encode(self:generate_random_bytes(16))

	--< Request:
	local request = Logger.format(
		--< Buffer:
		"GET /sc2api HTTP/1.1\r\nHost: %s:%s\r\nUpgrade: websocket\r\nConnection: Upgrade\r\nSec-WebSocket-Key:%s\r\nSec-WebSocket-Version: 13\r\nSec-WebSocket-Protocol: /sc2api\r\nOrigin:http://127.0.0.1\r\n\r\n",

		--< Host:
		self.HOST,

		--< Port:
		self.PORT,

		--< Key:
		key
	)

	--< Success:
	local success, error = self.TCP:send(request)

	if not success then
		--< Logger:
		Logger.log_error("[!] Failed to send handshake: " .. tostring(error))

		--< Logic:
		return false
	end

	--< Response:
	local response, response_error = self:receive_until("\r\n\r\n", 8192)

	if not response then
		--< Logger:
		Logger.log_error("[!] Failed to read handshake response: " .. tostring(response_error))

		--< Logic:
		return false
	end

	--< Status:
	local status = response:match("HTTP/%d%.%d%s+(%d+)")

	if tonumber(status) ~= 101 then
		--< Logger:
		Logger.log_error("[!] Socket handshake failed: " .. tostring(status))
		Logger.log_error("[!] Response prefix: " .. Manipulation.bytes_to_hex(response:sub(1, 16)))

		--< Logic:
		return false
	end

	--< Acceptance:
	local acceptance = response:match("[Ss]ec%-[Ww]eb[Ss]ocket%-[Aa]ccept:%s*(.-)\r\n")

	if acceptance then
		--< Variables (Assignment):
		--< Expected:
		local expected = Cryptography.base64_encode(Cryptography.SHA1(key .. "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"))

		--< Logic:
		if acceptance:gsub("%s+", "") ~= expected then
			--< Logger:
			Logger.log_warning("[!] Socket accept mismatch!")
		end
	end

	--< Logger:
	Logger.log_information("[+] Socket handshake complete.")

	--< Logic:
	return true
end

function Socket:send(payload, code)
	--< Validation:
	if not self.TCP then
		--< Logger:
		Logger.log_error("[!] Socket was not initialized or failed initialization!")

		--< Logic:
		return false
	end

	--< Variables (Assignment):
	--< Operation:
	local operation = code or 0x02

	--< Final:
	local final = 0x80

	--< Mask:
	local mask_bit = 0x80

	--< Length:
	local length = #payload

	--< Header:
	local header = nil

	--< Logic:
	if length < 126 then
		--< Variables (Assignment):
		--< Header:
		header = string.char(final + operation, mask_bit + length)
	elseif length < 65536 then
		--< Variables (Assignment):
		--< Byte:
		local byte_1 = math.floor(length / 256) % 256
		local byte_2 = length % 256

		--< Header:
		header = string.char(final + operation, mask_bit + 126, byte_1, byte_2)
	else
		--< Variables (Assignment):
		--< Length:
		local length_64 = string.char(
			0, 0, 0, 0,
			(length >> 24) & 0xFF,
			(length >> 16) & 0XFF,
			(length >> 8)  & 0XFF,
			length 		   & 0xFF
		)

		--< Header:
		header = string.char(final + operation, mask_bit + 127) .. length_64
	end

	--< Mask:
	local mask = self:generate_random_bytes(4)

	--< Masked:
	local masked = Manipulation.mask_payload(payload, mask)

	--< Frame:
	local frame = header .. mask .. masked

	--< Success:
	local success, send_error = self.TCP:send(frame)

	if not success then
		--< Logger:
		Logger.log_error("[!] Failed to send socket frame: " .. tostring(send_error))

		--< Logic:
		return false
	end

	--< Logic:
	return true
end

function Socket:receive()
	--< Validation:
	if not self.TCP then
		--< Logger:
		Logger.log_error("[!] Socket was not initialized or failed initialization!")

		--< Logic:
		return false
	end

	--< Variables (Assignment):
	--< Header:
	local header, error = self:receive_exact(2)

	if not header then
		return nil, error
	end

	--< Variables (Assignment):
	--< Byte:
	local byte_1, byte_2 = header:byte(1, 2)

	--< Operation:
	local operation = byte_1 & 0x0F

	--< Masked:
	local masked = (byte_2 & 0x80) ~= 0

	--< Length:
	local length = byte_2 & 0x7F

	--< Logic:
	if length == 126 then
		--< Variables (Assignment):
		--< Extended:
		local extended, extended_error = self:receive_exact(2)

		if not extended then
			return nil, extended_error
		end

		--< Extended:
		local extended_1, extended_2 = extended:byte(1, 2)

		--< Length:
		length = (extended_1 * 256) + extended_2
	elseif length == 127 then
		--< Variables (Assignment):
		--< Extended:
		local extended, extended_error = self:receive_exact(8)

		if not extended then
			return nil, extended_error
		end

		--< Extended:
		local extended_1, extended_2, extended_3, extended_4,
		extended_5, extended_6, extended_7, extended_8
		= extended:byte(1, 8)

		--< Length:
		length = (extended_5 * 16777216) + (extended_6 * 65536) + (extended_7 * 256) + extended_8
	end

	--< Variables (Assignment):
	--< Mask:
	local mask = nil

	if masked then
		--< Variables (Assignment):
		--< Error:
		local mask_error = nil

		--< Mask:
		mask, mask_error = self:receive_exact(4)

		if not mask then
			return nil, mask_error
		end
	end

	--< Payload:
	local payload, payload_error = self:receive_exact(length)

	if not payload then
		return nil, payload_error
	end

	--< Logic:
	if masked and mask then
		--< Variables (Assignment):
		--< Payload:
		payload = Manipulation.mask_payload(payload, mask)
	end

	--< Payload:
	return payload, operation
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