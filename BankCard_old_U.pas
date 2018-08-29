unit BankCard_old_U;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
     Dialogs, StdCtrls, ExtCtrls, Buttons, ComObj, MainU, Util, EnterValueU, ShowTextU, Math;

type

  TBankCard_old_F = class(TForm)

    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Label4: TLabel;
    Label5: TLabel;
    Edit1: TEdit;

    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);

  private

    FFlag:Integer;

  public
                               
    CP:TChekPos;

    property Flag:Integer read FFlag write FFlag;

  end;

var BankCard_old_F:TBankCard_old_F;
    StartTerminal:Boolean;
    Term: OleVariant;

implementation

uses DataModuleU, DialogU, EKKAU;

{$R *.dfm}

procedure TBankCard_old_F.BitBtn2Click(Sender:TObject);
 begin
  Close;
 end;

procedure TBankCard_old_F.BitBtn1Click(Sender:TObject);
var i:Integer;
    Res:String;

 begin

{  if edCard.Text='' then
   begin
    MainF.MessBox('������� ����� ���������� ��������!');
    edCard.SetFocus;
   end else
 }
{  if Not ((Prm.AptekaID=21) and (Opt.KassaID=1)) and (CP.IsTerminal=False) and (Opt.UseTerminal=True) and
    ((Prm.AptekaID in [203,155,41,142,43,20,182,4,173,17,120,217,16,92,179,136,172,21,141,186,195,200,211,154,224,238,158,150,140,174,222,185,159,196,234,189,216,44,57,77,226,160,66,202,156,
                       47,170,49,40,53,127,144,51,89,88,194,10,5,149,165,59,225,135,213,232,99,218,163,100,8,121,52,28,112,6,82,80,162,131,184,67,58,56,1,71,230,46,113,39,26]) or
                       (Prm.AptekaID=257)) then

   begin
   // MainF.MessBox('������ �� ��������� ������� �� ��������� �� ������ "�������� �� ���������"');
    FlagD:=0;
    DialogF:=TDialogF.Create(Self);
    try

     DialogF.Label1.Caption:= '������ �� ��������� ������� �� ��������� �� ������ "�������� �� ���������"';
     DialogF.BitBtn2.Caption:='������...';

     DM.Qr7.Close;
     DM.Qr7.SQL.Text:='select Value from Spr_Const where Descr=''PasswTerminal'' ';
     DM.Qr7.Open;

     if DM.Qr7.IsEmpty then DialogF.Passw:='0523574825'
                       else DialogF.Passw:=DM.Qr7.FieldByName('Value').AsString;

     Application.ProcessMessages;
     DialogF.ShowModal;
     if FlagD=1 then
      begin
       Flag:=1;
       Close;
      end;
    finally
     DialogF.Free;
    end;
   end else begin
             Flag:=1;
             Close;
            end;
 }
  if (CP.IsTerminal=False) and  (Not (CP.TypeOplatBS in [DO_BEZGOT1,DO_BEZGOT3])) then
   begin
    if MainF.MessBox('���� �� �������, ��� ������ �� ��������� ������ ������� (�������� ���������� 2 ����), ������� "��"'+#10#10+
               '���� ������������, � ��� ��� ������ ������ �������, ������� "���"!'+#10+
               '������ ������� �� ������ ������ �� ���������, ����� �� �������� 3700 (������ � ��������� � ������������ ��������� ����������)!',52,GetFont('MS Sans Serif',12,clBlue,[fsBold]),0,Res)=ID_YES then
     begin

      if BitBtn3.Tag=2 then BitBtn3Click(BitBtn3);

      Flag:=1;
      Close;
     end;
   end else begin
             Flag:=1;
             Close;
            end;
 end;

procedure TBankCard_old_F.FormCreate(Sender: TObject);
 begin
  Flag:=0;
  Caption:=MFC;
  StartTerminal:=False;

  BitBtn3.Caption:='�������� �� ���������';
  BitBtn3.Tag:=1;
 end;

procedure TBankCard_old_F.BitBtn3Click(Sender:TObject);
(*
var i,nC,eI,rSum,Sum:Integer;
    S1,ss,eS,S,Res:String;
    IsTerminate:Boolean;

 procedure tWait;
 var Res:Integer;
     T:TDateTime;
  begin
   Label5.Visible:=True;
   T:=Time;
   AppendStringToFile('D:\AVA\TerminalLog.txt',DateTimeToStr(Now)+': ������ �������� ������ �� ���������');
   Repeat
    Res:=Terminal.GetLastResult;
    if Time-T>StrToTime('00:03:00') then
     begin
      StartTerminal:=False;
      IsTerminate:=True;
     end;
    if (Res<>2) or (StartTerminal=False) then Break;
    Application.ProcessMessages;
   Until False;
   AppendStringToFile('D:\AVA\TerminalLog.txt',DateTimeToStr(Now)+': ����� �������� ������ �� ���������');
   if StartTerminal=False then Terminal.Cancel;
   Label5.Visible:=False;

  end;
*)
var
  i, Sum, eI: Integer;
  IsTerminate: Boolean;
  eS, Res: String;
//      , nC, rSum: Integer;
//    S1, ss, , S: String;

  procedure tWait;
  var
    T: TDateTime;
    Res: Integer;
  begin
    Label5.Visible:=True;
    T:=Time;
    AppendStringToFile('D:\AVA\TerminalLog.txt',DateTimeToStr(Now)+': ������ �������� ������ �� ���������');
    Repeat
      Res:=Terminal.GetLastResult;
      if Time-T>StrToTime('00:03:00') then
      begin
        StartTerminal:=False;
        IsTerminate:=True;
      end;
      if (Res<>2) or (not StartTerminal) then Break;
      Application.ProcessMessages;
    Until False;
    AppendStringToFile('D:\AVA\TerminalLog.txt',DateTimeToStr(Now)+': ����� �������� ������ �� ���������');
    if not StartTerminal then Terminal.Cancel;
    Label5.Visible:=False;
  end;

  procedure WaitResponse(T: OleVariant);
  var
    LastStMsCode: Integer;
  begin
    LastStMsCode:=0;

    while (T.LastResult = 2) do
    begin
      if (T.LastStatMsgCode <> 0)and(T.LastStatMsgCode <> LastStMsCode) then
        LastStMsCode:=T.LastStatMsgCode;
    end;
    CP.BankCardNum:=Term.PAN;
    CP.RRN:=Term.RRN;
  end;

begin
  if Not EKKA.fpCashState(0) then
  begin
    MainF.MessBox('�������� ����� �� �������!'+#13+
                  '�������� �������� ����� � ��������� ������!');
    Exit;
  end;
  if BitBtn3.Tag=2 then
  begin
    if MainF.MessBox('�� ������������� ������ �������� ������ �� ���������?',52)<>ID_YES then Exit;
    StartTerminal:=False;
    Exit;
  end;

  if MainF.MessBox('�� ������������� ������ ��������� ������ �� ���������?',52)<>ID_YES then Exit;
  try
    try
      StartTerminal:=True;
      BitBtn3.Tag:=2;
      BitBtn3.Caption:='�������� ������ �� ���������';
      if Opt.TypeTerminal<>3 then
      begin
        for i:=1 to 2 do
        begin
          AppendStringToFile('D:\AVA\TerminalLog.txt',DateTimeToStr(Now)+': ������ ������');

          if StartTerminal then
          begin
            Sum:=Round(CP.SumOplata*100);
            Terminal.PosPurchase(Sum,0,' ');
          end;
          IsTerminate:=False;
          tWait;
          AppendStringToFile('D:\AVA\TerminalLog.txt',DateTimeToStr(Now)+': ���������� ������');

          if IsTerminate then
          begin
            AppendStringToFile('D:\AVA\TerminalLog.txt',DateTimeToStr(Now)+': ������ ��������');
            if ShowTextQ('����� �������� �� ��������� �������! '+
                         '���� �� �������, ��� ������ �� ��������� ������ ������� (�������� �������� 2 ����), ������� "��"'+#10#10+
                         '���� ������������, � ��� ��� ������ ������ �������, ������� "���"!'+#10+
                         '������ ������� �� ������ ������ �� ���������, ����� �� �������� 3700 (������ � ��������� � ������������ ��������� ����������)!',52) then
            begin
              BitBtn1Click(BitBtn1);
              Exit;
           end
           else
             Exit;
          end;

          if (Terminal.GetLastResult=1) or (StartTerminal=False)  then
          begin
            if Terminal.GetLastResult=1 then
            begin
              eI:=Terminal.GetLastErrorCode;
              eS:=Terminal.GetLastErrorText;
              eS:='������: '+IntToStr(eI)+' - '+eS;
            end;
            AppendStringToFile('D:\AVA\TerminalLog.txt',DateTimeToStr(Now)+': '+eS);
            if Pos(AnsiUpperCase('Device was disconnected'),AnsiUpperCase(eS))<>0 then
            begin
              MainF.InitTerminal;
              Continue;
            end
            else
              if (Pos(AnsiUpperCase('Com port error'),AnsiUpperCase(eS))<>0) or (Pos(AnsiUpperCase('Error sending message'),AnsiUpperCase(eS))<>0) then
               begin
                 if MainF.InitPortTerminal then Continue;
               end;
            AppendStringToFile('D:\AVA\TerminalLog.txt',DateTimeToStr(Now)+': ������ ��������1');
            MainF.MessBox('������ ��������.'+eS);

            DM.QrEx.Close;
            DM.QrEx.SQL.Clear;
            DM.QrEx.SQL.Add('insert into TerminalLog(mess,dt,id_user)');
            DM.QrEx.SQL.Add('values('''+eS+''',getdate(),'+IntToStr(Prm.UserID)+')');
            DM.QrEx.SQL.Add('select 9999 as Res ');
            DM.QrEx.Open;

            Break;
          end
          else
          begin
            CP.SumOplata:=0.01*Terminal.getTotalAmount;
            CP.IsTerminal:=True;
            MainF.IsTerminal:=CP.IsTerminal;

            if RoundTo(Sum/100,-2)<RoundTo(CP.SumOplata,-2) then
              MainF.MessBox('����� ����������� �� ��������� �� ��������� � �����������. ��������� ������� � ������� '+CurrToStrF(RoundTo(CP.SumOplata-Sum/100,-2),ffFixed,2)+' ������� �� ���������!',
                             48,GetFont('MS Sans Serif',12,clBlue,[fsBold]),0,Res);

            AppendStringToFile('D:\AVA\TerminalLog.txt',CurrToStrF(Sum/100,ffFixed,2)+' - '+CurrToStrF(CP.SumOplata,ffFixed,2));
            MainF.MessBox('������ �� ��������� ������ �������!',64);
            BitBtn3.Enabled:=False;

            Cp.InvoiceNum:=Terminal.getInvoiceNum;
            CP.Merchant:=Terminal.getExtraMerchName;

            BitBtn1Click(BitBtn1);
            Break;
          end;
        end;
      end
      else
      begin
        //������ �� ��������� ������ TPC/IP
        if (Length(trim(Opt.TcpIpAddressTerminal))<=0)or(Opt.TcpIpPortTerminal=0) then
        begin
          MainF.MessBox('�� ������� IP-����� ��� ���� ���������!'+#13+'���������� � IT-�����!');
          Exit;
        end;

        try
          Term:=CreateOleObject('ECRCommX.BPOS1Lib');
          Term.CommClose;
          Term.CommOpenTCP(Opt.TcpIpAddressTerminal,Opt.TcpIpPortTerminal);

          AppendStringToFile('D:\AVA\TerminalLog.txt',DateTimeToStr(Now)+': ������ ������');

          if StartTerminal then
          begin
            Sum:=Round(CP.SumOplata*100);
            Term.Purchase(Sum,0,StrToIntDef(Term.MerchantID,1));
          end;
          IsTerminate:=False;

          WaitResponse(oleVariant(Term));
          if length(trim(CP.BankCardNum)) <= 0 then CP.BankCardNum:='000000000000000';
          AppendStringToFile('D:\AVA\TerminalLog.txt',DateTimeToStr(Now)+': ���������� ������');

          if IsTerminate then
          begin
            AppendStringToFile('D:\AVA\TerminalLog.txt',DateTimeToStr(Now)+': ������ ��������');
            if ShowTextQ('����� �������� �� ��������� �������! '+
                         '���� �� �������, ��� ������ �� ��������� ������ ������� (�������� �������� 2 ����), ������� "��"'+#10#10+
                         '���� ������������, � ��� ��� ������ ������ �������, ������� "���"!'+#10+
                         '������ ������� �� ������ ������ �� ���������, ����� �� �������� 3700 (������ � ��������� � ������������ ��������� ����������)!',52) then
            begin
              BitBtn1Click(BitBtn1);
              Exit;
           end
           else
             Exit;
          end;

          if (Term.LastResult=1) or (not StartTerminal)  then
          begin
            if Term.LastResult=1 then
            begin
              eI:=Term.LastErrorCode;
              eS:=Term.LastErrorDescription;
              eS:='������: '+IntToStr(eI)+' - '+eS;
            end;
            AppendStringToFile('D:\AVA\TerminalLog.txt',DateTimeToStr(Now)+': '+eS);
            AppendStringToFile('D:\AVA\TerminalLog.txt',DateTimeToStr(Now)+': ������ ��������!');
            MainF.MessBox('������ ��������.'+eS);

            DM.QrEx.Close;
            DM.QrEx.SQL.Clear;
            DM.QrEx.SQL.Add('insert into TerminalLog(mess,dt,id_user)');
            DM.QrEx.SQL.Add('values('''+eS+''',getdate(),'+IntToStr(Prm.UserID)+')');
            DM.QrEx.SQL.Add('select 9999 as Res ');
            DM.QrEx.Open;
          end
          else
          begin
            if Term.LastResult=0 then Term.Confirm;
            CP.SumOplata:=0.01*Term.Amount;
            CP.IsTerminal:=True;
            MainF.IsTerminal:=CP.IsTerminal;

            if RoundTo(Sum/100,-2)<RoundTo(CP.SumOplata,-2) then
              MainF.MessBox('����� ����������� �� ��������� �� ��������� � �����������. ��������� ������� � ������� '+CurrToStrF(RoundTo(CP.SumOplata-Sum/100,-2),ffFixed,2)+' ������� �� ���������!',
                             48,GetFont('MS Sans Serif',12,clBlue,[fsBold]),0,Res);

            AppendStringToFile('D:\AVA\TerminalLog.txt',CurrToStrF(Sum/100,ffFixed,2)+' - '+CurrToStrF(CP.SumOplata,ffFixed,2));
            MainF.MessBox('������ �� ��������� ������ �������!',64);
            BitBtn3.Enabled:=False;

            Cp.InvoiceNum:=Term.InvoiceNum;
            CP.Merchant:=Term.MerchantID;
            //CP.RRN:=Term.RRN;
            MainF.RRN:=CP.RRN;
            MainF.BankCard:=CP.BankCardNum;

            BitBtn1Click(BitBtn1);
          end;
        finally
          Term.CommClose;
        end;
      end;
    finally
      BitBtn3.Caption:='�������� �� ���������';
      StartTerminal:=False;
      BitBtn3.Tag:=1;
    end;
  except
    on E:Exception do MainF.MessBox('������ ������ �� ���������: '+E.Message);
  end;
(*
  if BitBtn3.Tag=2 then
   begin
    if MainF.MessBox('�� ������������� ������ �������� ������ �� ���������?',52)<>ID_YES then Exit;
    StartTerminal:=False;
    Exit;
   end;

  if MainF.MessBox('�� ������������� ������ ��������� ������ �� ���������?',52)<>ID_YES then Exit;
  try
   try
    StartTerminal:=True;
    BitBtn3.Tag:=2;
    BitBtn3.Caption:='�������� ������ �� ���������';
    for i:=1 to 2 do
     begin
      AppendStringToFile('D:\AVA\TerminalLog.txt',DateTimeToStr(Now)+': ������ ������');

      if StartTerminal=True then
       begin
        Sum:=Round(CP.SumOplata*100);
        Terminal.PosPurchase(Sum,0,' ');
       end;
      IsTerminate:=False;
      tWait;
      AppendStringToFile('D:\AVA\TerminalLog.txt',DateTimeToStr(Now)+': ���������� ������');

      if IsTerminate then
       begin
        AppendStringToFile('D:\AVA\TerminalLog.txt',DateTimeToStr(Now)+': ������ ��������');
        if ShowTextQ('����� �������� �� ��������� �������! '+
                     '���� �� �������, ��� ������ �� ��������� ������ ������� (�������� �������� 2 ����), ������� "��"'+#10#10+
                     '���� ������������, � ��� ��� ������ ������ �������, ������� "���"!'+#10+
                     '������ ������� �� ������ ������ �� ���������, ����� �� �������� 3700 (������ � ��������� � ������������ ��������� ����������)!',52) then
         begin
          BitBtn1Click(BitBtn1);
          Exit;
         end else Exit;
       end;

      if (Terminal.GetLastResult=1) or (StartTerminal=False)  then
       begin
        if Terminal.GetLastResult=1 then
         begin
          eI:=Terminal.GetLastErrorCode;
          eS:=Terminal.GetLastErrorText;
          eS:='������: '+IntToStr(eI)+' - '+eS;
         end;
        AppendStringToFile('D:\AVA\TerminalLog.txt',DateTimeToStr(Now)+': '+eS);
        if Pos(AnsiUpperCase('Device was disconnected'),AnsiUpperCase(eS))<>0 then
         begin
          MainF.InitTerminal;
          Continue;
         end else
        if (Pos(AnsiUpperCase('Com port error'),AnsiUpperCase(eS))<>0) or (Pos(AnsiUpperCase('Error sending message'),AnsiUpperCase(eS))<>0) then
         begin
          if MainF.InitPortTerminal then Continue;
         end;
        AppendStringToFile('D:\AVA\TerminalLog.txt',DateTimeToStr(Now)+': ������ ��������1');
        MainF.MessBox('������ ��������.'+eS);

        DM.QrEx.Close;
        DM.QrEx.SQL.Clear;
        DM.QrEx.SQL.Add('insert into TerminalLog(mess,dt,id_user)');
        DM.QrEx.SQL.Add('values('''+eS+''',getdate(),'+IntToStr(Prm.UserID)+')');
        DM.QrEx.SQL.Add('select 9999 as Res ');
        DM.QrEx.Open;

        Break;
       end else begin
                 CP.SumOplata:=0.01*Terminal.getTotalAmount;
                 CP.IsTerminal:=True;
                 MainF.IsTerminal:=CP.IsTerminal;

                 if RoundTo(Sum/100,-2)<RoundTo(CP.SumOplata,-2) then
                  MainF.MessBox('����� ����������� �� ��������� �� ��������� � �����������. ��������� ������� � ������� '+CurrToStrF(RoundTo(CP.SumOplata-Sum/100,-2),ffFixed,2)+' ������� �� ���������!',
                           48,GetFont('MS Sans Serif',12,clBlue,[fsBold]),0,Res);

                 AppendStringToFile('D:\AVA\TerminalLog.txt',CurrToStrF(Sum/100,ffFixed,2)+' - '+CurrToStrF(CP.SumOplata,ffFixed,2));
               //  AppendStringToFile('D:\AVA\TerminalLog.txt',CurrToStrF(CP.SumOplata,ffFixed,2));
                 //MainF.MessBox('������ �� ��������� ������ �������. ��������� �� �����, ������� ����� �������� ������ ������ ��� ���!',64);
                 MainF.MessBox('������ �� ��������� ������ �������!',64);
                 BitBtn3.Enabled:=False;

                 Cp.InvoiceNum:=Terminal.getInvoiceNum;
                 CP.Merchant:=Terminal.getExtraMerchName;

{                 if edCard.Text='' then
                  Repeat
                   if EnterIntValue(nC,'������� 4 ��������� ����� ������ ���������� ��������!') then
                    begin
                     edCard.Text:=IntToStr(nC);
                     Break;
                    end;
                  Until False;
}
                 BitBtn1Click(BitBtn1);
                 Break;
                end;
     end;
   finally
    BitBtn3.Caption:='�������� �� ���������';
    StartTerminal:=False;
    BitBtn3.Tag:=1;
   end;
  except
   on E:Exception do MainF.MessBox('������ ������ �� ���������: '+E.Message);
  end;
*)
end;

procedure TBankCard_old_F.FormActivate(Sender:TObject);
 begin
  if CP.TypeOplatBS in [DO_BEZGOT1,DO_BEZGOT3] then BitBtn3.Enabled:=False;
  {
   try
    DM.Qr7.Close;
    DM.Qr7.SQL.Text:='select Value from Spr_Const where Descr=''Terminal'' ';
    DM.Qr7.Open;
    if DM.Qr7.IsEmpty then Abort;
    if DM.Qr7.FieldByName('Value').AsInteger=0 then Abort;
   except
    Height:=140;
   end;
  }
 end;

end.

// � ��� ����� �� ������� ������� ����������� ����� ��������� ������� ����� ,













