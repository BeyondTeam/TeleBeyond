local helpers = require "OAuth.helpers"
local base = "https://screenshotmachine.com/"
local url = base.."processor.php"
local function get_webshot_url()
	local response_body = {}
	local request_constructor = {
		url = url,
		method = "GET",
		sink = ltn12.sink.table(response_body),
		headers = {
			referer = base,
			dnt = "1",
			origin = base,
			["User-Agent"] = "Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.101 Safari/537.36"
		},
		redirect = false
	}
	local arguments = {
		urlparam = "http://umbrella.shayan-soft.ir/t2i/"..tarurlt2i,
		size = "FULL"
	}
	request_constructor.url = url .. "?" .. helpers.url_encode_arguments(arguments)
	local ok, response_code, response_headers, response_status_line = https.request(request_constructor)
	if not ok or response_code ~= 200 then
		return nil
	end
	local response = table.concat(response_body)
	return string.match(response, "href='(.-)'")
end

local function run(msg, matches)
	receiver = get_receiver(msg)
	if matches[1] == "/t2i," then
		local text = matches[3]:gsub("!#", "<font color=")
		local text = text:gsub("!1", "<font style='font-size:50'")
		local text = text:gsub("!2", "<font style='font-size:100'")
		local text = text:gsub("!3", "<font style='font-size:150'")
		local text = text:gsub("!4", "<font style='font-size:200'")
		local text = text:gsub("!5", "<font style='font-size:300'")
		tarurlt2i = "2.php?bg="..matches[2].."&text="..URL.escape(text)
	elseif matches[1] == "/t2i" then
		local text = matches[2]:gsub("!#", "<font color=")
		local text = text:gsub("!1", "<font style='font-size:50'")
		local text = text:gsub("!2", "<font style='font-size:100'")
		local text = text:gsub("!3", "<font style='font-size:150'")
		local text = text:gsub("!4", "<font style='font-size:200'")
		local text = text:gsub("!5", "<font style='font-size:300'")
		tarurlt2i = "1.php?text="..URL.escape(text)
	end
	local find = get_webshot_url()
	if find then
		local imgurl = base..find
		return send_photo_from_url(receiver, imgurl)
	end
end

return {
	description = "Text to Photo Convertor",
	usagehtm = '<tr><td align="center">/t2i فرمول</td><td align="right">این پلاگین جهت تبدیل متن به عکس به صورت پیشرفته است. فرمول نویسی در این پلاگین به روش زیر است<br>برای تعیین رنگ متن یا کلمه از این دستور استفاده کنید:<br>!#-----><br>به جای ----- کد رنگ یا نام رنگ را وارد کنید، مثال:<br>!#blue> !#cc0030><br>برای سایز متن یا کلمه از 5 حالت میتوانید استفاده کنید:<br>!1> !2> !3> !4> !5><br>برای کلفت نویسی کلمه را بین تگ B قرار دهید:<br>< b >WORD</ b ><br>برای کج نویسی از تگ i و برای خط دار نویسی از تگ U استفاده کنید:<br>< i >WORD</ i ><br>< u >WORD</ u ></td></tr>'
	..'<tr><td align="center">/t2i,فرمول رنگ</td><td align="right">با قرار دادن کد یا نام رنگ میتوانید رنگ زمینه را نیز تعریف کنید</td></tr>',
	usage = {admin = {"/t2i (algoritm) : تبدیل متن به عکس پیشرفته",},},
	patterns = {
		"^(/t2i,)([^%s]+) (.*)$",
		"^(/t2i) (.*)$",
		},
	run = run,
	privileged = true
}