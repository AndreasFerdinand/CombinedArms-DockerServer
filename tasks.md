# Tasks
- [x] Determine latest C&C CA release from Github
- [x] Enhance `README.md` - `tl;dr` section
- [x] Add script for `tl;dr`
- [ ] Add infos for Log-Files & Maps
- [ ] Add healthcheck
  ```bash
  for prc in /proc/*/cmdline; {  (printf "$prc "; cat -A "$prc") | sed 's/\^@/ /g;s|/proc/||;s|/cmdline||' | grep dotnet bin/OpenRA.Server.dll ; echo -n;  }
  ```