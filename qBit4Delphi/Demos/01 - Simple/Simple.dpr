program Simple;
uses

  {$INCLUDE ..\Defines.inc}
  {$IFDEF FASTMM4}
    {$IFDEF DEBUG}
      FastMM4,    //  MPL 1.1, LGPL 2.1 (https://github.com/pleriche/FastMM4)  << Can be removed if not used
    {$ENDIF}
  {$ENDIF}

  {$IFDEF VER340}
    REST.Json.Types in '..\..\API\JSON\21\REST.Json.Types.pas',
    REST.JsonReflect in '..\..\API\JSON\21\REST.JsonReflect.pas',
    System.JSON in '..\..\API\JSON\21\System.JSON.pas',
    REST.Json in '..\..\API\JSON\21\REST.Json.pas',
  {$ENDIF }
  {$IFDEF VER350}
    REST.Json.Types in '..\..\API\JSON\22\REST.Json.Types.pas',
    REST.JsonReflect in '..\..\API\JSON\22\REST.JsonReflect.pas',
    System.JSON in '..\..\API\JSON\22\System.JSON.pas',
    REST.Json in '..\..\API\JSON\22\REST.Json.pas',
  {$ENDIF}
  {$IFDEF VER360}
    REST.Json.Types in '..\..\API\JSON\23\REST.Json.Types.pas',
    REST.JsonReflect in '..\..\API\JSON\23\REST.JsonReflect.pas',
    System.JSON in '..\..\API\JSON\23\System.JSON.pas',
    REST.Json in '..\..\API\JSON\23\REST.Json.pas',
  {$ENDIF}  
  uqBitAPIUtils  in '..\..\API\uqBitAPIUtils .pas',
  uqBitAPITypes in '..\..\API\uqBitAPITypes.pas',
  uqBitAPI in '..\..\API\uqBitAPI.pas',
  uqBitObject in '..\..\API\uqBitObject.pas',

  Vcl.Forms,
  uSimple in 'uSimple.pas' {FrmSimple},

  uqBitUtils in '..\..\Common\uqBitUtils.pas',
  uqBitPatchChecker in '..\..\Common\uqBitPatchChecker.pas',
  uqBitFormat in '..\..\Common\uqBitFormat.pas',
  uqBitAddServerDlg in '..\Common\Dialogs\uqBitAddServerDlg.pas' {qBitAddServerDlg},
  uqBitSelectServerDlg in '..\Common\Dialogs\uqBitSelectServerDlg.pas' {qBitSelectServerDlg};

{$R *.res}

begin
  {$IFNDEF FASTMM4} {$IFDEF DEBUG} ReportMemoryLeaksOnShutdown := True; {$ENDIF} {$ENDIF}
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmSimple, FrmSimple);
  Application.CreateForm(TqBitAddServerDlg, qBitAddServerDlg);
  Application.CreateForm(TqBitSelectServerDlg, qBitSelectServerDlg);
  Application.Run;
end.

  // Place Holder :

  {$INCLUDE ..\Defines.inc}
  {$IFDEF FASTMM4}
    {$IFDEF DEBUG}
      FastMM4,    //  MPL 1.1, LGPL 2.1 (https://github.com/pleriche/FastMM4)  << Can be removed if not used
    {$ENDIF}
  {$ENDIF}

  {$IFDEF VER340}
    REST.Json.Types in '..\..\API\JSON\21\REST.Json.Types.pas',
    REST.JsonReflect in '..\..\API\JSON\21\REST.JsonReflect.pas',
    System.JSON in '..\..\API\JSON\21\System.JSON.pas',
    REST.Json in '..\..\API\JSON\21\REST.Json.pas',
  {$ENDIF }
  {$IFDEF VER350}
    REST.Json.Types in '..\..\API\JSON\22\REST.Json.Types.pas',
    REST.JsonReflect in '..\..\API\JSON\22\REST.JsonReflect.pas',
    System.JSON in '..\..\API\JSON\22\System.JSON.pas',
    REST.Json in '..\..\API\JSON\22\REST.Json.pas',
  {$ENDIF}
  {$IFDEF VER360}
    REST.Json.Types in '..\..\API\JSON\23\REST.Json.Types.pas',
    REST.JsonReflect in '..\..\API\JSON\23\REST.JsonReflect.pas',
    System.JSON in '..\..\API\JSON\23\System.JSON.pas',
    REST.Json in '..\..\API\JSON\23\REST.Json.pas',
  {$ENDIF}   
  uqBitAPIUtils  in '..\..\API\uqBitAPIUtils .pas',
  uqBitAPITypes in '..\..\API\uqBitAPITypes.pas',
  uqBitAPI in '..\..\API\uqBitAPI.pas',
  uqBitObject in '..\..\API\uqBitObject.pas',

  {$IFNDEF FASTMM4} {$IFDEF DEBUG} ReportMemoryLeaksOnShutdown := True; {$ENDIF} {$ENDIF}

