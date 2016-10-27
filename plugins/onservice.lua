do
-- Will leave the group if be added
local function run(msg, matches)
local bot_id = our_id 
local receiver = get_receiver(msg)
    if matches[1] == 'leave' and is_admin1(msg) then
       chat_del_user("chat#id"..msg.to.id, 'user#id'..bot_id, ok_cb, false)
	   leave_channel(receiver, ok_cb, false)
end
	if matches[1] == "leave" and matches[2] and is_sudo(msg) then
			send_large_msg("channel#id"..matches[2],"ربات به دلایلی(انقضا,صلاحیت گپ,دستور مدیر)از گروه خارج میشود\n\nبرای اطلاع بیشتر به ربات پیام رسان زیر پیام بدید\nربات پیام رسان : @Solid021Pv_Bot")
      chat_del_user("chat#id"..matches[2], 'user#id'..bot_id, ok_cb, false)
      leave_channel("channel#id"..matches[2], ok_cb, false)
			return "ربات از گروه ["..matches[2].."] خارج شد"
end
    if msg.service and msg.action.type == "chat_add_user" and msg.action.user.id == tonumber(bot_id) and not is_admin1(msg) then
       send_large_msg(receiver, 'این گروه در سرور ثبت نشده\nبرای سفارش گروه یا ادد شدن ربات به گروهتون به ربات زیر پیام بدید\n@SoLiD021Pv_BoT.', ok_cb, false)
       chat_del_user(receiver, 'user#id'..bot_id, ok_cb, false)
	   leave_channel(receiver, ok_cb, false)
      block_user("user#id"..msg.from.id,ok_cb,false)
elseif msg.service and msg.action.type == 'chat_created' and not is_admin1(msg) then
       chat_del_user(receiver, 'user#id'..bot_id, ok_cb, false)
      block_user("user#id"..msg.from.id,ok_cb,false)
    end
end

return {
  patterns = {
    "^[#!/](leave)$",
    "^[#!/](leave)(.*)$",
    "^!!tgservice (.+)$",
  },
  run = run
}
end
