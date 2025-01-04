# Tasks
- [ ] Determine latest C&C CA release from Github
  ```bash
  curl --silent "https://api.github.com/repos/Inq8/CAmod/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'
  ```
- [ ] Enhance `README.md` - `tl;dr` section
- [ ] Add script for `tl;dr`
- [ ] Add infos for Log-Files & Maps
- [ ] Add healthcheck
  ```bash
  for prc in /proc/*/cmdline; {  (printf "$prc "; cat -A "$prc") | sed 's/\^@/ /g;s|/proc/||;s|/cmdline||' | grep dotnet bin/OpenRA.Server.dll ; echo -n;  }
  ```