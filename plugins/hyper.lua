
local function run(msg, matches)
  local clickme = '<a href="'..matches[1]..'">'..matches[2]..'</a>'
    send_api_msg(msg.to.id, get_receiver_api(msg), clickme, true, 'html')
end

return {
  description = "Reply Your Sent Message",
  usage = "/echo (message) : reply message",
  patterns = {
    "^[!/#]hyper (.+) (.+)$"
  }, 
	run = run,
	moderated = true
}
