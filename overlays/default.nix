{ inputs }: final: prev:
let
  inherit (final) callPackage lib;
in
{
  carapace = prev.carapace.overrideAttrs (oldAttrs: {
    version = "1.3.3";
    src = prev.fetchFromGitHub {
      owner = "carapace-sh";
      repo = "carapace-bin";
      rev = "v1.3.3";
      sha256 = "sha256-dVM5XFFNXAVoN2xshq5k0Y6vSrfSNS0bIptcloX/uSg="; # replace with actual hash
    };
    vendorHash = "sha256-XRbqxL2ANWi2aZbB30tNBxJoBIoDoMxKXMpOx++JJ6M=";
  });

  # Zellij session manager with zoxide integration
  zesh = inputs.zesh.packages.${final.system}.default;
}
