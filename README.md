# wpcLocator
## Overview

wpcLocator is a Bash script designed to check various HTTP headers of web pages to identify potential security vulnerabilities related to cache controls. It particularly focuses on Cache-Control headers, max-age headers, and x-Cache headers. The script aims to help identify situations where the cache may be manipulated or poisoned, potentially leading to security issues.
Features

    Cache-Control Analysis: wpcLocator analyzes the Cache-Control header to determine if it contains "public," indicating that the resource is publicly cached.

    Collaborator Integration: If the cache control is public, the script checks for a collaborator listener URL. If not provided, an error is displayed. If provided, wpcLocator injects an X-Forwarded-Host header with the collaborator's listener URL and checks if it appears in the response, potentially indicating cache poisoning.

    Max-Age and X-Cache Headers: The script also checks for the presence of Max-Age and X-Cache headers in the HTTP response.

## Usage

To use wpcLocator, follow these steps

Ensure you have Bash installed on your system.

Clone the repository

```
git clone https://github.com/your-username/wpcLocator.git
cd wpcLocator
```
Make the script executable
```
chmod +x wpcLocator.sh
```
Run the script with the following command
```
    ./wpcLocator.sh <hosts.file.txt> -collab <collaborator_listener_url>

        Replace <hosts.file.txt> with the path to a file containing a list of domain URLs you want to analyze.
        Replace <collaborator_listener_url> with the URL of the collaborator's listener.
```
## Example
```
./wpcLocator.sh domains.txt -collab http://collaborator-listener.com
```
