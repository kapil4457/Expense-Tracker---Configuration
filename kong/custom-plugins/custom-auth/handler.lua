local kong = kong
local http = require "resty.http"

local CustomAuthHandler = {
  PRIORITY = 1000,
  VERSION = "1.0",
}

function CustomAuthHandler:access(config)
  -- Use the auth_service_url from the configuration
  local auth_service_url = config.auth_service_url
  -- Call auth service
  local httpc = http.new()
  httpc:set_timeouts(10000, 10000, 10000)
  kong.log.debug("request: ", kong.request.get_header("Authorization"))
  local res, err = httpc:request_uri(auth_service_url, {
    method = "GET",
    headers = {
      ["Authorization"] = kong.request.get_header("Authorization")
    }
  })
  
  if not res then
    kong.log.err("Failed to call auth service: ", err)
    return kong.response.exit(500, { message = "Internal Server Error" })
  end
  
  if res.status ~= 200 then
    return kong.response.exit(res.status, { message = "Unauthorized" })
  end
  
  local user_id = res.body
  kong.log.debug("Auth service returned user_id: ", user_id)
  -- If authenticated, add user_id to headers and continue
  kong.service.request.set_header("X-User-Id", user_id)

end

return CustomAuthHandler
