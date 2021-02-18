{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.modules.gui;
  username = config.properties.user.name;

  rotate = pkgs.writeScript "rotate" ''
    #!${pkgs.python}/bin/python

    from time import sleep
    from os import path as op
    import sys
    from subprocess import check_call, check_output
    from glob import glob


    # Your device names go here if different.
    TOUCHSCREEN = 'pointer:ELAN2514:00 04F3:2C49'
    KEYBOARD = 'keyboard:AT Translated Set 2 keyboard'
    TOUCHPAD    = 'SYNA3297:00 06CB:CD50 Touchpad'
    # PEN         = 'ELAN0732:00 04F3:22E1 Pen Pen (0)'

    disable_touchpads = True
    disable_keyboard = True


    def bdopen(fname):
        return open(op.join(basedir, fname))


    def read(fname):
        return bdopen(fname).read()


    for basedir in glob('/sys/bus/iio/devices/iio:device*'):
        if 'accel' in read('name'):
            break
    else:
        sys.stderr.write("Can't find an accellerator device!\n")
        sys.exit(1)


    scale = float(read('in_accel_scale'))

    g = 7.0  # (m^2 / s) sensibility, gravity trigger

    STATES = [
        {'rot': 'normal', 'coord': '1 0 0 0 1 0 0 0 1', 'touchpad': 'enable',
         'check': lambda x, y: y <= -g},
        {'rot': 'inverted', 'coord': '-1 0 1 0 -1 1 0 0 1', 'touchpad': 'disable',
         'check': lambda x, y: y >= g},
        {'rot': 'left', 'coord': '0 -1 1 1 0 0 0 0 1', 'touchpad': 'disable',
         'check': lambda x, y: x >= g},
        {'rot': 'right', 'coord': '0 1 0 -1 0 1 0 0 1', 'touchpad': 'disable',
         'check': lambda x, y: x <= -g},
    ]


    def rotate(state):
        s = STATES[state]
        check_call(['${pkgs.xorg.xrandr}/bin/xrandr', '-o', s['rot']])

        check_call(['${pkgs.xorg.xinput}/bin/xinput', 'set-prop', TOUCHSCREEN, 'Coordinate Transformation Matrix',] + s['coord'].split())

        if disable_touchpads:
            check_call(['${pkgs.xorg.xinput}/bin/xinput', s['touchpad'], TOUCHPAD])

        if disable_keyboard:
            check_call(['${pkgs.xorg.xinput}/bin/xinput', s['touchpad'], KEYBOARD])


    def read_accel(fp):
        fp.seek(0)
        return float(fp.read()) * scale


    if __name__ == '__main__':

        accel_x = bdopen('in_accel_x_raw')
        accel_y = bdopen('in_accel_y_raw')

        current_state = None

        while True:
            x = read_accel(accel_x)
            y = read_accel(accel_y)
            for i in range(4):
                if i == current_state:
                    continue
                if STATES[i]['check'](x, y):
                    current_state = i
                    rotate(i)
                    break
            sleep(1)
  '';

in
  {
    options.modules.gui.touchscreen = {
      enable = mkEnableOption "Support touchscreen laptop.";
      autoRotate = mkEnableOption "Enable auto-rotate.";
    };

    config = mkMerge [
      (mkIf ( gui.enable && gui.touchscreen.enable ) {
        environment.variables.MOZ_USE_XINPUT2 = "1";
      })

      (mkIf ( gui.enable && gui.touchscreen.enable && gui.touchscreen.autoRotate ) {
        home-manager.users.${username} = {
          home.packages = with pkgs; [ onboard ];
          systemd.user.services.auto-rotate = {
            Unit = {
              Description = "auto rotate display";
              After = [ "graphical-session-pre.target" ];
              PartOf = [ "graphical-session.target" ];
            };

            Service = {
              Type = "simple";
              ExecStart = "${rotate}";
              Restart = "on-failure";
            };

            Install = { WantedBy = [ "graphical-session.target" ]; };
          };
        };
      })
    ];
  }
