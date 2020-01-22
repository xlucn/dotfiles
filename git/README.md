## git-autofetch

Apart from my own git configurations, there is some scripts and services files that automatically manages multiple git repos.

You can:

- See in bash prompt how many repos has new commits in the remote branch (remind you need to git pull)
- Run a command `git-autostats` to show slightly more details of commits ahead/behind about all your repos.
- Automatically and periodically fetch (not pull) new commits for all your repos.

You need to:

- Put the files here in folder `.config/systemd/user/` and `.local/bin` to the same path under your home directory.
- Put the paths of all the repos you want to track to `$HOME/.config/git-autofetch`, one in each line. You can search for them with `$ find /path -name .git -type d`
- Use my `.bashrc` file or embed the `__git_autofetch` function to your shell prompt.
- Enable and start the `git-autofetch` user systemd unit.

What's happening under the hood:

- The `git-autofetch` script goes through the paths on every line in `$HOME/.config/git-autofetch` and do `git fetch` in that directory.

- The `git-autostats` script does two things:

  1. Print a concise summary of how many commits are ahead of / behind the tracking branch for the repos in `$HOME/.config/git-autofetch` file.

  2. Store the status above in a temporary file in `/tmp` to use in a shell prompt function in bash. See function `__git_autostats` in my `.bashrc`.

- The `git-autofetch.service/time` files set a systemd service/timer to automatically execute the `git-autofetch` script periodically.

- (External) The function `__git_autofetch` in `.bashrc` file shows the number of repos that are: up-to-date, outdated (commits not merged), updated (commits not pushed) and complicated (commits not merged and not pushed).
