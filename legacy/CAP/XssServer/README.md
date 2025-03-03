# XSS Validation Server

Runs a JavaScript environment to verify natively whether an XSS exploit is
present within a web page. The XSS should generate a pop up alert for it to be
detected.

The detection engine exposes a web API which can be queried to deduce whether a
given web page contains an XSS exploit.

## API Spec

### Request
```
POST /
```
#### Request Headers
`X-Wargames-XSS-Name`: Free-form text.

`X-Wargames-XSS-Input`: The input string entered by the user on page

`X-Wargames-XSS-Output`: Can be regular text or regex. This will be replaced by
the user input
#### Request Body
The page source (html)

### Response

A json object will be returned. The syntax of this json is
```
{
    input: <the user input string passed>
    output: <the full page that was tested>
    xss: <boolean true or false; true = XSS detected; false = no XSS detected>
}
```

## Running the server

Open a command prompt in this directory and execute the following.

### Windows
```
phantomjs.exe xss_validator.js
```

### Linux (64-bit)
```
./phantomjs xss_validator.js
```

Note that the default port to access the web api is 8000. If you wish to change
this, supply a different port number with the `-p` switch, e.g.
```
./phantomjs xss_validator.js -p 9999
```
