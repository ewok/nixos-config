# Agent Coding Guidelines for NixOS Configuration

This repository contains a personal NixOS/Home Manager configuration written in Nix. It manages system configurations and user environments declaratively across multiple machines and platforms (Linux, macOS, Android).

## Project Structure

```
nixos-config/
├── flake.nix              # Main flake entry point with system configurations
├── flake.lock             # Dependency lock file (auto-generated)
├── machines/              # Machine-specific configurations
│   ├── bup/               # x86_64-linux NixOS desktop
│   ├── droid/             # aarch64-linux Android (Nix-on-Droid)
│   ├── lgo/               # x86_64-linux Home Manager only
│   ├── mac/               # aarch64-darwin macOS
│   ├── orb/               # aarch64-linux NixOS server
│   └── rpi/               # aarch64-linux Raspberry Pi
├── modules/
│   ├── hm/                # Home Manager modules
│   │   ├── shell/         # Shell configurations (fish, nushell, bash)
│   │   ├── neovim/        # Neovim configuration
│   │   ├── git/           # Git configuration
│   │   ├── terminal/      # Terminal emulator configs
│   │   ├── wm/            # Window manager configs
│   │   └── [other tools]
│   └── nixos/             # NixOS system modules
├── overlays/              # Nix package overlays
└── utils/                 # Utility functions and libraries
```

## Build Commands

### Development Environment
```bash
# Enter development shell (includes all tools)
nix develop

# Or using direnv (automatically activates)
direnv allow
```

### Build Commands (using the `nn` wrapper script)
```bash
# Build specific machine configuration
nn b lgo        # Build Home Manager config for lgo
nn b bup        # Build NixOS config for bup
nn b orb        # Build NixOS config for orb (aarch64)
nn b mac        # Build Darwin config for mac
nn b droid      # Build Nix-on-Droid config
nn b rpi        # Build Home Manager config for rpi

# Switch to configuration (build + activate)
nn s lgo        # Switch to Home Manager config
nn s bup        # Switch to NixOS config (requires sudo)
nn s mac        # Switch to Darwin config (requires sudo)
```

### Maintenance Commands
```bash
nn clean        # Garbage collect and clean nix store
nn update       # Update flake inputs
nn repair       # Verify and repair nix store
nn crypt        # Check git-crypt status
```

### Manual Nix Commands
```bash
# Build without switching
nix build .#homeConfigurations.lgo.activationPackage
nix build .#nixosConfigurations.bup.config.system.build.toplevel

# Check flake
nix flake check

# Update specific input
nix flake lock --update-input nixpkgs-unstable

# Show flake info
nix flake show
```

## Code Style Guidelines

### Nix Language Conventions

#### File Structure
- Use `{ config, lib, pkgs, ... }:` parameter pattern
- Import `inherit` declarations at the top of `let` blocks
- Organize imports: `inherit (lib)` first, then `inherit (pkgs)`
- Use descriptive variable names in `let` bindings

#### Formatting and Style
- **Indentation**: 2 spaces (no tabs)
- **Line Length**: Aim for 80-100 characters, break long expressions
- **Semicolons**: Required after expressions and attribute sets
- **Brackets**: Space after opening `{` and before closing `}`
- **Lists**: Use trailing commas for multi-line lists
- **Comments**: Use `#` for single line, prefer inline documentation

#### Example Good Style:
```nix
{ config, lib, pkgs, utils, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption types;
  inherit (pkgs) writeShellScriptBin symlinkJoin;
  
  cfg = config.opt.shell;
  vars = {
    darwin = cfg.darwin;
    homeDirectory = cfg.homeDirectory;
    shell = cfg.shell;
  };
in
{
  options.opt.shell = {
    enable = mkEnableOption "shell configuration";
    shell = mkOption {
      type = types.str;
      default = "fish";
      description = "The shell to use";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      fzf
      zoxide
      eza
    ];
  };
}
```

#### Naming Conventions
- **Files**: kebab-case (`default.nix`, `shell-tools.nix`)
- **Attributes**: camelCase (`homeDirectory`, `enableFeature`)
- **Options**: camelCase with descriptive names
- **Variables**: camelCase for simple vars, descriptive for complex ones
- **Functions**: camelCase (`mkShellScript`, `buildConfig`)

#### Module Structure
- Start with options definition using `mkOption` and `mkEnableOption`
- Use `mkIf cfg.enable` to conditionally enable configurations
- Organize config sections logically: `home.packages`, then `programs.*`, then `services.*`
- Keep machine-specific overrides in `machines/` directory

### Error Handling
- Use descriptive error messages with `builtins.throw`
- Validate inputs with `assert` statements for critical conditions
- Use `lib.optional` and `lib.optionalAttrs` for conditional inclusion
- Prefer `mkIf` over manual conditionals for better evaluation

### Import Management
- Use explicit imports: `imports = [ ./module1.nix ./module2.nix ];`
- Avoid wildcard imports unless necessary
- Keep related functionality in single modules
- Use `utils` parameter for custom utility functions

### Configuration Patterns
- Use the `opt.*` namespace for custom options
- Create reusable components in `modules/hm/`
- Keep secrets in separate encrypted files (git-crypt)
- Use overlays for package modifications

## Testing and Validation

### Local Testing
```bash
# Check syntax and evaluation
nix flake check
nix eval .#nixosConfigurations.bup.config.system.build.toplevel

# Test build without switching
nn b <machine>

# Dry run
nix build --dry-run .#homeConfigurations.lgo.activationPackage
```

### Validation Process
1. Check flake syntax with `nix flake check`
2. Build configuration with `nn b <machine>`
3. Test switch in VM or safe environment first
4. Verify all imported modules evaluate correctly
5. Check git-crypt status before committing: `nn crypt`

## Development Workflow

1. **Make changes** to relevant modules in `modules/hm/` or `machines/`
2. **Test locally** with `nn b <machine>` 
3. **Validate** with `nix flake check`
4. **Switch** with `nn s <machine>` (if confident)
5. **Commit** changes with descriptive messages
6. **Update flake inputs** periodically with `nn update`

## Environment Requirements

- **Nix** with flakes enabled (use `nix.sh` wrapper if needed)
- **git-crypt** for secrets management
- **direnv** for automatic development environment
- **Home Manager** for user configurations
- **NixOS** or **nix-darwin** for system configurations

## Notes for Agents

- This is a personal dotfiles repository - ask before making breaking changes
- Test builds before switching configurations
- Respect the existing module structure and naming conventions
- Use the provided `nn` script for consistent builds across platforms
- Check git-crypt status when working with sensitive configurations
- Consider cross-platform compatibility (Darwin vs Linux differences)
- New modules should follow the established `opt.*` option pattern