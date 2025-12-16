{ config, pkgs, nixpkgs, ... }:
{
  imports = [
    ../common
    ./home-manager.nix
  ];

  # Setup user, packages, programs
  nix = {
    package = pkgs.nixVersions.latest;
    settings.trusted-users = [ "@admin" "gustavo" ];
    enable = true;

    # Turn this on to make command line easier
    extraOptions = ''
      experimental-features = nix-command flakes

      # Required by nix-direnv
      keep-outputs = true
      keep-derivations = true
    '';
  };

  # Turn off NIX_PATH warnings now that we're using flakes
  system.checks.verifyNixPath = false;

  programs = { };

  services.aerospace = {
    enable = true;
    settings = {
      # Normalizations
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;

      # Mouse follows focus
      on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];

      # Window rules for apps that don't tile well by default
      on-window-detected = [
        {
          "if".app-id = "org.gnu.Emacs";
          run = "layout tiling";
        }
        {
          "if".app-id = "org.alacritty";
          run = "layout tiling";
        }
      ];

      # Gaps between windows
      gaps = {
        inner.horizontal = 10;
        inner.vertical = 10;
        outer.left = 10;
        outer.bottom = 10;
        outer.top = 10;
        outer.right = 10;
      };

      # Workspace to monitor assignments (1-5 main, 6-9 secondary with fallback)
      workspace-to-monitor-force-assignment = {
        "1" = "main";
        "2" = "main";
        "3" = "main";
        "4" = "main";
        "5" = "main";
        "6" = [ "secondary" "main" ];
        "7" = [ "secondary" "main" ];
        "8" = [ "secondary" "main" ];
        "9" = [ "secondary" "main" ];
      };

      mode.main.binding = {
        # Focus windows
        "alt-h" = "focus left";
        "alt-j" = "focus down";
        "alt-k" = "focus up";
        "alt-l" = "focus right";

        # Move windows
        "alt-shift-h" = "move left";
        "alt-shift-j" = "move down";
        "alt-shift-k" = "move up";
        "alt-shift-l" = "move right";

        # Resize windows
        "alt-minus" = "resize smart -50";
        "alt-equal" = "resize smart +50";

        # Switch workspaces
        "alt-1" = "workspace 1";
        "alt-2" = "workspace 2";
        "alt-3" = "workspace 3";
        "alt-4" = "workspace 4";
        "alt-5" = "workspace 5";
        "alt-6" = "workspace 6";
        "alt-7" = "workspace 7";
        "alt-8" = "workspace 8";
        "alt-9" = "workspace 9";

        # Move window to workspace
        "alt-shift-1" = "move-node-to-workspace 1";
        "alt-shift-2" = "move-node-to-workspace 2";
        "alt-shift-3" = "move-node-to-workspace 3";
        "alt-shift-4" = "move-node-to-workspace 4";
        "alt-shift-5" = "move-node-to-workspace 5";
        "alt-shift-6" = "move-node-to-workspace 6";
        "alt-shift-7" = "move-node-to-workspace 7";
        "alt-shift-8" = "move-node-to-workspace 8";
        "alt-shift-9" = "move-node-to-workspace 9";

        # Layout controls
        "alt-slash" = "layout tiles horizontal vertical";
        "alt-comma" = "layout accordion horizontal vertical";
        "alt-f" = "fullscreen";

        # Toggle between floating and tiling
        "alt-shift-space" = "layout floating tiling";

        # Service mode for resize/other operations
        "alt-shift-semicolon" = "mode service";
      };

      mode.service.binding = {
        "esc" = [ "reload-config" "mode main" ];
        "r" = [ "flatten-workspace-tree" "mode main" ];
        "f" = [ "layout floating tiling" "mode main" ];
        "backspace" = [ "close-all-windows-but-current" "mode main" ];
      };
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    primaryUser = "gustavo";
    stateVersion = 6;
    defaults = {
      LaunchServices = {
        LSQuarantine = false;
      };

      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        ApplePressAndHoldEnabled = false;

        # 120, 90, 60, 30, 12, 6, 2
        KeyRepeat = 2;

        # 120, 94, 68, 35, 25, 15
        InitialKeyRepeat = 15;

        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;
      };

      dock = {
        autohide = false;
        show-recents = false;
        launchanim = true;
        orientation = "bottom";
        tilesize = 48;
      };

      finder = {
        _FXShowPosixPathInTitle = false;
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };
  };
}
