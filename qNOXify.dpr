program qNOXify;

uses

  {$IFDEF VER340}
    REST.Json.Types in '..\qBit4Delphi\JSON\21\REST.Json.Types.pas',
    REST.JsonReflect in '..\qBit4Delphi\JSON\21\REST.JsonReflect.pas',
    System.JSON in '..\qBit4Delphi\JSON\21\System.JSON.pas',
    REST.Json in '..\qBit4Delphi\JSON\21\REST.Json.pas',
  {$ENDIF }
  {$IFDEF VER350}
    REST.Json.Types in '..\qBit4Delphi\JSON\22\REST.Json.Types.pas',
    REST.JsonReflect in '..\qBit4Delphi\JSON\22\REST.JsonReflect.pas',
    System.JSON in '..\qBit4Delphi\JSON\22\System.JSON.pas',
    REST.Json in '..\qBit4Delphi\JSON\22\REST.Json.pas',
  {$ENDIF}

  uqBitAPITypes in '..\qBit4Delphi\API\uqBitAPITypes.pas',
  uqBitAPI in '..\qBit4Delphi\API\uqBitAPI.pas',
  uqBitObject in '..\qBit4Delphi\API\uqBitObject.pas',

  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  uqNOXify in 'Files\uqNOXify.pas' {qNOXifyFrm},
  uqBitFormat in '..\qBit4Delphi\Demos\common\uqBitFormat.pas',
  uSelectServer in '..\qBit4Delphi\Demos\common\uSelectServer.pas',
  uAddServer in '..\qBit4Delphi\Demos\common\uAddServer.pas',
  uSetLocation in 'Files\uSetLocation.pas',
  uSpeedLimitsDlg in 'Files\uSpeedLimitsDlg.pas',
  uAppTrackMenus in '..\qBit4Delphi\Demos\common\uAppTrackMenus.pas',
  uAddEditCat in 'Files\uAddEditCat.pas',
  uAddTorrent in 'Files\uAddTorrent.pas' {AddTorrentDlg};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TqNOXifyFrm, qNOXifyFrm);
  Application.CreateForm(TAddServerDlg, AddServerDlg);
  Application.CreateForm(TSelectServerDlg, SelectServerDlg);
  Application.CreateForm(TSetLocationDlg, SetLocationDlg);
  Application.CreateForm(TSetLocationDlg, SetLocationDlg);
  Application.CreateForm(TSpeedLimitsDlg, SpeedLimitsDlg);
  Application.CreateForm(TAddEditCatDlg, AddEditCatDlg);
  Application.CreateForm(TAddTorrentDlg, AddTorrentDlg);
  Application.Run;
end.

(*

  ReportMemoryLeaksOnShutdown := True;

  {$IFDEF VER340}
    REST.Json.Types in 'JSON\Sydney.10.4.2\REST.Json.Types.pas',
    REST.JsonReflect in 'JSON\Sydney.10.4.2\REST.JsonReflect.pas',
    System.JSON in 'JSON\Sydney.10.4.2\System.JSON.pas',
    REST.Json in 'JSON\Sydney.10.4.2\REST.Json.pas',
  {$ENDIF }
  {$IFDEF VER350}
    REST.Json.Types in 'JSON\Alexandria.11.0\REST.Json.Types.pas',
    REST.JsonReflect in 'JSON\Alexandria.11.0\REST.JsonReflect.pas',
    System.JSON in 'JSON\Alexandria.11.0\System.JSON.pas',
    REST.Json in 'JSON\Alexandria.11.0\REST.Json.pas',
  {$ENDIF}

  uqBitAPITypes in 'API\uqBitAPITypes.pas',
  uqBitAPI in 'API\uqBitAPI.pas',
  uqBitObject in 'API\uqBitObject.pas',
*)
