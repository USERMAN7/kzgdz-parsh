# kzgdz-parsh
KZGDZ.com parser written in BASH still in beta.
supports multiple books for 8 grade geometry and algebra.
### To install type following commands
```sh 
git clone https://github.com/USERMAN7/kzgdz-parsh.git
```
or checkout [github releases](https://github.com/USERMAN7/kzgdz-parsh/releases)

that's a bash script so nothing to compile!

### Dependicies
depends on `wget(busybox/coreutils),bash` and thats it!

### Help documentation
***

```
--help,-h    for this help menu
--out-dir,-O     to specify the output directory, "./main-parser.sh -O /sdcard/Pictures" for example
--interactive,-i    for interactive mode where you can type out which book and which exercise you want to download
--book,-b   note always needs to be first argument, example of use "./main-parser.sh --book chemistry" then exercise needs to be passed see below
--exercise,-e   needs to be passed after book arg see above for explanation. can be passed like --exercise 1.4 or -e 1.4 for some books like chemistry you need to pass paragraph first then exercise use -e 3.7
```
