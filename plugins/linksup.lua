                                                                                 do

function run(msg, matches)
    local data = load_data(_config.moderation.data)
      local group_link = data[tostring(1055081276)]['settings']['set_link']
       if not group_link then
      return ''
       end
if matches[1]:lower() == "linksp" then
         local text = "لینک ساپورت ربات تله بیوند:\n"..group_link
            return reply_msg(msg.id, text, ok_cb, false)
end
if matches[1]:lower() == "linksup" then
         local text = 'ساپورت ربات تله بیوند'
local inline_text = "Tap_Here_To_Join_Support"
return send_api_msg(msg,get_receiver_api(msg),text,true,'md',inline_text,group_link)
end
end
return {
  patterns = {
    "^[/#!]([Ll]inksp)$",
    "^[/#!]([Ll]inksup)$"
  },
  run = run
}
end

