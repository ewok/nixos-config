{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (pkgs) writeShellScriptBin;

  cfg = config.opt.scripts;
in
{
  options.opt.scripts = {
    enable = mkEnableOption "scripts";
  };

  config = mkIf cfg.enable {
    home.packages =
      let
        copy-ssm = writeShellScriptBin "aws-copy-ssm" ''
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

        convert = writeShellScriptBin "convert-mov" ''
          PARAM=''${1:-"720:-1"}
          for v in *.MOV; do
            ## Remove ext .mov
            NAME=$(basename -s .MOV "$v")
            ffmpeg -i "$NAME.MOV" -filter:v scale=$PARAM "''${NAME}_C.MOV"
          done
        '';

        mtu-find-the-best = writeShellScriptBin "mtu-find-the-best" ''
          #!/bin/bash
          set -e

          # Target host; you can use a hostname or an IP address.
          TARGET="8.8.8.8"

          # Adjust these variables if needed.
          MAX_MTU=1500
          MIN_MTU=68  # Smallest possible MTU value for IPv4
          MTU_INCREMENT=1

          # Function to check if a packet size can be sent without fragmentation
          function ping_with_size {
              local size="$1"
              ping -c 1 -M do -s $size $TARGET > /dev/null 2>&1
              # ping -c 1 -D -s $size $TARGET > /dev/null 2>&1
          }

          # Binary search to find the largest MTU that allows a non-fragmented packet
          while (( MIN_MTU < MAX_MTU )); do
              MID_MTU=$(( (MIN_MTU + MAX_MTU + MTU_INCREMENT) / 2 ))

              if ping_with_size $MID_MTU; then
                  MIN_MTU=$MID_MTU
              else
                  MAX_MTU=$(( MID_MTU - MTU_INCREMENT ))
              fi
          done

          echo "Optimal MTU size is: $((MIN_MTU + 28))"

        '';
      in
      [
        copy-ssm
        convert
        mtu-find-the-best
      ];
  };
}
