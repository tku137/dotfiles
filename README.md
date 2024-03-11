# Dotfiles Management with GNU Stow

This guide provides instructions on how to use GNU Stow for managing your dotfiles. Stow is a symlink farm manager that makes it easy to manage project installations in your home directory.

## Installing GNU Stow

### On macOS:

Use Homebrew to install Stow:

```bash
brew install stow
```

### On Ubuntu/Debian:

Use APT to install Stow:

```bash
sudo apt-get update && sudo apt-get install stow
```

## Cloning This Dotfiles Repository

```bash
git git@github.com:tku137/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

## Using Stow to Manage Your Dotfiles

Navigate to the dotfiles directory and use Stow to symlink the dotfiles to the home directory.

```bash
cd ~/dotfiles
stow folder_name
```

Replace `folder_name` with the name of the folder containing the dotfiles you want to manage.

For example, to stow `fish` and `starship` configuration, call:

```bash
cd ~/dotfiles
stow fish starship
```

### Common Stow Commands

- To symlink files/folders:

```bash
stow folder_name
```

- To remove symlinks:

```bash
stow -D folder_name
```

- To restow (useful for updating symlinks):

```bash
stow -R folder_name
```

### Using the `--adopt` Flag

The `--adopt` flag is used to tell Stow to adopt existing files into the Stow package. This means that if a file already exists in the target location, Stow will move it into the Stow package directory and create a symlink in its place.

**Use with caution**, as this will move the existing files into the Stow directory.

```bash
stow --adopt folder_name
```
