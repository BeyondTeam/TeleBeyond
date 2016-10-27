local function tosticker(msg, success, result)
  local receiver = get_receiver(msg)
  if success then
    local user_id = msg.from.id
    local file = './info/'..user_id..'.webp'
    print('File downloaded to:', result)
    os.rename(result, file)
    print('File moved to:', file)
    send_document(get_receiver(msg), file, ok_cb, false)
	send_large_msg(receiver, 'استیکر برای '..msg.from.id..' ثبت شد.', ok_cb, false)
    redis:del("sticker:setsticker")
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, 'Failed, please try again!', ok_cb, false)
  end
end
local function run(msg,matches)
    local receiver = get_receiver(msg)
    local group = msg.to.id
    if msg.media then
       if msg.media.type == 'document' and redis:get("sticker:setsticker") then
        if redis:get("sticker:setsticker") == 'waiting' then
          load_document(msg.id, tosticker, msg)
        end
       end
    end
    if matches[1] == "setsticker" then
     redis:set("sticker:setsticker", "waiting")
     return 'اکنون استیکر مورد نظر خود را ارسال کنید.'
    end
	if matches[1]:lower() == 'mysticker' then --Your bot name
	send_document(get_receiver(msg), "./info/"..msg.from.id..".webp", ok_cb, false)
end
end
return {
  patterns = {
 "^[!#/](setsticker)$",
 "^[!#/]([Mm]ysticker)$",
 "%[(document)%]",
  },
  run = run,
}
