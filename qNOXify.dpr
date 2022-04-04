program qNOXify;

uses
  Vcl.Forms,
  uqNOXify in 'Files\uqNOXify.pas' {qBitMainForm},
  REST.Json in '..\qBit4Delphi\API\JSON\22\REST.Json.pas',
  REST.Json.Types in '..\qBit4Delphi\API\JSON\22\REST.Json.Types.pas',
  REST.JsonReflect in '..\qBit4Delphi\API\JSON\22\REST.JsonReflect.pas',
  System.JSON in '..\qBit4Delphi\API\JSON\22\System.JSON.pas',
  uqBitAPI in '..\qBit4Delphi\API\uqBitAPI.pas',
  uqBitAPITypes in '..\qBit4Delphi\API\uqBitAPITypes.pas',
  uqBitObject in '..\qBit4Delphi\API\uqBitObject.pas',
  uqBitFormat in '..\qBit4Delphi\Demos\common\uqBitFormat.pas',
  uAppTrackMenus in '..\qBit4Delphi\Demos\common\uAppTrackMenus.pas',
  uGrid in 'Files\uGrid.pas' {SGFrm: TFrame},
  uAddTorrent in 'Files\uAddTorrent.pas' {AddTorrentDlg},
  uSetLocation in 'Files\uSetLocation.pas' {SetLocationDlg},
  uSpeedLimitsDlg in 'Files\uSpeedLimitsDlg.pas' {SpeedLimitsDlg},
  uSelectServer in '..\qBit4Delphi\Demos\common\uSelectServer.pas' {SelectServerDlg},
  uAddServer in '..\qBit4Delphi\Demos\common\uAddServer.pas' {AddServerDlg};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TqBitMainForm, qBitMainForm);
  Application.CreateForm(TAddTorrentDlg, AddTorrentDlg);
  Application.CreateForm(TSetLocationDlg, SetLocationDlg);
  Application.CreateForm(TSpeedLimitsDlg, SpeedLimitsDlg);
  Application.CreateForm(TSelectServerDlg, SelectServerDlg);
  Application.CreateForm(TAddServerDlg, AddServerDlg);
  Application.Run;
end.
