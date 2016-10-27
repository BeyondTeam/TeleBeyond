do

function run(msg, matches)
 
	if msg.to.type == 'chat' or msg.to.type == 'channel' and is_momod(msg) then
  return [[-----***** دستورات مدیریتی سوپر گروه *****-----\n\n/settings : نمایش تنظیمات گروه\n/stats : نمایش تعداد پیام های ارسالی توسط افراد در سوپر گروه\n/setdesc <description> : ساخت درباره سوپر گروه\n/setrules <rules> : ایجاد قوانین برای سوپر گروه\n/newlink : ساخت لینک جدید\n/setlink : ثبت لینک جدید\n/link : لینک سوپر گروه\n/linkpv : شما PV ارسال لینک سوپر گروه به\n/setname <newname> : تقییر نام سوپر گروه\n/setphoto : تغییر عکس سوپر گروه\n/lock|unlock tag : قفل/ازاد کردن استفاده از تگ\n/lock|unlock spam : قفل/ازاد کردن متن های طولانی\n/lock|unlock member : قفل/ازاد کردن اعضا\n/lock|unlock link : فعال/غیرفعال کردن ضد تبلیغ\n/lock|unlock bots : قفل/ازاد کردن ورود ربات ها\n/lock|unlock strict : تنظیمات سخت گیرانه\n/setflood <value> : تنظیم تعداد اسپم در گروه\n/lock|unlock flood : فعال/ غیرفعال کردن ضد فلود\n/public yes|no : عمومی کردن گروه\n/mutelist : لیست فیلتر ها\n/mute|unmute all : فعال/ غیرفعال کردن فیلتر همه\n/mute|unmute text : فعال/ غیرفعال کردن فیلتر متن\n/mute|unmute sticker : فعال/ غیرفعال کردن فیلتر استیکر\n/mute|unmute photo : فعال/ غیرفعال کردن فیلتر عکس\n/mute|unmute video : فعال/ غیرفعال کردن فیلتر فیلم\n/mute|unmute audio : فعال/ غیرفعال کردن فیلتر فایل های صوتی\n/mute|unmute gif : فعال/ غیرفعال کردن فیلتر Gif (عکس متحرک)\n/mute|unmute contact : فعال/ غیرفعال کردن فیلتر اشتراک گذاری مخاطب\n/mute|unmute doc : فعال/ غیرفعال کردن فیلتر فایل\n/mute|unmute forward : فعال/ غیرفعال کردن فیلتر فروارد\n/mute|unmute service : فعال/ غیرفعال کردن فیلتر پیام ورود و خروج افراد\n/badwords : دیدن لیست کلمات فیلتر شده\n/addword <Word> : اضافه کردن کلمه به لیست کلمات فیلتر شده\n/remword <Word> : حذف کردن کلمه از لیست کلمات فیلتر شده\n/clearbw : حذف کردن تمامی کلمات از لیست کلمات فیلتر شده\n(on Reply) /del : پاک کردن پیام\n/bots : برای دیدن لیست ربات های درون سوپر گروه\n\n-----***** دستورات مدیریت کاربران *****-----\n\n/block : کیک کردن شخص از گروه\n/block @user / userid : کیک کردن شخص از گروه با نام کاربری\n/ban : اخراج کردن شخص از گروه\n/ban @user / userid : اخراج شخص از گروه با نام کاربری\n/banlist : لیست کاربران اخراج شده از گروه\n/unban : خارج کردن از بن\n/unban @user / userid : خارج کردن از بن\n/silentlist : شده Mute لیست افراد\n/silent <id> : کردن فرد Mute|Unmute\n(on Reply) /promote : اضافه کردن مدیر\n(on Reply) /demote : حذف کردن مدیر\n(on Reply) /setadmin : اضافه کردن سرپرست\n(on Reply) /demoteadmin : حذف کردن سرپرست\n/clean modlist : حذف کردن تمامی مدیران از لیست مدیریت\n\n***برای سفارش به ربات پیام رسان زیر مراجعه کنید... \nبا تشکر\n@SoLiD021Pv_Bot\n🔹🔸🔹🔸🔹🔸🔹🔸🔹🔸🔹\n-•-•-•-•-•-•-•-•-•-•-•-•-•-•-\nTeam Channel : @BeyondTeam]]
end
end
return {
  description = "Robot About", 
  usage = "help: View Robot About",
  patterns = {
    "^[#!/]test$"
    }, 
  run = run 
}

end
