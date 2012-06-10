unit Sdimain;

interface

uses Windows, Classes, Graphics, Forms, Controls, Menus,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, ImgList, StdActns,
  ActnList, ToolWin, VaClasses, VaComm, MyUtils;

type
  TSDIAppForm = class(TForm)
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    ToolBar1: TToolBar;
    ToolButton9: TToolButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ActionList1: TActionList;
    FileNew1: TAction;
    FileOpen1: TAction;
    FileSave1: TAction;
    FileSaveAs1: TAction;
    FileExit1: TAction;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    HelpAbout1: TAction;
    StatusBar: TStatusBar;
    ImageList1: TImageList;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    FileNewItem: TMenuItem;
    FileOpenItem: TMenuItem;
    FileSaveItem: TMenuItem;
    FileSaveAsItem: TMenuItem;
    N1: TMenuItem;
    FileExitItem: TMenuItem;
    Help1: TMenuItem;
    HelpAboutItem: TMenuItem;
    COMM: TVaComm;
    Log: TListBox;
    Timer1: TTimer;
    M: TMyTimer;
    Settings1: TMenuItem;
    Enable1: TMenuItem;
    procedure FileNew1Execute(Sender: TObject);
    procedure FileOpen1Execute(Sender: TObject);
    procedure FileSave1Execute(Sender: TObject);
    procedure FileExit1Execute(Sender: TObject);
    procedure HelpAbout1Execute(Sender: TObject);
    procedure COMMRxChar(Sender: TObject; Count: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure Enable1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SDIAppForm: TSDIAppForm;

implementation

uses About, sysutils;

{$R *.DFM}

procedure TSDIAppForm.FileOpen1Execute(Sender: TObject);
begin
  OpenDialog.Execute;
end;

procedure TSDIAppForm.FileSave1Execute(Sender: TObject);
begin
  SaveDialog.Execute;
end;

procedure TSDIAppForm.FileExit1Execute(Sender: TObject);
begin
  Close;
end;

procedure TSDIAppForm.HelpAbout1Execute(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

procedure TSDIAppForm.COMMRxChar(Sender: TObject; Count: Integer);
Var
  Buf : Array[0..255] of Byte;
  N : Integer;
  Ch : Char;

begin
  N := COMM.ReadBufUsed;
  COMM.ReadBuf(Buf,Count);
  Log.Items.BeginUpdate;
  For N := 1 to Count do
  Begin
    If ((Buf[N-1] >= $20) and (Buf[N-1] <= $7F)) then Ch := Chr(Buf[N-1])
    else Ch := Chr(Buf[N-1]);
    Log.Items.Add(IntToStr(Log.Items.Count+1)
      +TAB+IntToStr(Buf[N-1])
      +TAB+Ch
      +TAB+IntToStr(M.ElapsedTimemS)+'mS');
    Application.ProcessMessages;
  end;
  Log.Items.EndUpdate;
end;

procedure TSDIAppForm.FileNew1Execute(Sender: TObject);
begin
  Log.Clear;
  COMM.WriteChar('M');
  M.StartElapsedTimer;
end;

procedure TSDIAppForm.Timer1Timer(Sender: TObject);
begin
  FileNew1Execute(nil);
end;

procedure TSDIAppForm.Enable1Click(Sender: TObject);
begin
  TMenuItem(Sender).Checked := not(TMenuItem(Sender).Checked);
  Timer1.Enabled := Enable1.Checked;
end;

end.
