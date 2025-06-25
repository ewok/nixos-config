{ config, pkgs, ... }:
let
  dag = config.lib.dag;
  # nvd = import
  #   (pkgs.fetchFromGitLab {
  #     owner = "khumba";
  #     repo = "nvd";
  #     rev = "13d3ab1255e0de03693cecb7da9764c9afd5d472";
  #     sha256 = "1537s7j0m0hkahf0s1ai7bm94xj9fz6b9x78py0dn3cgnl9bfzla";
  #   })
  #   { inherit pkgs; };
in
{
  home.activation.report-changes = dag.entryAnywhere ''
    # if [ "$oldGenPath" != "" ]; then
      ${pkgs.nvd}/bin/nvd history --profile ~/.nix-profile
      # diff $oldGenPath $newGenPath
    # fi
  '';
}
