unit u_form_settings;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls,  ColorSpeedButtonCS,
  u_base_form, u_const, lcltype, ECSlider, ECSwitch, UserDialog, u_file_service,
  u_common_ui;

type

  { TFormSettings }

  TFormSettings = class(TBaseForm)
    btnSave: TColorSpeedButtonCS;
    chkDisableSpeed: TCheckBox;
    chkDisableStatus: TCheckBox;
    imgListMiniIcons: TImageList;
    lblDisableStatus: TLabel;
    lblMacroSpeed: TLabel;
    lblActions1: TLabel;
    lblDisableSpeed: TLabel;
    lblActiveProfile: TLabel;
    lblSliderText3: TLabel;
    lblStatusReport: TLabel;
    lblSliderText: TLabel;
    lblSliderText1: TLabel;
    lblSliderText2: TLabel;
    sliderActiveProfile: TECSlider;
    sliderGlobalSpeed: TECSlider;
    sliderStatusReport: TECSlider;
    swGameMode: TECSwitch;
    procedure btnSaveClick(Sender: TObject);
    procedure btnSaveMouseExit(Sender: TObject);
    procedure btnSaveMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure chkDisableSpeedClick(Sender: TObject);
    procedure chkDisableStatusClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure lblDisableSpeedClick(Sender: TObject);
    procedure lblDisableStatusClick(Sender: TObject);
    procedure sliderActiveProfileChange(Sender: TObject);
    procedure sliderActiveProfileMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sliderGlobalSpeedChange(Sender: TObject);
    procedure sliderGlobalSpeedMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sliderStatusReportChange(Sender: TObject);
    procedure sliderStatusReportMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure swGameModeChange(Sender: TObject);
  private
    loadingSettings: boolean;
    settingsChanged: boolean;
    function LoadStateSettings: boolean;
    { private declarations }
  public
    { public declarations }
  end;

var
  FormSettings: TFormSettings;
  function ShowSettings: boolean;

implementation

uses u_form_main_rgb;

{$R *.lfm}

function ShowSettings: boolean;
begin
  if FormSettings <> nil then
    FreeAndNil(FormSettings);
  Application.CreateForm(TFormSettings, FormSettings);
  FormSettings.ShowModal;
  FormSettings := nil;
  result := true;
end;

{ TFormSettings }


procedure TFormSettings.FormCreate(Sender: TObject);
begin
  lblTitle.Visible := false;
  LoadStateSettings;
  settingsChanged := false;
end;

function TFormSettings.LoadStateSettings: boolean;
var
  errorMsg: string;
begin
  Result := False;
  loadingSettings := true;

  errorMsg := fileService.LoadStateSettings;

  if (errorMsg = '') then
  begin
    sliderActiveProfile.Position := fileService.StateSettings.StartupFileNumber;

    if (fileService.StateSettings.MacroSpeed = 0) then
    begin
      sliderGlobalSpeed.Position := 1;
      chkDisableSpeed.Checked := true;
    end
    else
    begin
      sliderGlobalSpeed.Position := fileService.StateSettings.MacroSpeed;
      chkDisableSpeed.Checked := false;
    end;
    sliderGlobalSpeedChange(self);

    if (fileService.StateSettings.StatusPlaySpeed = 0) then
    begin
      sliderStatusReport.Position := 1;
      chkDisableStatus.Checked := true;
    end
    else
    begin
      sliderStatusReport.Position := fileService.StateSettings.StatusPlaySpeed;
      chkDisableStatus.Checked := false;
    end;
    sliderStatusReportChange(self);

    if (fileService.StateSettings.GameMode) then
      swGameMode.Checked := true
    else
      swGameMode.Checked := false;

    Result := true;
  end;

  loadingSettings := false;
end;

procedure TFormSettings.sliderActiveProfileChange(Sender: TObject);
begin
  lblActiveProfile.Caption := IntToStr(Round(sliderActiveProfile.Position));
end;

procedure TFormSettings.sliderActiveProfileMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  sliderPos: Real;
  value: integer;
begin
  if (not loadingSettings) then
  begin
    sliderPos := sliderActiveProfile.Position;
    if (Frac(sliderPos) > 0) then
    begin
      value := Round(sliderPos);
      sliderActiveProfile.Position := value;
      settingsChanged := true;
    end;

    self.SetFocus;
    sliderActiveProfile.Repaint;

    if (not loadingSettings) then
    begin

    end;
  end;
end;

procedure TFormSettings.sliderGlobalSpeedChange(Sender: TObject);
var
  value: integer;
  aColor:TColor;
begin
  value := Round(sliderGlobalSpeed.Position);
  if (value = 0) or (chkDisableSpeed.Checked) then
  begin
    lblMacroSpeed.Caption := '';
    aColor := KINESIS_MED_GRAY_RGB;
  end
  else
  begin
    lblMacroSpeed.Caption := IntToStr(value);
    aColor := KINESIS_BLUE_EDGE;
  end;
  sliderGlobalSpeed.Knob.Color := aColor;
  sliderGlobalSpeed.ProgressColor := aColor;
  sliderGlobalSpeed.Scale.TickColor := aColor;
end;

procedure TFormSettings.sliderGlobalSpeedMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  sliderPos: Real;
  value: integer;
begin
  if (not loadingSettings) then
  begin
    chkDisableSpeed.Checked := false;
    sliderPos := sliderGlobalSpeed.Position;
    if (Frac(sliderPos) > 0) then
    begin
      value := Round(sliderPos);
      sliderGlobalSpeed.Position := value;
      settingsChanged := true;
    end;
  end;
end;

procedure TFormSettings.sliderStatusReportChange(Sender: TObject);
var
  value: integer;
  aColor:TColor;
begin
  value := Round(sliderStatusReport.Position);
  if (value = 0) or (chkDisableStatus.Checked) then
  begin
    lblStatusReport.Caption := '';
    aColor := KINESIS_MED_GRAY_RGB;
  end
  else
  begin
    lblStatusReport.Caption := IntToStr(value);
    aColor := KINESIS_BLUE_EDGE;
  end;
  sliderStatusReport.Knob.Color := aColor;
  sliderStatusReport.ProgressColor := aColor;
  sliderStatusReport.Scale.TickColor := aColor;
end;

procedure TFormSettings.sliderStatusReportMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  sliderPos: Real;
  value: integer;
begin
  if (not loadingSettings) then
  begin
    chkDisableStatus.Checked := false;
    sliderPos := sliderStatusReport.Position;
    if (Frac(sliderPos) > 0) then
    begin
      value := Round(sliderPos);
      sliderStatusReport.Position := value;
      settingsChanged := true;
    end;
  end;
end;

procedure TFormSettings.swGameModeChange(Sender: TObject);
begin
  if (not loadingSettings) then
    settingsChanged := true;
end;

procedure TFormSettings.btnSaveClick(Sender: TObject);
var
  hideNotif: integer;
begin
  if (settingsChanged) then
  begin
    if (chkDisableSpeed.Checked) then
      fileService.SetMacroSpeed(0)
    else
      fileService.SetMacroSpeed(Round(sliderGlobalSpeed.Position));

    if (chkDisableStatus.Checked) then
      fileService.SetStatusPlaySpeed(0)
    else
      fileService.SetStatusPlaySpeed(Round(sliderStatusReport.Position));
    fileService.SetGameMode(swGameMode.Checked);
    fileService.SetStartupFileNumber(Round(sliderActiveProfile.Position));
    if (fileService.SaveStateSettings = '') then
    begin
      settingsChanged := false;

      if (ShowNotification(fileService.AppSettings.SaveMsg)) then
      begin
        hideNotif := ShowDialog('Settings Saved', 'Changes will be implemented when v-Drive is closed.',
          mtInformation, [mbOK], DEFAULT_DIAG_HEIGHT_RGB, nil, 'Hide this notification?');
        if (hideNotif >= DISABLE_NOTIF) then
        begin
          fileService.SetSaveMsg(true);
          fileService.SaveAppSettings;
        end;
      end;
      EjectDevice(GActiveDevice);
      Close;
    end;
  end;
  LoadButtonImage(sender, imgListMiniIcons, 0);
end;

procedure TFormSettings.btnSaveMouseExit(Sender: TObject);
begin
  if (not (sender as TColorSpeedButtonCS).Down) then
    LoadButtonImage(sender, imgListMiniIcons, 0);
end;

procedure TFormSettings.btnSaveMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  LoadButtonImage(sender, imgListMiniIcons, 1);
end;

procedure TFormSettings.lblDisableSpeedClick(Sender: TObject);
begin
  chkDisableSpeed.Checked := not chkDisableSpeed.Checked;
end;

procedure TFormSettings.chkDisableSpeedClick(Sender: TObject);
begin
  if (not loadingSettings) then
  begin
    settingsChanged := true;
    sliderGlobalSpeedChange(sender);
  end;
end;

procedure TFormSettings.lblDisableStatusClick(Sender: TObject);
begin
  chkDisableStatus.Checked := not chkDisableStatus.Checked;
end;

procedure TFormSettings.chkDisableStatusClick(Sender: TObject);
begin
  if (not loadingSettings) then
  begin
    settingsChanged := true;
    sliderStatusReportChange(sender);
  end;
end;

procedure TFormSettings.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
var
  dialogResult: integer;
begin
  if settingsChanged then
  begin
    dialogResult := ShowDialog('Save Settings?',
      'Do you want to save changes?',
      mtConfirmation, [mbYes, mbNo, mbCancel], DEFAULT_DIAG_HEIGHT_RGB);

    if dialogResult = mrYes then
      btnSave.Click
    else if dialogResult = mrCancel then
      CloseAction := caNone;
  end;
end;


end.

