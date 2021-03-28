{ config, lib, pkgs, ... }:
with lib;
let
  gui = config.modules.gui;
  username = config.properties.user.name;
in
{
  options.modules.gui.office = {
    enable = mkEnableOption "Enable office documents software.";
  };

  config = mkIf (gui.enable && gui.office.enable) {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        libreoffice-fresh
      ];

      xdg.mimeApps.defaultApplications = lib.genAttrs [
        "application/vnd.oasis.opendocument.spreadsheet"
        "application/vnd.oasis.opendocument.spreadsheet-template"
        "application/vnd.sun.xml.calc"
        "application/vnd.sun.xml.calc.template"
        "application/msexcel"
        "application/vnd.ms-excel"
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        "application/vnd.ms-excel.sheet.macroEnabled.12"
        "application/vnd.openxmlformats-officedocument.spreadsheetml.template"
        "application/vnd.ms-excel.template.macroEnabled.12"
        "application/vnd.ms-excel.sheet.binary.macroEnabled.12"
        "text/csv"
        "application/x-dbf"
        "text/spreadsheet"
        "application/csv"
        "application/excel"
        "application/tab-separated-values"
        "application/vnd.lotus-1-2-3"
        "application/vnd.oasis.opendocument.chart"
        "application/vnd.oasis.opendocument.chart-template"
        "application/x-dbase"
        "application/x-dos_ms_excel"
        "application/x-excel"
        "application/x-msexcel"
        "application/x-ms-excel"
        "application/x-quattropro"
        "application/x-123"
        "text/comma-separated-values"
        "text/tab-separated-values"
        "text/x-comma-separated-values"
        "text/x-csv"
        "application/vnd.oasis.opendocument.spreadsheet-flat-xml"
        "application/vnd.ms-works"
        "application/clarisworks"
        "application/x-iwork-numbers-sffnumbers"
        "application/x-starcalc"

      ] (_: [ "calc.desktop" ]) // lib.genAttrs [
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        "application/vnd.oasis.opendocument.text"
        "application/vnd.oasis.opendocument.text-template"
        "application/vnd.oasis.opendocument.text-web"
        "application/vnd.oasis.opendocument.text-master"
        "application/vnd.oasis.opendocument.text-master-template"
        "application/vnd.sun.xml.writer"
        "application/vnd.sun.xml.writer.template"
        "application/vnd.sun.xml.writer.global"
        "application/msword"
        "application/vnd.ms-word"
        "application/x-doc"
        "application/x-hwp"
        "application/rtf"
        "text/rtf"
        "application/vnd.wordperfect"
        "application/wordperfect"
        "application/vnd.lotus-wordpro"
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        "application/vnd.ms-word.document.macroEnabled.12"
        "application/vnd.openxmlformats-officedocument.wordprocessingml.template"
        "application/vnd.ms-word.template.macroEnabled.12"
        "application/vnd.ms-works"
        "application/vnd.stardivision.writer-global"
        "application/x-extension-txt"
        "application/x-t602"
        "text/plain"
        "application/vnd.oasis.opendocument.text-flat-xml"
        "application/x-fictionbook+xml"
        "application/macwriteii"
        "application/x-aportisdoc"
        "application/prs.plucker"
        "application/vnd.palm"
        "application/clarisworks"
        "application/x-sony-bbeb"
        "application/x-abiword"
        "application/x-iwork-pages-sffpages"
        "application/x-mswrite"
        "application/x-starwriter"
      ] (_: [ "writer.desktop" ]);
    };
  };
}
