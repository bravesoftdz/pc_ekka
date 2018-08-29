unit TimerZU;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
     Dialogs, StdCtrls, Buttons, ExtCtrls, DateUtils, ActnList, EKKAU, Util;

type

  TTimerZF = class(TForm)
    bbZ: TBitBtn;
    bbClose: TBitBtn;
    BitBtn1: TBitBtn;
    Timer1: TTimer;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ActionList1: TActionList;
    Action1: TAction;
    Label4: TLabel;
    Label5: TLabel;
    procedure FormCreate  (Sender: TObject);
    procedure bbCloseClick(Sender: TObject);
    procedure bbZClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Timer1Timer (Sender: TObject);
    procedure Action1Execute(Sender: TObject);

  private


  public

    dt1,dt2,dtZ:TDateTime;

  end;

var TimerZF:TTimerZF;

implementation

uses MainU, ZXRepU, DataModuleU;

{$R *.dfm}

procedure TTimerZF.FormCreate(Sender: TObject);
 begin
  Caption:=MFC;

{
  tm1:=StrToTime('23:55:00');
  tm2:=StrToTime('00:03:00');
}
{
  tm1:=StrToTime('10:20:00');
  tm2:=StrToTime('12:11:00');
  tmZ:=StrToTime('11:20:00');
}
 end;

procedure TTimerZF.bbCloseClick(Sender: TObject);
 begin
  Close;
 end;

procedure TTimerZF.bbZClick(Sender: TObject);
 begin
  ZXRepF:=TZXRepF.Create(Self);
  try
   Application.ProcessMessages;
   ZXRepF.ShowModal;
  finally
   ZXRepF.Free;
  end;
 end;

procedure TTimerZF.BitBtn1Click(Sender: TObject);
 begin
  Close;
 end;

procedure TTimerZF.Timer1Timer(Sender:TObject);
 begin
  try
   Timer1.Enabled:=False;
   if (Now>dt1) and (Now<dt2) then
    begin
     AppendStringToFile('D:\AVA\ZRepLog.txt', DateTimeToStr(Now)+': ���������� ���������');

     bbClose.Enabled:=False;
     if Label1.Visible=False then
      begin
       Label1.Visible:=True;
       Label2.Visible:=True;
       Label3.Visible:=True;
       Label1.Caption:='��������� ������������� � '+FormatDateTime('dd.mm.yy hh:nn',dt1)+' �� '+FormatDateTime('dd.mm.yy hh:nn',dt2);
      end;

     Label3.Caption:=TimeToStr(dt2-Now);
     Label4.Visible:=False;

     try
      EKKA.fpGetStatus;
      if EKKA.LastError<>'' then raise EAbort.Create('���������� ����������� � ��������� ��������. ��������� ������� ����� ��������� ��������. ��������� ��������� �������� �������.');
      Label5.Font.Color:=clMaroon;
      if Ord(EKKA.RD_Item[9][1])=1 then // Z-����� ����
       begin
        AppendStringToFile('D:\AVA\ZRepLog.txt', DateTimeToStr(Now)+': Z-����� ��� ����.');
        Label5.Visible:=False;
       end else begin
                 Label5.Visible:=True;
                 if dtZ>Now then
                  begin
                   AppendStringToFile('D:\AVA\ZRepLog.txt', DateTimeToStr(Now)+': Z-����� �� ����. ��������.');
                   Label5.Caption:='�������� Z-����� ����� ���� ������������� �����: '+TimeToStr(dtZ-Now)+#10' ��������� ������ � �������� ��������!';
                  end else begin
                            AppendStringToFile('D:\AVA\ZRepLog.txt', DateTimeToStr(Now)+': ������ Z-������.');
                            EKKA.fpXRep;
                            if EKKA.LastError<>'' then raise EAbort.Create(EKKA.LastErrorDescr);
                            EKKA.fpZRep;
                            if EKKA.LastError<>'' then raise EAbort.Create(EKKA.LastErrorDescr);
                            Label5.Caption:='C ������ ��������� �������� ��� ������������� ���� Z-�����. �� ������� ������� Z-����� � ����� � ��������� ��������������� ������ �����.';
                            AppendStringToFile('D:\AVA\ZRepLog.txt', DateTimeToStr(Now)+': Z-����� ����.');
                           end
                end;
     except
      on E:Exception do
       begin
        Label5.Visible:=True;
        Label5.Caption:=E.Message;
        Label5.Font.Color:=clRed;
        MainF.RegisterError('�������������� ������ Z-������',E.Message,True);
//        RegError(DM.QrEx,'�������������� ������ Z-������',E.Message);
       end;
     end;

    end else begin
              AppendStringToFile('D:\AVA\ZRepLog.txt', DateTimeToStr(Now)+': ������������� ���������.');
              bbClose.Enabled:=True;
              Label1.Visible:=False;
              Label2.Visible:=False;
              Label3.Visible:=False;

              Label4.Visible:=True;
             end;
  finally
   Timer1.Enabled:=True;
  end;
 end;

procedure TTimerZF.Action1Execute(Sender: TObject);
 begin
  //
 end;

end.
