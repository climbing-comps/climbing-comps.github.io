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
	url=$( sed -e 's|^[^/]*//||' -e 's|/.*$||' <<< "${url}" )
	#echo "starting scan for competitions"
	for link in ${links[@]}; do
		href=$(sed -n 's/.*href="\([^"]*\).*$/\1/p' <<< "${link}")
		#echo "checking ${href} for hints of competition"
		for allowed in ${whitelist[@]}; do
			allowed="$(echo -e "${allowed}" | tr -d '[:space:]')"
			#echo "we might have one!"
			#echo "checking if links bogus"
			if [[ $href = *"${allowed}"* ]]; then
				for disallowed in ${blacklist[@]}; do
					disallowed="$(echo -e "${disallowed}" | tr -d '[:space:]')"
					if [[ $href != *"${disallowed}"* ]]; then
						if [[ $href = *"${url}"* ]]; then
							if [[ ! " ${competitions[@]} " =~ " ${href} " ]]; then
								competitions+=("${href}")
							fi
						else
							if [[ ! " ${competitions[@]} " =~ " ${url}${href} " ]]; then
								competitions+=("${url}${href}")
							fi
						fi
					fi
				done
			fi
		done
	done
done

echo "Found ${#competitions[@]} possible competitions:"
for competition in ${competitions[@]}; do
	echo "Create event for ${competition}? (yes/no)"
	read response
	if [ 'yes' == $response ]; then
		echo "Enter external URL (currently: ${competition})"
		read response
		if [[ '' != $response ]]; then
			competition=$response
		fi
		echo "Enter title"
		read title
		echo "Enter date (format:YYYY-MM-DD)"
		read date
		echo "Enter month (full month name)"
		read month
		echo "Enter venue"
		read venue
		echo "Enter time (enter ?? if unknown)"
		read when
		echo "Creating event, review before committing to repo"
		post_title=$( tr '[:upper:]' '[:lower:]' <<< "${title}" )
		post_title=$( tr " " "-" <<< "${post_title}" )
		touch "_posts/${date}-${post_title}.md"
		printf -- "---\n" >> _posts/${date}-${post_title}.md
		printf "layout: post\n" >> _posts/${date}-${post_title}.md
		printf "title: ${title}\n" >> _posts/${date}-${post_title}.md
		printf "month: ${month}\n" >> _posts/${date}-${post_title}.md
		printf "venue: ${venue}\n" >> _posts/${date}-${post_title}.md
		printf "time: ${when}\n" >> _posts/${date}-${post_title}.md
		printf "link: ${competition}\n" >>_posts/${date}-${post_title}.md
		printf -- "---" >> _posts/${date}-${post_title}.md
		echo "Event created successfully for ${title}"
	else
		echo "Skipping to next event"
	fi
done