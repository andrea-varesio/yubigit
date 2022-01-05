# yubigit

## What is it
It's a simple set of scripts that simplify the interaction of YubiKeys with GitHub.

## How to use it
### Initial Setup
Launch `./setup.sh` to register a YubiKey. If you have more than one, you can run it again and all the info will be saved in `variables.sh`.
This step is required only when first registering a YubiKey.

### Generating / importing resident SSH keys
Instead of using `gpg-agent` as suggested on [YubiKey-Guide](https://github.com/drduh/YubiKey-Guide) I went the [Yubico route](https://www.yubico.com/blog/github-now-supports-ssh-security-keys/).

By launching `./ssh-rk-gen.sh` you can either generate a resident key or import an existing key from the YubiKey.

### Pushing new repos
If you've created a repo online, run `./add-repo.sh`. You'll be asked the name of the repo, and then all you'll have to do is move the files into the specified directory, then press enter to push.

Very simple.

Contributions are welcome, feel free to contact me for any question or suggestion.
