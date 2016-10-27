local function run(msg,matches)
local text = matches[1]
  send_api_msg(msg, get_receiver_api(msg), text, true, 'md')
end
return {
description = "text to markdown",
usage = {
"!markdown *text* : text to bold",
"!markdown [text](link) : link to hyperlinkhyperlink",
"!markdown _text_ : text to italic",
},
patterns = {
"^[!/]md (.*)",
},
run = run 
}
