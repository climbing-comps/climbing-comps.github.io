#!/usr/bin/env bash
IFS=';'
#echo "loading URLs"
urls=$(<blog_urls.csv)
whitelist=$(<whitelist.csv)
blacklist=$(<blacklist.csv)
competitions=()
for url in ${urls[@]}; do
	url="$(echo -e "${url}" | tr -d '[:space:]')"
	#echo "retrieving links from ${url}"
	links=$(curl "${url}" | hxnormalize -x | hxselect -s ';' 'a' )
	#echo "starting scan for competitions"
	for link in ${links[@]}; do
		href=$(sed -n 's/.*href="\([^"]*\).*$/\1/p' <<< "${link}")
		#echo "checking ${href} for hints of competition"
		for allowed in ${whitelist[@]}; do
			allowed="$(echo -e "${allowed}" | tr -d '[:space:]')"
			#echo "we might have one!"
			#echo "checking if links bogus"
			if [[ "$allowed" == *"$href"* ]]; then
				for disallowed in ${blacklist[@]}; do
					disallowed="$(echo -e "${disallowed}" | tr -d '[:space:]')"
					if [[ "$disallowed" != *"$href"* ]]; then
						competitions+="${url}${href}"
					fi
				done
			fi
		done
	done
done
for competition in ${competitions[@]}; do
	echo $competition
done