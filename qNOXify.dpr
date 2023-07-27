program qNOXify;
uses

  {.$DEFINE USEDEVAPI}

  {$IFDEF USEDEVAPI}
    FastMM4,    // Can be removed if not available
  {$ENDIF}

  {$IFDEF VER340}  // Delphi 10.4 Sydney
      {$IFDEF USEDEVAPI}
        REST.Json.Types in '..\qBit4Delphi\API\JSON\22\REST.Json.Types.pas',
        REST.JsonReflect in '..\qBit4Delphi\API\JSON\22\REST.JsonReflect.pas',
        System.JSON in '..\qBit4Delphi\API\JSON\22\System.JSON.pas',
        REST.Json in '..\qBit4Delphi\API\JSON\22\REST.Json.pas',
      {$ELSE}
        REST.Json.Types in 'qBit4Delphi\API\JSON\21\REST.Json.Types.pas',
        REST.JsonReflect in 'qBit4Delphi\API\JSON\21\REST.JsonReflect.pas',
        System.JSON in 'qBit4Delphi\API\JSON\21\System.JSON.pas',
        REST.Json in 'qBit4Delphi\API\JSON\21\REST.Json.pas',
       {$ENDIF}
  {$ENDIF}
  {$IFDEF VER350} // Delphi 11 Alexandria
      {$IFDEF USEDEVAPI}
        REST.Json.Types in '..\qBit4Delphi\API\JSON\22\REST.Json.Types.pas',
        REST.JsonReflect in '..\qBit4Delphi\API\JSON\22\REST.JsonReflect.pas',
        System.JSON in '..\qBit4Delphi\API\JSON\22\System.JSON.pas',
        REST.Json in '..\qBit4Delphi\API\JSON\22\REST.Json.pas',
      {$ELSE}
        REST.Json.Types in 'qBit4Delphi\API\JSON\22\REST.Json.Types.pas',
        REST.JsonReflect in 'qBit4Delphi\API\JSON\22\REST.JsonReflect.pas',
        System.JSON in 'qBit4Delphi\API\JSON\22\System.JSON.pas',
        REST.Json in 'qBit4Delphi\API\JSON\22\REST.Json.pas',
      {$ENDIF}
  {$ENDIF}
  {$IFDEF VER360} // Delphi 12 Yukon
      {$IFDEF USEDEVAPI}
        REST.Json.Types in '..\qBit4Delphi\API\JSON\23\REST.Json.Types.pas',
        REST.JsonReflect in '..\qBit4Delphi\API\JSON\23\REST.JsonReflect.pas',
        System.JSON in '..\qBit4Delphi\API\JSON\23\System.JSON.pas',
        REST.Json in '..\qBit4Delphi\API\JSON\23\REST.Json.pas',
      {$ELSE}
        REST.Json.Types in 'qBit4Delphi\API\JSON\23\REST.Json.Types.pas',
        REST.JsonReflect in 'qBit4Delphi\API\JSON\23\REST.JsonReflect.pas',
        System.JSON in 'qBit4Delphi\API\JSON\23\System.JSON.pas',
        REST.Json in 'qBit4Delphi\API\JSON\23\REST.Json.pas',
      {$ENDIF}
  {$ENDIF}

  {$IFDEF USEDEVAPI}
        uqBitAPITypes in '..\qBit4Delphi\API\uqBitAPITypes.pas',
        uqBitAPI in '..\qBit4Delphi\API\uqBitAPI.pas',
        uqBitObject in '..\qBit4Delphi\API\uqBitObject.pas',
        uTorrentReader in '..\qBit4Delphi\common\uTorrentReader.pas',
        uqBitPatchChecker in '..\qBit4Delphi\common\uqBitPatchChecker.pas',
        uKobicAppTrackMenus in '..\qBit4Delphi\demos\common\uKobicAppTrackMenus.pas',
        uBEncode in '..\qBit4Delphi\common\uBEncode.pas',
        uqBitFormat in '..\qBit4Delphi\common\uqBitFormat.pas',
        uqBitAPIUtils  in '..\qBit4Delphi\API\uqBitAPIUtils .pas',
        uqBitUtils in '..\qBit4Delphi\common\uqBitUtils.pas',
        uqBitAddTorrentDlg in '..\qBit4Delphi\demos\common\dialogs\uqBitAddTorrentDlg.pas' {qBitAddTorrentDlg},
        uqBitAddServerDlg in '..\qBit4Delphi\demos\common\dialogs\uqBitAddServerDlg.pas' {qBitAddServerDlg},
        uqBitCategoriesDlg in '..\qBit4Delphi\demos\common\dialogs\uqBitCategoriesDlg.pas' {qBitCategoriesDlg},
        uqBitSelectServerDlg in '..\qBit4Delphi\demos\common\dialogs\uqBitSelectServerDlg.pas' {qBitSelectServerDlg},
  {$ELSE}
        uqBitAPITypes in 'qBit4Delphi\API\uqBitAPITypes.pas',
        uqBitAPI in 'qBit4Delphi\API\uqBitAPI.pas',
        uqBitObject in 'qBit4Delphi\API\uqBitObject.pas',
        uTorrentReader in 'qBit4Delphi\common\uTorrentReader.pas',
        uqBitPatchChecker in 'qBit4Delphi\common\uqBitPatchChecker.pas',
        uKobicAppTrackMenus in 'qBit4Delphi\demos\common\uKobicAppTrackMenus.pas',
        uBEncode in 'qBit4Delphi\common\uBEncode.pas',
        uqBitFormat in 'qBit4Delphi\common\uqBitFormat.pas',
        uqBitAPIUtils  in 'qBit4Delphi\API\uqBitAPIUtils .pas',
        uqBitUtils in 'qBit4Delphi\common\uqBitUtils.pas',
        uqBitAddTorrentDlg in 'qBit4Delphi\demos\common\dialogs\uqBitAddTorrentDlg.pas' {qBitAddTorrentDlg},
        uqBitAddServerDlg in 'qBit4Delphi\demos\common\dialogs\uqBitAddServerDlg.pas' {qBitAddServerDlg},
        uqBitCategoriesDlg in 'qBit4Delphi\demos\Common\Dialogs\uqBitCategoriesDlg.pas' {qBitCategoriesDlg},
        uqBitSelectServerDlg in 'qBit4Delphi\demos\Common\Dialogs\uqBitSelectServerDlg.pas' {qBitSelectServerDlg},
  {$ENDIF}

  Vcl.Forms,

  uSetLocation in 'Files\uSetLocation.pas' {SetLocationDlg},
  uSpeedLimitsDlg in 'Files\uSpeedLimitsDlg.pas' {SpeedLimitsDlg},
  uqNOXify in 'Files\uqNOXify.pas' {qBitMainForm},
  uGrid in 'Files\uGrid.pas' {SGFrm: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TqBitMainForm, qBitMainForm);
  Application.CreateForm(TqBitAddTorrentDlg, qBitAddTorrentDlg);
  Application.CreateForm(TSetLocationDlg, SetLocationDlg);
  Application.CreateForm(TSpeedLimitsDlg, SpeedLimitsDlg);
  Application.CreateForm(TqBitAddServerDlg, qBitAddServerDlg);
  Application.CreateForm(TqBitCategoriesDlg, qBitCategoriesDlg);
  Application.CreateForm(TqBitAddTorrentDlg, qBitAddTorrentDlg);
  Application.CreateForm(TqBitSelectServerDlg, qBitSelectServerDlg);
  Application.Run;
end.



