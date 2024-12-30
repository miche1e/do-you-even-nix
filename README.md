# Do you even nix?
A simple zsh-theme to enhance nix power.
This theme express his full potential if you often rely on Nix's features such as shells and flakes. That said, you can still enjoy it without Nix if you like.
## Appearence
This is how the theme will look like:
- normally;
![normal](https://raw.githubusercontent.com/miche1e/do-you-even-nix/refs/heads/main/pics/normal.png)
- when you enter a directory with a git repo. 
![git-repo-clean](https://raw.githubusercontent.com/miche1e/do-you-even-nix/refs/heads/main/pics/git-repo-clean.png)
Note how the current git user is shown. This comes handy when you have multiple remote repository's accounts like me and you are tired of committing stuff under the wrong user 😤;
- when you have something to commit;
![git-repo-dirty](https://raw.githubusercontent.com/miche1e/do-you-even-nix/refs/heads/main/pics/git-repo-dirty.png)
- when there's a *flake.nix* in the current directory;
![nix-flake-available](https://raw.githubusercontent.com/miche1e/do-you-even-nix/refs/heads/main/pics/nix-flake-available.png)
- when there's a *shell.nix* in the current directory;
![nix-shell-available](https://raw.githubusercontent.com/miche1e/do-you-even-nix/refs/heads/main/pics/nix-shell-available.png)
- when you enter a nix shell.
![nix-shell-active](https://raw.githubusercontent.com/miche1e/do-you-even-nix/refs/heads/main/pics/nix-shell-active.png)
This will activate when `$IN_NIX_SHELL` env variable is valued. As you can see there's also the shell name. You can assign the shell name to `pkgs.mkShell.name` if you like. If you don't it'll fall back to the default shell name *nix-shell-env* ("-env" is by default added by nix to the shell name).
## Installation
### The Nix way 🗿
1. Find where you defined zsh settings in your nix configuration files (could be either in your *configuration.nix* or in your *home.nix* if you're using home-manager). It will look something like this:
```nix
programs.zsh = {
  enable = true;
  plugins = [ ... ];
  ...
}
```
2. Add the following value into the `programs.zsh.plugins` square brackets:
```nix
{
  name = "do-you-even-nix";
  file = "do-you-even-nix.zsh-theme";
  src = pkgs.fetchFromGitHub {
    owner = "miche1e";
    repo = "do-you-even-nix";
    rev = "v1.0.1";
    sha256 = "n9QYjpXlGdLx6agwp14rwcc6Jr5+0E/2h/oMuFsveHA=";
  };
}
```
3. Apply the changes :)
### With oh-my-zsh
If oh-my-zsh is handling your plugins and themes.
1. Download* the theme file in in oh-my-zsh theme's folder:
```bash
wget 'https://raw.githubusercontent.com/miche1e/do-you-even-nix/refs/heads/main/do-you-even-nix.zsh-theme' -O $ZSH/themes/do-you-even-nix.zsh-theme
```
*If you don't have wget, using curl or cloning the whole project with git and moving the file manually will do the same.

2. Open your `~/.zshrc` file, look for the `ZSH_THEME` variable and set it as follows:
```bash
ZSH_THEME=do-you-even-nix
```
### Manual installation (git clone)
1. Clone the repo:
```shell
git clone https://github.com/miche1e/do-you-even-nix.git ~/.zsh/plugins/do-you-even-nix
```
2. Source the theme file in your `.zshrc`:
```shell
echo 'if [[ -f "$HOME/.zsh/plugins/do-you-even-nix/do-you-even-nix.zsh-theme" ]]; then
  source "$HOME/.zsh/plugins/do-you-even-nix/do-you-even-nix.zsh-theme"
fi' >> ~/.zshrc
```
## Personalization
do-you-even-nix have a bunch of variables where special chars and colors are defined. These variables, if not already set, fall back to a default value that you can look up in the theme's file. If you don't like how it looks you can override them to your preference in your `~/.zshrc` __before__ sourcing the theme's file.
```shell
# Icons setting.
DYEN_SEGMENT_SEPARATOR
DYEN_STARTING_CHAR
DYEN_PROMPT_CHAR
DYEN_BRANCH_ICON
DYEN_FLAKE_ICON
DYEN_SHELL_ICON
DYEN_SSH_ICON

# Color settings
DYEN_SSH_BG
DYEN_SSH_FG
DYEN_CONTEXT_BG
DYEN_CONTEXT_FG
DYEN_DIR_BG
DYEN_DIR_FG
DYEN_GIT_BG
DYEN_GIT_FG
DYEN_GIT_DIRTY_BG
DYEN_GIT_DIRTY_FG
DYEN_SHELL_BG
DYEN_SHELL_FG
DYEN_ACTIVE_SHELL_BG
DYEN_ACTIVE_SHELL_FG
```
Icons settings are just strings so you can set them, for example, like this:
```shell
DYEN_PROMPT_CHAR="\u1234"
DYEN_BRANCH_ICON="hello chad 🗿"
```
While colors takes shell colors like `white`, `red` or number values from `0` to `255`, for example:
```shell
DYEN_CONTEXT_BG=69
DYEN_CONTEXT_FG=green
```
