#!/usr/bin/env bash
red='\033[0;31m'             #  red
grn='\033[0;32m'             #  green
ylw='\033[0;33m'             #  yellow
blu='\033[0;34m'             #  blue
ppl='\033[0;35m'             #  purple
cya='\033[0;36m'             #  cyan
bold=$(tput bold)
DAY="$(date +%d/%m/%Y)"

API_TOKEN=" "
USERNAME=" "

base_url="https://raw.githubusercontent.com/ProjectSakura/OTA/11"
download_url="https://projectsakura.xyz/download"
blog_url="https://projectsakura.xyz/blog"
website_url="https://projectsakura.xyz"

echo -e ${ylw}"Enter device codename"
read device_codename
echo -e " "
echo -e ${ylw}"Enter Maintainer(s) Name"
read device_maintainer
echo -e " "
echo -e ${ylw}"Enter build type"
read build_type
echo -e " "

echo -e ${cya}"Getting OTA json....."
wget -q ${base_url}/${device_codename}.json

echo -e ${ppl}"Generating msg......."
msg=$(mktemp)
{
echo -e "================================="
echo -e "                  <b>PROJECT SAKURA 5.1</b>" 
echo -e "                       <b>NEW UPDATE</b>"
echo -e "================================="
echo -e " "
echo -e "<b>👤 Maintainer:</b>      $device_maintainer"
echo -e "<b>📱 Device:</b>              $device_codename"
echo -e "<b>📆 Date:</b>                 $(date +%d/%m/%Y)"
echo -e "<b>❕ Variant:</b>             $build_type"
#md5sum=($(jq -r '.response[0].id' ${device_codename}.json))
#echo -e "ID:$md5sum"
size=($(jq -r '.response[0].size' ${device_codename}.json))
normal_size=($(echo $size/1024/1024 | bc))
echo -e "<b>📂 Size:</b>                   ${normal_size}MB"
echo -e "<b>⬇ ️Download:</b>        <a href=\"${download_url}\">Download Link</a>"
echo -e "<b>📰 Blog:</b>                   <a href=\"${blog_url}\">Blog</a>"
echo -e "<b>🌐 Website:</b>            <a href=\"${website_url}\">Website</a>"
echo -e " "
echo -e "#$device_codename #update #projectsakura"
} > "${msg}"

echo -e ${red}"Sending to Telegram....."
BJSON=$(cat "${msg}")
function sendTG() {
   curl -s "https://api.telegram.org/bot${API_TOKEN}/sendmessage" --data "text=${*}&chat_id=${USERNAME}&parse_mode=HTML" > /dev/null
}
MESSAGE=$(cat "${msg}")
sendTG "$MESSAGE"
rm -rf $device_codename.json
echo -e ${grn}"IT'S DONE!!"
