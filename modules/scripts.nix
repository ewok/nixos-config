{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.opt.scripts;
in
{
  options.opt.scripts = {
    enable = mkEnableOption "scripts";
  };

  config = mkIf cfg.enable {
    home.packages =
      let
        copy-ssm = pkgs.writeShellScriptBin "aws-copy-ssm" ''
          # Assign arguments to variables
          SOURCE_AWS_PROFILE=$1
          DESTINATION_AWS_PROFILE=$2
          PARAMETER=$3
          export AWS_REGION="ap-southeast-1"

          # Check if all required arguments are provided
          if [[ -z "$SOURCE_AWS_PROFILE" || -z "$DESTINATION_AWS_PROFILE" || -z "$PARAMETER" ]]; then
            echo "Usage: $0 <source-profile> <destination-profile> <source-parameter-name>"
            exit 1
          fi

          assume -ex $SOURCE_AWS_PROFILE
          assume -ex $DESTINATION_AWS_PROFILE

          # Fetch the value of the SSM parameter from the source profile
          # Note: --with-decryption is used if the parameter is SecureString type
          value=$(aws ssm get-parameter --name "$PARAMETER" --profile "$SOURCE_AWS_PROFILE" --with-decryption --query "Parameter.Value" --output text)

          echo $value

          # Check if the value was retrieved successfully
          if [ -z "$value" ]; then
              echo "Failed to retrieve source SSM parameter value"
              exit 1
          fi

          # Copy the value to the destination SSM parameter under the destination profile
          # Note: Add or remove --type and --overwrite flags based on your requirements
          aws ssm put-parameter --name "$PARAMETER" --value "$value" --profile "$DESTINATION_AWS_PROFILE" --type "SecureString" --overwrite
        '';
      in
      [
        copy-ssm
      ];
  };
}
