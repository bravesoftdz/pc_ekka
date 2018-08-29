unit PilotU;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
     Dialogs, DB, ADODB, StdCtrls, Buttons, Grids, DBGrids, PrintReport, Util;

type
  TPilotF = class(TForm)

    qrPilot: TADOQuery;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    BitBtn1: TBitBtn;
    Qr: TADOQuery;
    qrPilotdate_chek: TDateTimeField;
    qrPilotnumb_chek: TIntegerField;
    qrPilotmnn: TStringField;
    qrPilotpacient: TStringField;
    qrPilotnames: TStringField;
    qrPilotsostav: TStringField;
    qrPilotformaen: TStringField;
    qrPilotkoef: TSmallintField;
    qrPilotKolUp: TBCDField;
    qrPilotcena: TBCDField;
    qrPilotSumma: TBCDField;
    qrPilotmedname: TStringField;
    qrPilotid_kassa: TSmallintField;
    BitBtn2: TBitBtn;
    Edit1: TEdit;
    BitBtn3: TBitBtn;
    qrPilotrow_id: TIntegerField;

    procedure BitBtn1Click(Sender:TObject);
    procedure DBGrid1ColExit(Sender:TObject);
    procedure qrPilotfioSetText(Sender:TField; const Text:String);
    procedure BitBtn3Click(Sender:TObject);
    procedure DataSource1DataChange(Sender:TObject; Field:TField);

  private
    { Private declarations }
  public

    D1,D2:TDateTime;

  end;

var PilotF: TPilotF;

implementation

uses MainU, DataModuleU;

{$R *.dfm}

procedure TPilotF.BitBtn1Click(Sender:TObject);
var Tb:TTableObj;
    i:Integer;
    Sum:Real;
 begin
  try
   DM.QrEx.Close;
   DM.QrEx.SQL.Text:='select * from Apteks271 where id_apteka='+IntToStr(Prm.AptekaID);
   DM.QrEx.Open;
   if DM.QrEx.IsEmpty then Exit;

   PrintRep.Clear;
   PrintRep.SetDefault;
   PrintRep.Orientation:=O_LANDS;
   PrintRep.Font.Size:=3;
   PrintRep.Font.Name:='Arial';
   PrintRep.Indent:=0;
   PrintRep.AddTable(3,2);

   Tb:=PrintRep.LastTable;
   Tb.SetWidths('1500,10000,1500');
   Tb.SetBorders(1,1,3,2,EMPTY_BORDER);

   if Prm.FirmID=5 then
    begin
     Tb.Cell[1,1].AddText('�� �� ��� �271');
     Tb.Cell[1,2].AddText('����. ��������, 3');

     Tb.Cell[3,1].AddText('˳����� �� �527984');
     Tb.Cell[3,2].AddText('�i� 09.04.2010');
    end else
   if Prm.FirmID=1 then
    begin
     Tb.Cell[1,1].AddText('�� "�����-55"');
     Tb.Cell[1,2].AddText('���. ����������� ����, 27, ��. 2');

     Tb.Cell[3,1].AddText('˳����� �� �598226');
     Tb.Cell[3,2].AddText('�i� 24.01.2012');
    end;

   PrintRep.Font.Size:=5;
   PrintRep.Font.Style:=[fsBold];
   PrintRep.Align:=AL_CENTER;

   Case TBitBtn(Sender).Tag of
    1:PrintRep.AddText(#10#10'�Ū���');
    2:PrintRep.AddText(#10#10'��� �²���');
   end;

   PrintRep.Font.Style:=[];
   PrintRep.Font.Size:=3;
   PrintRep.AddText(#10'��������� ������ ��� �������� ��� � ����������� ��������, �� ������������'#10);
   PrintRep.AddText('���������� �� ��������� � ��������� ������������� �� �������'#10);
   PrintRep.AddText('�� '+DM.QrEx.FieldByName('Apteka').AsString+' '+DM.QrEx.FieldByName('Address').AsString+#10);
   PrintRep.AddText('�� ����� '+DateToStr(D1)+' �� '+DateToStr(D2)+#10#10);

   PrintRep.Align:=AL_LEFT;

   DM.Qr.Close;
   DM.Qr.SQL.Clear;
   DM.Qr.SQL.Add('select a.date_chek as [���� ����_S_2700], ');
   DM.Qr.SQL.Add('       Abs(a.numb_chek) as [� ����_I_1200],    ');
   DM.Qr.SQL.Add('       p.mnn as       [���_S_1900],       ');
   DM.Qr.SQL.Add('       a.pacient as   [���i���_S_3100],       ');
   DM.Qr.SQL.Add('       b.names as     [������� ������������_S_6800] ,        ');
   DM.Qr.SQL.Add('       p.sostav as    [����- �����_S_1100],       ');
   DM.Qr.SQL.Add('       p.formaua as   [����� ���._S_2700],      ');
   DM.Qr.SQL.Add('       k.koef as      [��. � ��._I_850],         ');
   DM.Qr.SQL.Add('       convert(numeric(8,2),Sum(convert(numeric(8,2),a.kol)/k.koef)) as [ʳ���. ��._N_1000], ');
   DM.Qr.SQL.Add('       p.cena as [���. ����_N_1300], Sum(a.kol*p.cena) [����� ��� ������������_N_2100], ');
   DM.Qr.SQL.Add('       convert(numeric(8,2),Sum(a.kol*p.cena)/(107/7.)) [���_N_1000], ');
   DM.Qr.SQL.Add('       a.medname [˳��������� ������, ���� ����� ������_S_6000]');

   DM.Qr.SQL.Add('from ArhCheks a,                                                                                                           ');
   DM.Qr.SQL.Add('     SprPilot p,                                                                                                           ');
   DM.Qr.SQL.Add('     SprTov b left join Inform..SprKoef k on b.art_code=k.art_code   ');
   DM.Qr.SQL.Add('where a.kod_name=b.kod_name and p.art_code=b.art_code and                                                                  ');
   DM.Qr.SQL.Add('      IsNull(cena_pilot,0)>0 and   ');
   DM.Qr.SQL.Add('      date_chek between '''+FormatDateTime('yyyy-mm-dd',D1)+' 00:00:00'' and '''+FormatDateTime('yyyy-mm-dd',D2)+' 23:59:59''   ');
   DM.Qr.SQL.Add('group by a.date_chek,a.numb_chek,p.mnn,b.names,p.sostav,p.formaua,a.medname,k.koef,p.cena,a.pacient ');

   if Prm.AptekaID=25 then
    DM.Qr.SQL.Add('order by 3                                                                                ')
   else
    DM.Qr.SQL.Add('order by 1                                                                                ');
   DM.Qr.Open;

   Sum:=0;
   for i:=1 to DM.Qr.RecordCount do
    begin
     if i=1 then DM.Qr.First else DM.Qr.Next;
     Sum:=Sum+DM.Qr.Fields[10].AsCurrency;
    end;

   DM.Qr.First;
   PrintRep.Qr:=DM.Qr;
   PrintRep.PrintTable(False,-11,0,True);

   PrintRep.AddText(#12);
   PrintRep.AddText(#10#10#10'� ���� ����i ��� '+CurrToStrF(Sum/(107/7),ffFixed,2)+' ���. '+CurrToWordsUA(Sum/(107/7),0)+#10);
   PrintRep.AddText('���� �����, ��� ������ ������������ '+CurrToStrF(Sum,ffFixed,2)+' ���. '+CurrToWordsUA(Sum,0)+#10#10 );

   PrintRep.Font.Size:=4;
   PrintRep.AddText('_________________________________                                                                                                                                _________________________________'#10);
   PrintRep.AddText('_________________________________                                                                                                                                _________________________________'#10);
   PrintRep.AddText('_________________________________                                                                                                                                _________________________________'#10#10#10);

   PrintRep.Align:=AL_CENTER;
   PrintRep.Font.Style:=[fsBold];
//   PrintRep.AddText('��'#10);
   PrintRep.Align:=AL_LEFT;
   PrintRep.AddText('      ���I����                                                                                                                                                                                           ���I����'#10#10);
   PrintRep.Font.Style:=[];
   PrintRep.AddText('      _______________________________________________                                                                                _______________________________(________________________)'#10);
   PrintRep.Font.Style:=[fsBold];
   PrintRep.AddText('                                         ��                                                                                                                                                                    ��'#10#10#10);
   PrintRep.Font.Style:=[];
   PrintRep.AddText('���� ________________________                                                                                                                          ����__________________________  '#10);

   PrintRep.PreView;
  except
   on E:Exception do MainF.MessBox(E.Message);
  end;
 end;

procedure TPilotF.DBGrid1ColExit(Sender:TObject);
 begin
 // qrPilot.
 end;

procedure TPilotF.qrPilotfioSetText(Sender:TField; const Text:String);
var nch,idkassa:Integer;

 begin
  if qrPilot.IsEmpty then Exit;
  if qrPilot.Active then
   begin
    nch:=qrPilot.FieldByName('numb_chek').AsInteger;
    idkassa:=qrPilot.FieldByName('id_kassa').AsInteger;
   end;

  Qr.Close;
  Qr.SQL.Clear;
  Qr.SQL.Add('update ArhCheks set Pacient='''+Text+''' where id_kassa='+qrPilot.FieldByName('id_kassa').AsString+' and numb_chek='+qrPilot.FieldByName('numb_chek').AsString);
  Qr.ExecSQL;
  qrPilot.Close;
  qrPilot.Open;
  qrPilot.Locate('numb_chek;id_kassa',VarArrayOf([nch,idkassa]),[]);
 end;

procedure TPilotF.BitBtn3Click(Sender: TObject);
var rd:Integer;
 begin
  if qrPilot.IsEmpty then Exit;
  Qr.Close;
  Qr.SQL.Text:='update ArhCheks set Pacient='''+Edit1.Text+''' where '+
               ' numb_chek='+qrPilot.FieldByName('numb_chek').AsString+' and '+
               ' id_kassa='+qrPilot.FieldByName('id_kassa').AsString+' and '+
               ' convert(varchar,date_chek,23)='''+FormatDateTime('yyyy-mm-dd',qrPilot.FieldByName('date_chek').AsDateTime)+'''';
  //Qr.SQL.SaveToFile('C:\Pilotr.txt');
  Qr.ExecSQL;

  if qrPilot.Active then rd:=qrPilot.FieldByName('row_id').AsInteger;
  qrPilot.Close;
  qrPilot.Open;
  qrPilot.Locate('row_id',rd,[]);
 end;

procedure TPilotF.DataSource1DataChange(Sender: TObject; Field: TField);
 begin
  Edit1.Text:=qrPilot.FieldByName('pacient').AsString;
 end;

end.



