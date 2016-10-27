local function run(msg, matches)
local hash = 'kick:'..msg.to.id..':'..msg.from.id
 if matches[1] == 'kickme' and redis:get(hash) == nil then
    local data = load_data(_config.moderation.data)
    if data[tostring(msg.to.id)]['settings']['kickme'] == '❌' then
    return reply_msg(msg.id, 'این دستور در این سوپرگروه غیرفعال است.', ok_cb, true)
  else
      redis:set(hash, "waite")
      return reply_msg(msg.id, 'شما از دستور '..msg.text..' استفاده کردید!!\nاگر با درخواست اخراج خود موافقید دستور yes را ارسال کنید\nو برای لغو از دستور no استفاده کنید.', ok_cb, true)
    end

 end
		 if msg.text then
		 if msg.text:match("^yes$") and redis:get(hash) == "waite" then
	redis:set(hash, "ok")
    elseif msg.text:match("^no$") and redis:get(hash) == "waite" then
	send_large_msg(get_receiver(msg), "دستور اخراج لغو شد.")
				redis:del(hash, true)
      end
    end

	 if redis:get(hash) then
        if redis:get(hash) == "ok" then
	     redis:del(hash, true)
         channel_kick("channel#id"..msg.to.id, "user#id"..msg.from.id, ok_cb, false)
         return 'یوزرنیم [@'..(msg.from.username or '---')..'] بنابر درخواست خود از گروه ('..msg.to.title..') اخراج شد'
        end
      end
    end

return {
  patterns = {
  "^[#!/]([Kk]ickme)$",
  "no",
  "^yes$"
  },
  run = run,
}
