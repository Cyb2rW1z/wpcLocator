#!/bin/bash

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

check_headers() {
    url=$1
    headers=$(curl -sI "$url")

    cache_control=$(echo "$headers" | grep -i "Cache-Control")
    max_age=$(echo "$headers" | grep -i "max-age")
    x_cache=$(echo "$headers" | grep -i "x-Cache")

    echo "URL: $url"

    if [[ $cache_control == *"public"* ]]; then
        echo -e "${RED}Cache-Control: Public${NC}"

        if [ -z "$collaborator_listener" ]; then
            echo -e "${RED}Error: Collaborator listener URL is required.${NC}"
            exit 1
        fi

        echo -e "${GREEN}Collaborator (listener): $collaborator_listener${NC}"

        curl_headers="-H 'X-Forwarded-Host: $collaborator_listener'"
        echo -e "${GREEN}Injected Header: X-Forwarded-Host: $collaborator_listener${NC}"

        source_with_header=$(curl -sI "$url" $curl_headers)

        if [[ $source_with_header == *"$collaborator_listener"* ]]; then
            echo -e "${GREEN}The URL might be vulnerable to cache-poisoning. Valid issue reported.${NC}"
        else
            echo -e "${RED}Injected header not found in the response.${NC}"
        fi
    fi

    [[ -n $max_age ]] && echo "Max-Age Header: $max_age"
    [[ -n $x_cache ]] && echo "X-Cache Header: $x_cache"

    echo "-------------------------"
}

if [ "$#" -lt 3 ]; then
    echo "Usage: $0 <hosts.file.txt> -collab <collaborator_listener_url>"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo -e "${RED}Error: File $1 not found.${NC}"
    exit 1
fi

collaborator_listener=""

while [ "$#" -gt 0 ]; do
    case "$1" in
        -collab)
            collaborator_listener="$2"
            shift 2
            ;;
        *)
            file_path="$1"
            shift
            ;;
    esac
done

while IFS= read -r domain; do
    check_headers "$domain"
done < "$file_path"
