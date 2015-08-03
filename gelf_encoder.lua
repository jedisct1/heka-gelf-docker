require "cjson"
require "os"
require "string"

local extra_properties = cjson.decode(read_config("extra_properties") or "{}")

function process_message()
    local version = "1.1"
    local ts = read_message("Timestamp") / 1e9
    local payload = read_message("Payload")
    local hostname = read_message("Hostname")
    local severity = read_message("Severity")
    local sd = read_message("Fields[structured-data]")

    local output = { version = version, host = hostname, timestamp = ts,
                     short_message = payload, level = severity }

    local type, name, value, representation, count = read_next_field()

    while name do
        if string.sub(name, 1, 1) == "_" then
            output[name] = value
        end
        type, name, value, representation, count = read_next_field()
    end

    for k, v in pairs(extra_properties) do output[k] = v end
    inject_payload("json", "output", cjson.encode(output))
    return 0
end
