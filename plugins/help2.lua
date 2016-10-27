do

function run(msg, matches)
if msg.to.type == 'channel' and is_momod(msg) then
  return 'TeleBeyond Commands List'..[[
-----***** دستورات مدیریتی سوپر گروه *****-----


/settings : نمایش تنظیمات گروه
/stats : نمایش تعداد پیام های ارسالی توسط افراد در سوپر گروه
/setdesc <description> : ساخت درباره سوپر گروه
/setrules <rules> : ایجاد قوانین برای سوپر گروه
/newlink : ساخت لینک جدید
/setlink : ثبت لینک جدید
/link : لینک سوپر گروه
/linkpv : شما PV ارسال لینک سوپر گروه به
/setname <newname> : تقییر نام سوپر گروه
/setphoto : تغییر عکس سوپر گروه
/wlc enable : فعال کردن خوش امد گویی
/wlc disable : غیرفعال کردن خوش امد گویی
/lock|unlock tag : قفل/ازاد کردن استفاده از تگ
/lock|unlock spam : قفل/ازاد کردن متن های طولانی
/lock|unlock member : قفل/ازاد کردن اعضا
/lock|unlock link : فعال/غیرفعال کردن ضد تبلیغ
/lock|unlock bots : قفل/ازاد کردن ورود ربات ها
/lock|unlock strict : تنظیمات سخت گیرانه
/setflood <value> : تنظیم تعداد اسپم در گروه
/lock|unlock flood : فعال/ غیرفعال کردن ضد فلود
/public yes|no : عمومی کردن گروه
/mutelist : لیست فیلتر ها
/mute|unmute all : فعال/ غیرفعال کردن فیلتر همه
/mute|unmute text : فعال/ غیرفعال کردن فیلتر متن
/mute|unmute sticker : فعال/ غیرفعال کردن فیلتر استیکر
/mute|unmute photo : فعال/ غیرفعال کردن فیلتر عکس
/mute|unmute video : فعال/ غیرفعال کردن فیلتر فیلم
/mute|unmute audio : فعال/ غیرفعال کردن فیلتر فایل های صوتی
/mute|unmute gif : فعال/ غیرفعال کردن فیلتر Gif (عکس متحرک)
/mute|unmute contact : فعال/ غیرفعال کردن فیلتر اشتراک گذاری مخاطب
/mute|unmute doc : فعال/ غیرفعال کردن فیلتر فایل
/mute|unmute forward : فعال/ غیرفعال کردن فیلتر فروارد
/mute|unmute reply : فعال/ غیرفعال کردن فیلتر ریپلی
/mute|unmute service : فعال/ غیرفعال کردن فیلتر پیام ورود و خروج افراد
/badwords : دیدن لیست کلمات فیلتر شده
/addword <Word> : اضافه کردن کلمه به لیست کلمات فیلتر شده
/remword <Word> : حذف کردن کلمه از لیست کلمات فیلتر شده
/clearbw : حذف کردن تمامی کلمات از لیست کلمات فیلتر شده
(on Reply) /del : پاک کردن پیام
/bots : برای دیدن لیست ربات های درون سوپر گروه

-----***** دستورات مدیریت کاربران *****-----

/block : کیک کردن شخص از گروه
/block @user / userid : کیک کردن شخص از گروه با نام کاربری
/ban : اخراج کردن شخص از گروه
/ban @user / userid : اخراج شخص از گروه با نام کاربری
/banlist : لیست کاربران اخراج شده از گروه
/unban : خارج کردن از بن
/unban @user / userid : خارج کردن از بن 
/block : بلاک کردن فرد از گروه
/silentlist : شده Mute لیست افراد
/silent <id> : کردن فرد Mute|Unmute 
(on Reply) /promote : اضافه کردن مدیر
(on Reply) /demote : حذف کردن مدیر
(on Reply) /setadmin : اضافه کردن سرپرست
(on Reply) /demoteadmin : حذف کردن سرپرست
/clean [modlist|bots|rules|desc|banlist] : پاک کردن موارد مورد نظر

***برای سفارش به ربات پیام رسان زیر مراجعه کنید... 
با تشکر
@SoLiD021Pv_Bot
🔹🔸🔹🔸🔹🔸🔹🔸🔹🔸🔹
-•-•-•-•-•-•-•-•-•-•-•-•-•-•-
Team Channel : @BeyondTeam]]
end
end
return {
  description = "Robot and Creator About", 
  usage = "/ver : robot info",
  patterns = {
    "^[!/]help$",
    "^([Hh]elp)$",
    
  }, 
  run = run 
}

end
