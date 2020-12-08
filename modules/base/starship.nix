{ config, lib, ...  }:
with lib;
let
  base = config.modules.base;
  username = config.properties.user.name;
in
{
  config = mkIf base.enable {

    home-manager.users."${username}" = {

      programs.starship = {
        enable = true;
        enableFishIntegration = true;

        settings = {

          add_newline = false;
          scan_timeout = 10;

          battery = {
            display = [
              {
                style = "bold red";
                threshold = 15;
              }
              {
                style = "bold yellow";
                threshold = 30;
              }
            ];
          };

          character = {
            error_symbol = "[λ](bold red)";
            success_symbol = "[λ](bold green)";
            vicmd_symbol = "[λ](bold blue)";
          };

          directory = {
            truncation_length = 8;
            truncation_symbol = "…/";
          };

          gcloud.format = "on [($symbol$project)]($style) ";

          git_status = {
            modified = "*";
            renamed = "R";
          };

          status = {
            disabled = false;
            format = "[\[$symbol$status\]]($style) ";
            style = "bg:blue";
          };

          conda.disabled = true;
          dotnet.disabled = true;
          elixir.disabled = true;
          elm.disabled = true;
          erlang.disabled = true;
          ocaml.disabled = true;
          php.disabled = true;
        };
      };
    };
  };
}
