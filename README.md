# kzgdz-parsh
KZGDZ.com parser written in BASH still in beta.
supports multiple books for 8 grade geometry and algebra.
### To install type following commands
```sh 
git clone https://github.com/USERMAN7/kzgdz-parsh.git
```
#### or checkout [github releases](https://github.com/USERMAN7/kzgdz-parsh/releases)

that's a bash script so nothing to compile!

### Dependicies
depends on `wget,bash` and thats it!
`busybox wget` sadly doesnt support https sites.`
### Help documentation
***

```
--help,-h    for this help menu
--out-dir,-O     to specify the output directory, "./main-parser.sh -O /sdcard/Pictures" for example
--interactive,-i    for interactive mode where you can type out which book and which exercise you want to download
--book,-b   note always needs to be first argument, example of use "./main-parser.sh --book chemistry" then exercise needs to be passed see below
--exercise,-e   needs to be passed after book arg see above for explanation. can be passed like --exercise 1.4 or -e 1.4 for some books like chemistry you need to pass paragraph first then exercise use -e 3.7
		example you can use it by typing "./main-parse.sh --book algebra -e 1.5 -O /sdcard/Pictures" 
--loop,-l	needs to passed after book similar to exercise arg.
		1st argument after loop needs to starting point,2nd argument
		is end point.
--compression,-j	can be passed as 6th or 5th argument. You need to specify
			compression level from 1-100 pass it as integer.
			Example of loop “./main-parse.sh -b imangali -l 4.20 4.50 -O /sdcard/Pictures/”
```
