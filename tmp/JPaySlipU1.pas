unit JPaySlipU1;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
     Dialogs, Grids, DBGrids, StdCtrls, ExtCtrls, ComCtrls, Buttons, DateUtils,
     PrintReport, Util;

type

  TJPaySlipF1 = class(TForm)

    Panel1: TPanel;
    Label1: TLabel;
    DBGrid1: TDBGrid;
    Label2: TLabel;
    dtStart: TDateTimePicker;
    dtEnd: TDateTimePicker;
    BitBtn1: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn2: TBitBtn;
    Label8: TLabel;
    ComboBox2: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);

  private

    procedure FilterSpis;

  public

  end;

var JPaySlipF1: TJPaySlipF1;

implementation

uses MainU, DataModuleU, DB;

{$R *.dfm}

procedure TJPaySlipF1.FormCreate(Sender: TObject);
 begin
  Caption:=MFC;
  dtStart.Date:=StartOfTheMonth(Date);
  dtEnd.Date:=EndOfTheMonth(Date);
  FilterSpis;
 end;

procedure TJPaySlipF1.BitBtn4Click(Sender: TObject);
 begin
  Close;
 end;

procedure TJPaySlipF1.FilterSpis;
 begin
  try

   DM.qrJPaySlip1.Close;
   DM.qrJPaySlip1.SQL.Clear;

   DM.qrJPaySlip1.SQL.Add('select ������,_period as dt ');
   DM.qrJPaySlip1.SQL.Add('from ZPLIST_VIEW (nolock) ');
   DM.qrJPaySlip1.SQL.Add('where _period between '''+FormatDateTime('yyyy-mm-dd',dtStart.Date)+''' and '''+FormatDateTime('yyyy-mm-dd',dtEnd.Date)+''' ');

   DM.qrJPaySlip1.SQL.Add(' and [��]='+IntToStr(Prm.ID_Gamma));

   DM.qrJPaySlip1.SQL.Add('group by ������,_period ');
   DM.qrJPaySlip1.SQL.Add('order by ������,_period ');

{
   DM.qrJPaySlip.SQL.Add('select cast(id_payslip as uniqueidentifier) as id_payslip,Max(dt_begin) as dt_begin,Max(dt_end) as dt_end ');
   DM.qrJPaySlip.SQL.Add('from PaySlip (nolock) ');
   DM.qrJPaySlip.SQL.Add('where dt_begin>='''+FormatDateTime('yyyy-mm-dd',dtStart.Date)+''' and dt_end+1<='''+FormatDateTime('yyyy-mm-dd',dtEnd.Date)+''' ');

   if Prm.UserRole=R_SUPER then
    DM.qrJPaySlip.SQL.Add(' and ')
   else
    DM.qrJPaySlip.SQL.Add(' and id_gamma='+IntToStr(Prm.ID_Gamma));

   DM.qrJPaySlip.SQL.Add(' and id_apteka='+IntToStr(Prm.AptekaID));
   DM.qrJPaySlip.SQL.Add('group by cast(id_payslip as uniqueidentifier) ');
}

   DM.qrJPaySlip1.Open;
  except
   on E:Exception do MainF.MessBox('������ ������� � ��������� ������: '+E.Message);
  end;

 end;

procedure TJPaySlipF1.BitBtn1Click(Sender:TObject);
 begin
  FilterSpis;
 end;

procedure TJPaySlipF1.DBGrid1DblClick(Sender:TObject);
 begin
  BitBtn2Click(BitBtn2);
 end;

(*
procedure TJPaySlipF1.BitBtn2Click(Sender: TObject);
var i,j,q,y:Integer;
    Tb:TTableObj;
    Sum1,Sum2:Currency;
 begin

  if DM.qrJPaySlip1.IsEmpty then Exit;
  DM.Qr.SQL.Clear;
  DM.Qr.SQL.Add('select * ');
  DM.Qr.SQL.Add('from vZPLIST_VIEW (nolock) ');
  DM.Qr.SQL.Add('where [��]='+IntToStr(Prm.ID_Gamma));
  DM.Qr.SQL.Add('      and _period='''+FormatDateTime('yyyy-mm-dd',DM.qrJPaySlip1.FieldByname('dt').AsDateTime)+''' ');
  DM.Qr.Open;
  PrintRep.Clear;
  PrintRep.SetDefault;
  PrintRep.Font.Name:='Arial';

  Sum1:=0; Sum2:=0;
  for i:=1 to DM.Qr.RecordCount do
   begin
    if i=1 then DM.Qr.First else DM.Qr.Next;
    PrintRep.Font.Size:=5;
    PrintRep.AddText('������: '+DM.Qr.FieldByName('_period').AsString+#10);
    PrintRep.AddText('������: '+DM.Qr.FieldByName('����������').AsString+' '+DM.Qr.FieldByname('������').AsString+#10#10);
//    PrintRep.AddText('���: '+DM.Qr.FieldByname('���').AsString+#10#10);

    PrintRep.Font.Size:=4;
    q:=0;
    for j:=7 to DM.Qr.FieldCount-3 do
     if (DM.Qr.Fields[j].AsString<>'0') and (DM.Qr.Fields[j].AsString<>'') then Inc(q);

    PrintRep.AddTable(2,q);
    Tb:=PrintRep.LastTable;

    y:=0;
    for j:=7 to DM.Qr.FieldCount-3 do
     if (DM.Qr.Fields[j].AsString<>'0') and (DM.Qr.Fields[j].AsString<>'') then
      begin
       Inc(y);
       Tb.Cell[1,y].AddText(DM.Qr.Fields[j].FieldName);
       Tb.Cell[2,y].Align:=AL_RIGHT;
       Tb.Cell[2,y].AddText(DM.Qr.Fields[j].AsString);
      end;

    PrintRep.AddInterv(10);

    Sum1:=Sum1+DM.Qr.FieldByName('��������� �����').AsCurrency;
    Sum2:=Sum2+DM.Qr.FieldByName('�������� �����').AsCurrency;

   end;

  PrintRep.Indent:=0;
  PrintRep.Font.Size:=5;
  PrintRep.AddText(#10);
  PrintRep.AddText('��������� �����: '+CurrToStrF(Sum1,ffFixed,2)+#10);
  PrintRep.AddText('�������� �����: '+CurrToStrF(Sum2,ffFixed,2));

  PrintRep.PreView;
 end;    *)

procedure TJPaySlipF1.BitBtn2Click(Sender: TObject);
var r1,r2,r3,r4,r5,r6,r7,ind,CA,i,j,q,y,rn1,rn2,rn3,rn4,rn5,rn6,rn7:Integer;
    Tb:TTableObj;
    SumPPM,Sm,Sum1,Sum2,Sum3,SumN1,SumN2,SumN3,SumN4,SumN4_,SumN5,SumN6,SumH,SumV,SumD,SumR,SumN_1,SumN_2,SumN_3,SumN_4,SumN_5:Currency;
    A:Array of Integer;
    Ch:Char;
    B:Boolean;
    s1:String;
 begin

  if DM.qrJPaySlip1.IsEmpty then Exit;
  DM.Qr.SQL.Clear;
  DM.Qr.SQL.Add('select * ');
  DM.Qr.SQL.Add('from vZPLIST_VIEW (nolock) ');
  DM.Qr.SQL.Add('where [��]='+IntToStr(Prm.ID_Gamma));
  DM.Qr.SQL.Add('      and _period='''+FormatDateTime('yyyy-mm-dd',DM.qrJPaySlip1.FieldByname('dt').AsDateTime)+''' ');
  DM.Qr.Open;
  PrintRep.Clear;
  PrintRep.SetDefault;
  PrintRep.Font.Name:='Arial';

  SetLength(A,0);

  s1:='���������� �����';
  for j:=6 to DM.Qr.FieldCount-1 do
   begin
    B:=False;
    for i:=1 to DM.Qr.RecordCount do
     begin
      if i=1 then DM.Qr.First else DM.Qr.Next;
      if (DM.Qr.Fields[j].AsString<>'0') and (DM.Qr.Fields[j].AsString<>'') then
       begin
        if DM.Qr.Fields[j].FieldName='�������� ����������� ������' then s1:=DM.Qr.Fields[j].FieldName;
        q:=j;
        B:=True;
        Break;
       end;
     end;
    if B then
     begin
      CA:=High(A)+1;
      SetLength(A,CA+1);
      A[CA]:=q;
     end;
   end;

  PrintRep.Font.Size:=5;

  PrintRep.AddText(IntToStr(Prm.ID_Gamma)+#10#10);
//  PrintRep.AddText('������: '+DM.Qr.FieldByName('����������').AsString+' '+DM.Qr.FieldByname('������').AsString+#10#10);

  PrintRep.Font.Size:=3;
  PrintRep.AddTable(DM.Qr.RecordCount+3,High(A)+3+12);

  Tb:=PrintRep.LastTable;
  Tb.ColWidths[1]:=150;
  Tb.ColWidths[2]:=500;
  Tb.ColWidths[3]:=200;
  y:=0; ind:=0;

  Tb.Cell[1,1].Font.Size:=4; Tb.Cell[1,1].Align:=AL_CENTER; Tb.Cell[1,1].AddText('� �/�');
  Tb.Cell[2,1].Font.Size:=4; Tb.Cell[2,1].Align:=AL_CENTER; Tb.Cell[2,1].AddText('������������ ����������');
  Tb.Cell[3,1].Font.Size:=4; Tb.Cell[3,1].Align:=AL_CENTER; Tb.Cell[3,1].AddText('�������� �������');

//  Tb.MergeCells(4,1,3+DM.Qr.RecordCount,1);
  Tb.Cell[4,1].Font.Size:=5; Tb.Cell[4,1].Align:=AL_CENTER; Tb.Cell[4,1].AddText('������: '+Trim(DM.Qr.FieldByName('_period').AsString));
  r7:=-1; r6:=-1;   rn1:=-1; rn2:=-1; rn3:=-1; rn4:=-1; rn5:=-1; rn6:=-1; rn7:=-1;
  for j:=Low(A) to High(A) do
   begin

    Inc(y);
    Inc(ind);
    Tb.Cell[2,y+1].Align:=AL_CENTER;

    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('��� ������') then Tb.Cell[3,y+1].AddText('������');
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('��������� ������') then Tb.Cell[3,y+1].AddText('�������1');
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('�������� ������� ����� ������') then Tb.Cell[3,y+1].AddText('������ �.1 - �');
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('�������� ������� �� ��� ������') then Tb.Cell[3,y+1].AddText('������ �.1 - �');
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('�������� �� ��� ������') then Tb.Cell[3,y+1].AddText('��������� �� ������ �����');
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('�������� �� �����������') then Tb.Cell[3,y+1].AddText('��������� �� ������ �����');
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('������������ ����') then Tb.Cell[3,y+1].AddText('������');
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('� �. �. ������������ ���� ��������') then Tb.Cell[3,y+1].AddText('������');
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('������������ ���� �����') then Tb.Cell[3,y+1].AddText('������');
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('� �. �. ������������ ���� � ������. ���') then Tb.Cell[3,y+1].AddText('������');
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('� �. �. ������������ ���� �����������') then Tb.Cell[3,y+1].AddText('������');
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('������� ���������� �� ������') then Tb.Cell[3,y+1].AddText('������/����� ��');
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('������� �����') then Tb.Cell[3,y+1].AddText('�������� �������');
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('������� �� ��� ����������') then Tb.Cell[3,y+1].AddText('������ �.8 - �');
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('����������� ���������� ��������� ������� �� ���') then Tb.Cell[3,y+1].AddText('������ �.8 - �');
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('�������� �� �������') then Tb.Cell[3,y+1].AddText('������� 3');
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('����� �� �����') then Tb.Cell[3,y+1].AddText('������ �.2 - �');
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('������� �� ��������') then Tb.Cell[3,y+1].AddText('������ �.2 - �');
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('������� �� �����������') then Tb.Cell[3,y+1].AddText('������ �.2 - �');
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('������ �� ����������') then Tb.Cell[3,y+1].AddText('������ �.3 - �');
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('������ �� ������������ ���������������') then Tb.Cell[3,y+1].AddText('������ �.3 - �');
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('������ �� �����������') then Tb.Cell[3,y+1].AddText('������ �.4');
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('������ �� �����������') then Tb.Cell[3,y+1].AddText('������ �.4');
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('������ �� �������') then Tb.Cell[3,y+1].AddText('������ �.8');
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('������ �� �������') then Tb.Cell[3,y+1].AddText('������ �.9');
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('������� �� ������ � ������ �����') then Tb.Cell[3,y+1].AddText('������ �.2 - �');
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('������� �� ���������') then Tb.Cell[3,y+1].AddText('������ �.2 - �');


//    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('���������� �����') then Tb.Cell[3,y+1].AddText('����� � 20 �� 27');

    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('����������') then Tb.Cell[3,y+1].AddText('������ �.5');
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('���������') then Tb.Cell[3,y+1].AddText('������ �.6');
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('����������') then Tb.Cell[3,y+1].AddText('������ �.7');
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('������') then Tb.Cell[3,y+1].AddText('������ �.9');

    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('������������ �������') then Tb.Cell[3,y+1].AddText('������ �.11');

    if Copy(AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName),1,20)=AnsiLowerCase('���������� ������ ��') then Tb.Cell[3,y+1].AddText('������� �������. ��������');

    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase(s1) then
     begin
      r1:=y+1;
      Inc(y);
     end;

    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('������������ ���� �����') then
     begin
      r5:=y+1;
      Tb.Cell[2,y+1].Font.Style:=[fsBold];
     end;

    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('������� �����') then
     begin
      r4:=y+1;
      Tb.Cell[2,y+1].Font.Style:=[fsBold];
     end;

    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('�����') then
     begin
      r2:=y+1;
      Tb.Cell[2,y+1].Font.Style:=[fsBold];
     end;

    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('������') then  r6:=y+1;
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('������������ �������') then  r7:=y+1;


    Tb.Cell[2,y+1].Align:=AL_CENTER;
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase(s1) then
     begin
      Tb.Cell[2,y].AddText(s1);
      Tb.Cell[2,y+1].AddText('���������� ����� �����');
     end else Tb.Cell[2,y+1].AddText(DM.Qr.Fields[A[j]].FieldName);

    Tb.Cell[1,y+1].Align:=AL_RIGHT;
    Tb.Cell[1,y+1].AddText(IntToStr(ind));

    Tb.Cell[3,y+1].Align:=AL_CENTER;


    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('�����') then Inc(y);
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('������� �����') then Inc(y);

    {
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('��������� �����') then
     begin
      r3:=y+1;
     end;
    }

    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('���������� ������ �� ������������� ���') then begin rn1:=y+1; Tb.Cell[4,y+1].Align:=AL_CENTER; end;
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('���������� ������ �� ������������ �����. �����������') then begin  rn2:=y+1;  Tb.Cell[4,y+1].Align:=AL_CENTER; end;
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('���������� ������ �� ������������ ������ �������. ��������.') then begin  rn3:=y+1;  Tb.Cell[4,y+1].Align:=AL_CENTER; end;
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('���������� ������ �� �����. ������ �������. ����. �������� ��� ����������') then begin  rn4:=y+1;  Tb.Cell[4,y+1].Align:=AL_CENTER; end;
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('�����') then rn5:=y+1;
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('���������� ������ �� ��������� ������ �������� ����������') then rn6:=y+1;
    if AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('����� � ����������') then rn7:=y+1;


   end;

//  Tb.MergeCells(2,r1,2,r1+1);
  Tb.MergeCells(4,r1+1,3+DM.Qr.RecordCount,r1+1);
  Tb.MergeCells(4,r2,3+DM.Qr.RecordCount,r2);
  Tb.MergeCells(1,r2+1,3+DM.Qr.RecordCount,r2+1);
  Tb.MergeCells(4,r3,3+DM.Qr.RecordCount,r3);

  Tb.MergeCells(4,r4,3+DM.Qr.RecordCount,r4);
  Tb.MergeCells(1,r4+1,3+DM.Qr.RecordCount,r4+1);

  Tb.MergeCells(4,r5,3+DM.Qr.RecordCount,r5);

  if r6<>-1 then Tb.MergeCells(4,r6,3+DM.Qr.RecordCount,r6);
  if r7<>-1 then Tb.MergeCells(4,r7,3+DM.Qr.RecordCount,r7);

  if rn1<>-1 then Tb.MergeCells(4,rn1,3+DM.Qr.RecordCount,rn1);
  if rn2<>-1 then Tb.MergeCells(4,rn2,3+DM.Qr.RecordCount,rn2);
  if rn3<>-1 then Tb.MergeCells(4,rn3,3+DM.Qr.RecordCount,rn3);
  if rn4<>-1 then Tb.MergeCells(4,rn4,3+DM.Qr.RecordCount,rn4);
  if rn7<>-1 then Tb.MergeCells(4,rn7,3+DM.Qr.RecordCount,rn4);

  Sum1:=0; Sum2:=0; Sum3:=0; SumH:=0; SumV:=0; SumD:=0; SumN5:=0;
  SumN_1:=0; SumN_2:=0; SumN_3:=0; SumN_4:=0; SumN_5:=0;
  SumPPM:=0;
  for i:=1 to DM.Qr.RecordCount do
   begin
    if i=1 then DM.Qr.First else DM.Qr.Next;
//    PrintRep.AddText('���: '+DM.Qr.FieldByname('���').AsString+#10#10);

    y:=0;
    for j:=Low(A) to High(A) do
     begin
      Inc(y);
      Tb.Cell[i+3,y+1].Align:=AL_RIGHT;

      if (y+1=rn1) or (y+1=rn2) or (y+1=rn3) or (y+1=rn4) or (y+1=rn5) or (y+1=rn6) or (y+1=rn7) then Tb.Cell[i+3,y+1].Align:=AL_CENTER;

      if (AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)=AnsiLowerCase('�������� ����������� ������')) then
       begin
        SumPPM:=SumPPM+DM.Qr.Fields[A[j]].AsCurrency;
        Tb.Cell[i+3,y+1].AddText(CurrToStrF(-DM.Qr.Fields[A[j]].AsCurrency,ffFixed,2));

       end else

      if (AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)<>AnsiLowerCase('��������� �����')) and
         (AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)<>AnsiLowerCase('�����')) and
         (AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)<>AnsiLowerCase('������� �����')) and
         (AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)<>AnsiLowerCase('������')) and
         (AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)<>AnsiLowerCase('������������ ���� �����')) and
         (AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)<>AnsiLowerCase('���������� ������ �� ������������� ���')) and
         (AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)<>AnsiLowerCase('���������� ������ �� ������������ �����. �����������')) and
         (AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)<>AnsiLowerCase('���������� ������ �� ������������ ������ �������. ��������.')) and
         (AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)<>AnsiLowerCase('���������� ������ �� �����. ������ �������. ����. �������� ��� ����������')) and
         (AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)<>AnsiLowerCase('����� � ����������')) and

         (AnsiLowerCase(DM.Qr.Fields[A[j]].FieldName)<>AnsiLowerCase('������������ �������')) then
       if (DM.Qr.Fields[A[j]].AsString<>'') and (DM.Qr.Fields[A[j]].AsString<>'0') then Tb.Cell[i+3,y+1].AddText(DM.Qr.Fields[A[j]].AsString);

      if y+1=r1 then Inc(y);
      if y+1=r2 then Inc(y);
      if y+1=r4 then Inc(y);
     end;

    Sum1:=Sum1+DM.Qr.FieldByName('���������� ������ �� ������������� ���').AsCurrency+
               DM.Qr.FieldByName('���������� ������ �� ������������ �����. �����������').AsCurrency+
               DM.Qr.FieldByName('���������� ������ �� ������������ ������ �������. ��������.').AsCurrency+
               DM.Qr.FieldByName('���������� ������ �� �����. ������ �������. ����. �������� ��� ����������').AsCurrency+
//               DM.Qr.FieldByName('����� � ����������').AsCurrency+
               DM.Qr.FieldByName('�����').AsCurrency+
               DM.Qr.FieldByName('���������� ������ �� ��������� ������ �������� ����������').AsCurrency;

    Sum2:=Sum2+DM.Qr.FieldByName('�����').AsCurrency;
    Sum3:=Sum3+DM.Qr.FieldByName('���������� �����').AsCurrency;

    SumH:=SumH+DM.Qr.FieldByName('������������ ���� �����').AsCurrency;
    SumV:=SumV+DM.Qr.FieldByName('������� ���������� �� ������').AsCurrency;
    SumD:=SumD+DM.Qr.FieldByName('������').AsCurrency;
    SumR:=SumR+DM.Qr.FieldByName('������������ �������').AsCurrency;

    SumN_1:=SumN_1+DM.Qr.FieldByName('���������� ������ �� ������������� ���').AsCurrency;
    SumN_2:=SumN_2+DM.Qr.FieldByName('���������� ������ �� ������������ �����. �����������').AsCurrency;
    SumN_3:=SumN_3+DM.Qr.FieldByName('���������� ������ �� ������������ ������ �������. ��������.').AsCurrency;
    SumN_4:=SumN_4+DM.Qr.FieldByName('���������� ������ �� �����. ������ �������. ����. �������� ��� ����������').AsCurrency;
    SumN_5:=SumN_5+DM.Qr.FieldByName('����� � ����������').AsCurrency;

   end;

  Tb.Cell[4,r1+1].Align:=AL_CENTER; Tb.Cell[4,r1+1].Font.Style:=[fsBold]; Tb.Cell[4,r1+1].AddText(CurrToStrF(Sum3-SumPPM,ffFixed,2));

  {Tb.Cell[4,r2].Font.Size:=5;}
  Tb.Cell[4,r2].Align:=AL_CENTER; Tb.Cell[4,r2].Font.Style:=[fsBold];  Tb.Cell[4,r2].AddText(CurrToStrF(Sum2,ffFixed,2));

  Tb.Cell[4,r5].Align:=AL_CENTER; Tb.Cell[4,r5].Font.Style:=[fsBold];  Tb.Cell[4,r5].AddText(CurrToStrF(SumH,ffFixed,2));
  Tb.Cell[4,r4].Align:=AL_CENTER; Tb.Cell[4,r4].Font.Style:=[fsBold];  Tb.Cell[4,r4].AddText(CurrToStrF(SumV,ffFixed,2));

  if rn1<>-1 then begin Tb.Cell[4,rn1].Align:=AL_CENTER; Tb.Cell[4,rn1].AddText(CurrToStrF(SumN_1,ffFixed,2)); end;
  if rn2<>-1 then begin Tb.Cell[4,rn2].Align:=AL_CENTER; Tb.Cell[4,rn2].AddText(CurrToStrF(SumN_2,ffFixed,2)); end;
  if rn3<>-1 then begin Tb.Cell[4,rn3].Align:=AL_CENTER; Tb.Cell[4,rn3].AddText(CurrToStrF(SumN_3,ffFixed,2)); end;
  if rn4<>-1 then begin Tb.Cell[4,rn4].Align:=AL_CENTER; Tb.Cell[4,rn4].AddText(CurrToStrF(SumN_4,ffFixed,2)); end;
  if rn7<>-1 then begin Tb.Cell[4,rn5].Align:=AL_CENTER; Tb.Cell[4,rn7].AddText(CurrToStrF(SumN_5,ffFixed,2)); end;

  if r6<>-1 then
   begin
    Tb.Cell[4,r6].Align:=AL_CENTER; Tb.Cell[4,r6].AddText(CurrToStrF(SumD,ffFixed,2));
   end;

  if r7<>-1 then
   begin
    Tb.Cell[4,r7].Align:=AL_CENTER; Tb.Cell[4,r7].AddText(CurrToStrF(SumR,ffFixed,2));
   end;

//  Tb.Cell[4,r3].Align:=AL_CENTER;   Tb.Cell[4,r3].AddText(CurrToStrF(Sum1,ffFixed,2));


  {-- ��������� �� ������ ��������� ������ ---------------------------------------------------------------------------------------------------------------------------------------}
  DM.qrJPaySlip.Close;
  DM.qrJPaySlip.SQL.Clear;
  DM.qrJPaySlip.SQL.Add('select cast(id_payslip as uniqueidentifier) as id_payslip,Max(dt_begin) as dt_begin,Max(dt_end) as dt_end ');
  DM.qrJPaySlip.SQL.Add('from PaySlip (nolock) ');
  DM.qrJPaySlip.SQL.Add('where dt_begin>='''+FormatDateTime('yyyy-mm-dd',dtStart.Date)+''' and dt_end<='''+FormatDateTime('yyyy-mm-dd',dtEnd.Date)+''' ');

  DM.qrJPaySlip.SQL.Add(' and id_gamma='+IntToStr(Prm.ID_Gamma));

  Ch:=Chr(160);
//  DM.qrJPaySlip.SQL.Add(' and id_apteka='+IntToStr(Prm.AptekaID));
  DM.qrJPaySlip.SQL.Add('group by cast(id_payslip as uniqueidentifier) ');
  DM.qrJPaySlip.Open;

  SumN1:=0; SumN2:=0; SumN3:=0; SumN4:=0; SumN6:=0; SumN4_:=0;
  for i:=1 to DM.qrJPaySlip.RecordCount do
   begin
    if i=1 then DM.qrJPaySlip.First else DM.qrJPaySlip.Next;

    DM.Qr.SQL.Clear;
    DM.Qr.SQL.Add('select * ');
    DM.Qr.SQL.Add('from PAYSLIP (nolock) ');
    DM.Qr.SQL.Add('where cast(id_payslip as uniqueidentifier)= '''+DM.qrJPaySlip.FieldByName('id_payslip').AsString+''' ');
    DM.Qr.SQL.Add('      and Section=''�����������������'' and Param in (6,8) ');
    DM.Qr.SQL.Add('order by numstr,param ');
    DM.Qr.Open;

    //Sm:=StrToFloat(StringReplace(DM.Qr.FieldByName('Value').AsString,',','.',[rfReplaceAll, rfIgnoreCase]));
    if DM.Qr.Locate('Value','����������� ����������������� �������',[]) then begin DM.Qr.Next; SumN6:=SumN6+StrToFloat(StringReplace(StringReplace(DM.Qr.FieldByName('Value').AsString,',','.',[rfReplaceAll, rfIgnoreCase]),Ch,'',[rfReplaceAll, rfIgnoreCase])); end;

    if DM.Qr.Locate('Value','����',[]) then begin DM.Qr.Next; SumN1:=SumN1+StrToFloat(StringReplace(StringReplace(DM.Qr.FieldByName('Value').AsString,',','.',[rfReplaceAll, rfIgnoreCase]),Ch,'',[rfReplaceAll, rfIgnoreCase])); end;

    if DM.Qr.Locate('Value','��������� ��� � ����������� (3,6 %)',[]) then begin DM.Qr.Next; SumN2:=SumN2+StrToFloat(StringReplace(StringReplace(DM.Qr.FieldByName('Value').AsString,',','.',[rfReplaceAll, rfIgnoreCase]),Ch,'',[rfReplaceAll, rfIgnoreCase])); end;
    if DM.Qr.Locate('Value','������� ����',[]) then begin DM.Qr.Next; SumN3:=SumN3+StrToFloat(StringReplace(StringReplace(DM.Qr.FieldByName('Value').AsString,',','.',[rfReplaceAll, rfIgnoreCase]),Ch,'',[rfReplaceAll, rfIgnoreCase])); end;

    if DM.Qr.Locate('Value','��������� ��� �� ���������� ������ (2 %)',[]) then begin DM.Qr.Next; SumN5:=SumN5+StrToFloat(StringReplace(StringReplace(DM.Qr.FieldByName('Value').AsString,',','.',[rfReplaceAll, rfIgnoreCase]),Ch,'',[rfReplaceAll, rfIgnoreCase])); end;


    if DM.Qr.Locate('Value','����������� ������ 0,35%',[]) then begin DM.Qr.Next; SumN4:=SumN4+StrToFloat(StringReplace(StringReplace(DM.Qr.FieldByName('Value').AsString,',','.',[rfReplaceAll, rfIgnoreCase]),Ch,'',[rfReplaceAll, rfIgnoreCase])); end;
    if DM.Qr.Locate('Value','����������� ������ 0,65%',[]) then begin DM.Qr.Next; SumN4:=SumN4+StrToFloat(StringReplace(StringReplace(DM.Qr.FieldByName('Value').AsString,',','.',[rfReplaceAll, rfIgnoreCase]),Ch,'',[rfReplaceAll, rfIgnoreCase])); end;

    if DM.Qr.Locate('Value','��������� �����',[]) then begin DM.Qr.Next; SumN4_:=SumN4_+StrToFloat(StringReplace(StringReplace(DM.Qr.FieldByName('Value').AsString,',','.',[rfReplaceAll, rfIgnoreCase]),Ch,'',[rfReplaceAll, rfIgnoreCase])); end;
   end;

  Inc(y,1);

  Inc(ind); Tb.Cell[1,y+1].Align:=AL_RIGHT; Tb.Cell[1,y+1].AddText(IntToStr(ind)); Tb.Cell[2,y+1].AddText('���������� ����� (���� 15%)');
  Tb.Cell[4,y+1].Align:=AL_CENTER; Tb.Cell[4,y+1].AddText(CurrToStrF(SumN1,ffFixed,2)); Tb.Cell[3,y+1].AddText('����� �������');

  Tb.MergeCells(4,y+1,3+DM.Qr.RecordCount,y+1);

  Inc(ind); Tb.Cell[1,y+2].Align:=AL_RIGHT; Tb.Cell[1,y+2].AddText(IntToStr(ind)); Tb.Cell[2,y+2].AddText('���������� ���� (��� 3.6%)');
  Tb.Cell[4,y+2].Align:=AL_CENTER; Tb.Cell[4,y+2].AddText(CurrToStrF(SumN2,ffFixed,2)); Tb.Cell[3,y+2].AddText('����� �������');
  Tb.MergeCells(4,y+2,3+DM.Qr.RecordCount,y+2);

  Inc(ind); Tb.Cell[1,y+3].Align:=AL_RIGHT; Tb.Cell[1,y+3].AddText(IntToStr(ind)); Tb.Cell[2,y+3].AddText('������� ���� (1.5%)');
  Tb.Cell[4,y+3].Align:=AL_CENTER; Tb.Cell[4,y+3].AddText(CurrToStrF(SumN3,ffFixed,2)); Tb.Cell[3,y+3].AddText('����� �������');
  Tb.MergeCells(4,y+3,3+DM.Qr.RecordCount,y+3);

  Inc(ind); Tb.Cell[1,y+4].Align:=AL_RIGHT; Tb.Cell[1,y+4].AddText(IntToStr(ind)); Tb.Cell[2,y+4].AddText('��������� �� �����. ������ (��� 2%)');
  Tb.Cell[4,y+4].Align:=AL_CENTER; Tb.Cell[4,y+4].AddText(CurrToStrF(SumN5,ffFixed,2));
  Tb.MergeCells(4,y+4,3+DM.Qr.RecordCount,y+4); Tb.Cell[3,y+4].AddText('����� �������');


  Inc(ind); Tb.Cell[1,y+5].Align:=AL_RIGHT; Tb.Cell[1,y+5].AddText(IntToStr(ind)); Tb.Cell[2,y+5].AddText('����������� ����� (1%)');
  Tb.Cell[4,y+5].Align:=AL_CENTER; Tb.Cell[4,y+5].AddText(CurrToStrF(SumN4,ffFixed,2));
  Tb.MergeCells(4,y+5,3+DM.Qr.RecordCount,y+5);

  Inc(ind); Tb.Cell[1,y+6].Align:=AL_RIGHT; Tb.Cell[1,y+6].AddText(IntToStr(ind)); Tb.Cell[2,y+6].AddText('��������� �����');
  Tb.Cell[4,y+6].Align:=AL_CENTER; Tb.Cell[4,y+6].AddText(CurrToStrF(SumN4_,ffFixed,2));
  Tb.MergeCells(4,y+6,3+DM.Qr.RecordCount,y+6);

  Inc(ind); Tb.Cell[1,y+7].Align:=AL_RIGHT; Tb.Cell[1,y+7].AddText(IntToStr(ind)); Tb.Cell[2,y+7].AddText('����������� ����������������� �������');
  Tb.Cell[4,y+7].Align:=AL_CENTER; Tb.Cell[4,y+7].AddText(CurrToStrF(SumN6,ffFixed,2));
  Tb.MergeCells(4,y+7,3+DM.Qr.RecordCount,y+7);


  Inc(ind); Tb.Cell[1,y+8].Align:=AL_RIGHT; Tb.Cell[1,y+8].AddText(IntToStr(ind)); Tb.Cell[2,y+8].Font.Style:=[fsBold]; Tb.Cell[2,y+8].AddText('�����');
  Tb.MergeCells(4,y+8,3+DM.Qr.RecordCount,y+8);



  // ����� �������� ����� �����
  Tb.Cell[4,y+8].Align:=AL_CENTER;
  Tb.Cell[4,y+8].Font.Style:=[fsBold];
  Tb.Cell[4,y+8].AddText(CurrToStrF(Sum1+SumN1+SumN2+SumN3+SumN4+SumN5+SumN6+SumN4_,ffFixed,2));

  Tb.MergeCells(1,y+9,3+DM.Qr.RecordCount,y+9);

  Inc(ind); Tb.Cell[1,y+10].Align:=AL_RIGHT; Tb.Cell[1,y+10].AddText(IntToStr(ind)); Tb.Cell[2,y+10].Font.Style:=[fsBold]; Tb.Cell[2,y+10].AddText('� �������');
  Tb.MergeCells(4,y+10,3+DM.Qr.RecordCount,y+10);

  // � �������
  Tb.Cell[4,y+10].Align:=AL_CENTER;
  Tb.Cell[4,y+10].Font.Style:=[fsBold];
  Tb.Cell[4,y+10].AddText(CurrToStrF(Sum2-(Sum1+SumN1+SumN2+SumN3+SumN4+SumN5+SumN6+SumN4_),ffFixed,2));

{
  PrintRep.Indent:=0;
  PrintRep.Font.Size:=5;
  PrintRep.AddText(#10);
  PrintRep.AddText('��������� �����: '+CurrToStrF(Sum1,ffFixed,2)+#10);
  PrintRep.AddText('�������� �����: '+CurrToStrF(Sum2,ffFixed,2));
}
  PrintRep.PreView;
 end;

procedure TJPaySlipF1.ComboBox2Change(Sender: TObject);
var D1,D31:TDateTime;
 begin
  if ComboBox2.ItemIndex<>-1 then
   begin
    GetDaysOfMonth(ComboBox2.ItemIndex+1,D1,D31);
    dtStart.Date:=D1;
    dtEnd.Date:=D31;
   end;
 end;

end.
