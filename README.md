# yubigit

## What is it
It's a simple set of tools that simplifies and automates the use of `git` with YubiKeys.

## How to use it
### Initial Setup
Launch `./setup.sh` to register a YubiKey. If you have more than one, you can run it again and all the info will be saved in `variables.sh`.
This step is required only when first registering a YubiKey.
More specifically, it'll automatically discover the serial number of the YubiKey (used to identify it when you run the following scripts) as well as the PGP key associated to it (if there is one). This info will be passed when needed by the other scripts (ie. for signing commits).

### Generating / importing resident SSH keys
Instead of using `gpg-agent` as suggested on the great [YubiKey-Guide](https://github.com/drduh/YubiKey-Guide) I went the [Yubico route](https://www.yubico.com/blog/github-now-supports-ssh-security-keys/).

By launching `./ssh-rk-gen.sh` you can either generate a resident key or import an existing key from the YubiKey.

### Pushing new repos
If you've created a repo online, plug in your YubiKey and run `./add-repo.sh`. You'll be asked the name of the repo, and then all you'll have to do is move the files into the specified directory, then press enter to push. If during the initial set up you've chosen to register the PGP key automatically discovered on the YubiKey (or the one indicated by you), this commit will also be signed.

By passing the `-n` argument, the script will only show one necessary prompt, while all others will assume the default choices have been selected (ie. `./add-repo.sh -n`).

You can also pass as argument the name of the repository (ie. `./add-repo.sh MyNewRepo`).

Both arguments can be passed in the same command (ie. `./add-repo.sh -n MyNewRepo`). This will initiate a new repository called `MyNewRepo` in the default directory specified during the initial setup, while also not showing any unnecessary confirmation prompts.

It's all very simple.

For ease of use you can create a symbolic link in your `$HOME` with `ln -s /path/to/add-repo.sh ~/`.

## Contributions
Contributions are welcome, feel free to submit issues and/or pull requests.

### To-Do


### Known issues


## LICENSE

GNU GENERAL PUBLIC LICENSE
Version 3, 29 June 2007

"yubigit" - Set of tools used to automate the use of git with YubiKeys.
Copyright (C) 2022 Andrea Varesio <https://www.andreavaresio.com/>.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
