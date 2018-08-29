unit ViewNaklU;

interface

uses Forms, Menus, DBCtrls, Controls, StdCtrls, Graphics, ExtCtrls, Grids,
     DBGrids, Buttons, ComCtrls, Classes, DB, Windows, SysUtils, PrintReport,
     Util, ShowTextU, ADODB, Dialogs, Math, ShareU;

type

  TViewNaklF = class(TForm)
    Panel3: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    btDel: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    pmPrnReg: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    BitBtn8: TBitBtn;
    Label8: TLabel;
    ComboBox1: TComboBox;
    Label9: TLabel;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    BitBtn9: TBitBtn;
    PopupMenu1: TPopupMenu;
    pm11: TMenuItem;
    bbCloseBox: TBitBtn;
    BitBtn10: TBitBtn;
    imChp: TImage;
    Label10: TLabel;
    pmCancel: TPopupMenu;
    N3: TMenuItem;
    bbVzr: TBitBtn;
    BitBtn11: TBitBtn;
    CheckBox4: TCheckBox;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    dtStart: TDateTimePicker;
    dtEnd: TDateTimePicker;
    rbPr: TRadioButton;
    rbVz: TRadioButton;
    BitBtn5: TBitBtn;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    CheckBox1: TCheckBox;
    Panel8: TPanel;
    Panel4: TPanel;
    DBGrid2: TDBGrid;
    Panel5: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    DBText1: TDBText;
    DBText2: TDBText;
    DBText3: TDBText;
    Label6: TLabel;
    DBText4: TDBText;
    Label11: TLabel;
    BitBtn12: TBitBtn;
    BitBtn13: TBitBtn;
    BitBtn14: TBitBtn;
    ADOQuery1: TADOQuery;
    ADOQuery2: TADOQuery;
    BitBtn15: TBitBtn;
    Label7: TLabel;
    DBText5: TDBText;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    lblPostavschik: TLabel;
    lblNaklNomber: TLabel;
    lblNaklDate: TLabel;
    aTmp: TADOQuery;
    pn2: TPanel;
    Label16: TLabel;
    N4: TMenuItem;
    N5: TMenuItem;
    CheckBox5: TCheckBox;

    procedure FormCreate(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);

    procedure DSrc1DataChange(Sender:TObject; Field:TField);

    procedure BitBtn2Click(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure BitBtn1Click(Sender: TObject);
    procedure rbPrClick(Sender: TObject);
    procedure rbVzClick(Sender: TObject);
    procedure btDelClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure CheckBox1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure DBGrid2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGrid2KeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid2DblClick(Sender: TObject);
    procedure pm11Click(Sender: TObject);
    procedure bbCloseBoxClick(Sender: TObject);
    procedure BitBtn10Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure bbVzrClick(Sender: TObject);
    procedure BitBtn11Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure BitBtn12Click(Sender: TObject);
    procedure BitBtn13Click(Sender: TObject);
    procedure BitBtn14Click(Sender: TObject);
    procedure BitBtn15Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ReturnList(frm: TForm; qr: TADOQuery);
    procedure N5Click(Sender: TObject);

  private

    P:Byte;
    FSr:String;

    function  CheckMarked:Boolean;

    procedure DrawGridCheckBox(Canvas:TCanvas; Rect:TRect; Checked:Boolean);
    procedure SelectNakls(ColName:String; All:Boolean; Value:Boolean);
    procedure PrintCen(Param:Byte);
    procedure NaklList(Refresh:Integer);
    procedure ShowNakl;
    procedure EnterKol(AC:Integer; P:Byte);

    procedure IncomingNakl;

    procedure NaklAfterScroll(DataSet: TDataSet);

    procedure PrintActOfNonConformity;

  public

  end;

var
  ViewNaklF:TViewNaklF;
  sp_Temp: TADOStoredProc;

implementation

uses
  MainU, DataModuleU, PrintMarkBoxU, RegPredstU, EnterKolScanU,
  VozrPartU, ReturnToProviderU, ListBackPartU;

{$R *.dfm}

procedure TViewNaklF.ReturnList(frm: TForm; qr: TADOQuery);
begin
    with (frm as TForm) do
    begin
      with (qr as TADOQuery) do
      begin
        SQL.Clear;
        SQL.Add('declare @iddoc int set @iddoc = :iddoc');
        SQL.Add('select');
        SQL.Add('  j.iddoc, j.nn_nakl, j.date_nakl, s.art_code,');
        SQL.Add('  case j.F_NDS when 1 then ''20%'' when 2 then ''7%'' end as NDS, j.f_nds,');
        SQL.Add('  convert(uniqueidentifier,j.id_postav) as id_postav, j.nn_prih, j.dt_prih,');
        SQL.Add('  apteka_net.dbo.GetNamesUpak(p.names) as Names, p.koef, p.manufacturer,');
        SQL.Add('  sum(r.kol) as kol, max(s.CENA) as Cena, max(s.CenaZakup) as CenaZakup,');
        SQL.Add('  r.pr_vz_post, post.descr, post.adres, i.numseriya, i.SrokGodn,');
        SQL.Add('  vz.descr as vz_descr, r.VzDescr');
        SQL.Add('from');
        SQL.Add('  jmoves j with (nolock)');
        SQL.Add('  left join rtovar r with (nolock) on r.iddoc=j.iddoc');
        SQL.Add('  inner join sprtov s with (nolock) on s.kod_name=r.kod_name');
        SQL.Add('  left join PList p with (nolock) on p.art_code=s.art_code');
        SQL.Add('  left join serii i with (nolock) on i.id_part8=s.id_part8');
        SQL.Add('  left join SPRPOSTAV post with (nolock) on post.id=j.id_postav');
        SQL.Add('  left join SPRPRVOZR vz with (nolock) on vz.id = r.pr_vz_post and not r.pr_vz_post is null');
        SQL.Add('where');
        SQL.Add('  j.iddoc = @iddoc');
        SQL.Add('group by');
        SQL.Add('  j.iddoc, j.nn_nakl, j.date_nakl, s.art_code, j.f_nds, j.id_postav, j.nn_prih,');
        SQL.Add('  j.dt_prih, p.names, p.koef, p.manufacturer, r.pr_vz_post, post.descr,');
        SQL.Add('  post.adres, i.numseriya, i.SrokGodn, vz.descr, r.VzDescr');
        SQL.Add('order by');
        SQL.Add('  j.iddoc, j.nn_nakl');
        SQL.Add('');
        Parameters.Clear;
        Parameters.CreateParameter('iddoc',ftInteger,pdInput,10,DM.spY_NaklList.FieldByName('iddoc').Value);
        Open;
      end;
    end;
end;

procedure TViewNaklF.IncomingNakl;
begin
  with ADOQuery2 do
  begin
    SQL.Clear;
    SQL.Add('declare @f_nds smallint set @f_nds=convert(int,:f_nds)');
    SQL.Add('declare @idpostav uniqueidentifier set @idpostav=convert(binary(16),:idpostav)');
    SQL.Add('declare @nn_prih varchar(50) set @nn_prih=:nn_prih');
    SQL.Add('declare @dt_prih datetime set @dt_prih=convert(datetime,:dt_prih)');
    SQL.Add('declare @cena numeric(8,2) set @cena=convert(numeric(8,2),:cena)');
    SQL.Add('declare @art_code int set @art_code = convert(int,:art_code)');
    SQL.Add('select');
    SQL.Add('  j.type_nakl, s.art_code, j.F_NDS, j.id_postav, j.nn_prih, j.dt_prih, j.iddoc, sum(r.kol) as kol, max(s.CenaZakup) as CenaZakup, max(s.Cena) as Cena, j.sum_prih');
    SQL.Add('from');
    SQL.Add('  jmoves j with (nolock)');
    SQL.Add('  left join rtovar r with (nolock) on convert(int,r.iddoc) = convert(int,j.iddoc)');
    SQL.Add('  inner join sprtov s with (nolock) on convert(int,s.kod_name) = convert(int,r.kod_name)');
    SQL.Add('where');
    SQL.Add('  convert(int,j.type_nakl) in (1)');
    SQL.Add('  and convert(int,s.art_code) = convert(int,@art_code)');
    SQL.Add('  and j.F_NDS=@f_nds');
    SQL.Add('  and convert(binary(16),j.id_postav)=convert(binary(16),@idpostav)');
    SQL.Add('  and j.nn_prih=@nn_prih');
    SQL.Add('  and j.dt_prih=@dt_prih');
    SQL.Add('  and s.Cena=@cena');
    SQL.Add('group by');
    SQL.Add('  j.type_nakl, s.art_code, j.F_NDS, j.id_postav, j.nn_prih, j.dt_prih, j.iddoc, j.sum_prih');
    Parameters.Clear;
    Parameters.CreateParameter('f_nds',ftSmallint,pdInput,5,ADOQuery1.FieldByName('f_nds').Value);
    Parameters.CreateParameter('idpostav',ftGuid,pdInput,0,ADOQuery1.FieldByName('id_postav').Value);
    Parameters.CreateParameter('nn_prih',ftString,pdInput,50,ADOQuery1.FieldByName('nn_prih').Value);
    Parameters.CreateParameter('dt_prih',ftDateTime,pdInput,23,ADOQuery1.FieldByName('dt_prih').Value);
    Parameters.CreateParameter('cena',ftFloat,pdInput,11,ADOQuery1.FieldByName('cena').Value);
    Parameters.CreateParameter('art_code',ftInteger,pdInput,10,ADOQuery1.FieldByName('art_code').Value);
    Open;
  end;
end;

procedure TViewNaklF.FormCreate(Sender: TObject);
begin
  sp_Temp:=TADOStoredProc.Create(self);
  sp_Temp.AfterScroll:=DM.spY_NaklList.AfterScroll;
  DM.spY_NaklList.AfterScroll:=NaklAfterScroll;

  P:=0;
  Caption:=MFC;
  dtStart.Date:=Date;
  dtEnd.Date:=Date;
  DBGrid1.DataSource.OnDataChange:=DSrc1DataChange;
  btDel.Enabled:=MainF.IsPermit([],P_SILENT);

  BitBtn5Click(BitBtn5);
  FSr:='';
end;

procedure TViewNaklF.BitBtn4Click(Sender:TObject);
begin
  Close;
end;

procedure TViewNaklF.NaklList(Refresh: Integer);
var
  tn:String;
  ID:Integer;
  ref: integer;
begin
  ref:=Refresh;
  try
    BitBtn3.Enabled:=rbVz.Checked;
    BitBtn7.Enabled:=rbVz.Checked;
    Label6.Visible:=rbVz.Checked;
    Label7.Visible:=rbVz.Checked;
    DBText4.Visible:=rbVz.Checked;
    DBText5.Visible:=rbVz.Checked;
    bbCloseBox.Enabled:=rbVz.Checked;

    if Prm.AptekaID=138 then
    begin
      bbVzr.Visible:=True;
      bbVzr.Enabled:=rbPr.Checked;
    end;

    if rbPr.Checked then
      tn:=IntToStr(DC_INCOME)
    else
      tn:=IntToStr(DC_BACK);

    if DM.spY_NaklList.Active then ID:=DM.spY_NaklList.FieldByName('iddoc').AsInteger;
    DM.spY_NaklList.Close;
    with DM.spY_NaklList do
    begin
      Parameters.Clear;
      Parameters.CreateParameter('@dt1',ftDate,pdInput,23,StrToDate(DateToStr(dtStart.Date)));
      Parameters.CreateParameter('@dt2',ftDate,pdInput,23,StrToDate(DateToStr(dtEnd.Date+1)));
      Parameters.CreateParameter('@tn',ftInteger,pdInput,10,tn);
      Parameters.CreateParameter('@piduser',ftInteger,pdInput,10,Prm.UserID);
      Parameters.CreateParameter('@refresh',ftInteger,pdInput,10,ref);
      if CheckBox4.Checked then //���� ��������� �� ����������
      begin
        if rbVz.Checked then //���� ��������� �� ���������� ����������
          Parameters.CreateParameter('@p_only_vz_provider',ftSmallint,pdInput,1,1)
        else  //����� ��������� �� ���������� ���������
          Parameters.CreateParameter('@p_only_vz_provider',ftSmallint,pdInput,1,2);
      end
      else  //��� ��������� ��������� � ����������
        Parameters.CreateParameter('@p_only_vz_provider',ftSmallint,pdInput,1,0)
    end;
    DBGrid1.DataSource.OnDataChange:=nil;
    DM.spY_NaklList.Open;
    DBGrid1.DataSource.OnDataChange:=DSrc1DataChange;
    DM.spY_NaklList.Locate('iddoc',id,[]);
  except
    on E:Exception do MainF.MessBox('������ ������������ ������ ���������: '+E.Message);
  end;
end;

procedure TViewNaklF.BitBtn5Click(Sender:TObject);
begin
  NaklList(0);
  ShowNakl;
  if DM.spY_NaklList.RecordCount<=0 then BitBtn11.Enabled:=false;
end;

procedure TViewNaklF.DSrc1DataChange(Sender:TObject; Field:TField);
begin
  ShowNakl;
end;

procedure TViewNaklF.ShowNakl;
var
  AC:Integer;
begin
  AC:=-1;
  if DM.qrShowNakl.Active then AC:=DM.qrShowNakl.FieldByName('Art_code').AsInteger;
  DM.qrShowNakl.Close;
  if DM.spY_NaklList.IsEmpty then Exit;

  DM.qrShowNakl.SQL.Text:='exec spY_ShowNakl :iddoc, :obl';
  DM.qrShowNakl.Parameters.ParamByName('iddoc').Value:=DM.spY_NaklList.FieldByName('iddoc').AsInteger;
  DM.qrShowNakl.Parameters.ParamByName('obl').Value:=DM.spY_NaklList.FieldByName('obl').AsInteger;
  DM.qrShowNakl.Open;
  DM.qrShowNakl.Locate('Art_Code',AC,[]);

  if DM.spY_NaklList.FieldByName('DeliveryDate').AsDateTime=0 then Label11.Visible:=False else
   begin
    Label11.Caption:='���� �������� �������: '+DM.spY_NaklList.FieldByName('DeliveryDate').AsString;
    Label11.Visible:=True;
   end;
end;

procedure TViewNaklF.BitBtn2Click(Sender:TObject);
var dx,dy:Integer;
    Com:TControl;
begin
  if Sender=nil then Exit;
  dx:=Left+3; dy:=Top+TControl(Sender).Height+23;
  Com:=TControl(Sender);
  P:=Com.Tag;
  While Com<>Self do
  begin
    Inc(dx,Com.Left);
    Inc(dy,Com.Top);
    Com:=Com.Parent;
  end;
  pmPrnReg.Popup(dx,dy);
end;

procedure TViewNaklF.PrintCen(Param:Byte);
var Skd:Integer;
    ss,ss1:String;
begin
  try
   if DM.qrShowNakl.IsEmpty then Exit;

   ss:=''; ss1:=' 1 as koef,';
   if CheckBox3.Checked then
    begin
     ss:='*dbo.GetKoef(b.art_code)';
     ss1:=' dbo.GetKoef(b.art_code) as koef,';
    end;
   DM.Qr.Close;
   DM.Qr.SQL.Clear;
   Case P Of
    0:begin
       DM.Qr.SQL.Add('select b.Art_code,(case when Max(b.f_nds)>2 then IsNull((select top 1 s.Names from SprCHPNames s where s.art_code=b.art_code),b.Names) else b.Names end) as Names, ');
       DM.Qr.SQL.Add('IsNull((select Max(ss.cena) from SprTov ss (nolock) where ostat>0 and ss.art_code=b.art_code),Max(b.cena))'+ss+' as Cena, '+ss1);

       DM.Qr.SQL.Add('IsNull((select Max(ean13) from SprEan where art_code=b.art_code),'''') as Ean13,c.P1,c.P2,c.P3,');

       if MainF.MaxSkd>0 then
        DM.Qr.SQL.Add('IsNull((select top 1 skd from Skd_limit where type_skd=4 and art_code=b.art_code),IsNull((select Max(skd) from Skd where type_skd=1),0)) as Skd, ') else
       if MainF.MaxSkd<=-3 then
        DM.Qr.SQL.Add('IsNull((select top 1 skd from Skd_limit where skd<3 and type_skd=4 and art_code=b.art_code),'+IntToStr(Abs(Round(MainF.MaxSkd)))+') as Skd, ')
       else
        DM.Qr.SQL.Add('0 as Skd, ');


       DM.Qr.SQL.Add('IsNull(Max(s.cenap'+ss+'),0) as CenaP, ');
       DM.Qr.SQL.Add('dbo.GetCenaOpt(b.art_code)'+ss+' as CenaOpt,Max(l.art_code) as Skd3  ');
       DM.Qr.SQL.Add('from Moves a, SprTovar s left join SkdLimit0 l on s.art_code=l.art_code, SprTov b left join Inform..SprReg c on b.art_code=c.art_code');
       DM.Qr.SQL.Add('where b.art_code=s.art_code and a.kod_name=b.kod_name and ');
       DM.Qr.SQL.Add('      date_nakl='''+FormatDateTime('yyyy-mm-dd',DBText2.Field.AsDateTime)+' 00:00:00'' and');
       DM.Qr.SQL.Add('      nn_nakl='''+DBText3.Field.AsString+''' ');

       if CheckBox5.Checked then
        DM.Qr.SQL.Add(' and (c.P2>0 or IsNull(c.L2,'''')<>'''') ');
      end;
    1:begin
       DM.Qr.SQL.Add('if Object_ID(N''tempdb..#tmps'') is not null drop table #tmps');
       DM.Qr.SQL.Add('select b.art_code,Max(j.time_nakl) as time_nakl,(case when Max(b.f_nds)>2 then IsNull((select top 1 s.Names from SprCHPNames s where s.art_code=b.art_code),b.Names) else b.Names end) as Names,b.f_nds,Sum(a.kol) as kol,');
       DM.Qr.SQL.Add('IsNull((select Max(ss.cena) from SprTov ss (nolock) where ostat>0 and ss.art_code=b.art_code),Max(b.cena)) as cena, ');
       DM.Qr.SQL.Add('convert(int,0) as ostat  ');
       DM.Qr.SQL.Add('into #tmps                                                                         ');
       DM.Qr.SQL.Add('from Moves a, SprTov b, Jmoves j                                                   ');
       DM.Qr.SQL.Add('where a.kod_name=b.kod_name and a.iddoc=j.iddoc and                               ');
       DM.Qr.SQL.Add('      a.date_nakl>='''+FormatDateTime('yyyy-mm-dd',DBText2.Field.AsDateTime)+' 00:00:00'' and ');
       DM.Qr.SQL.Add('      a.debcrd=1 and a.nn_nakl not like ''%��-%''                                  ');
       DM.Qr.SQL.Add('group by b.art_code,b.names,b.f_nds                                         ');
       DM.Qr.SQL.Add('                                                                                   ');

       DM.Qr.SQL.Add('update #tmps set ostat= IsNull((select Sum(ostat) from SprTov s where s.art_code=#tmps.art_code ),0) ');
       DM.Qr.SQL.Add('                       +IsNull((select Sum(kol) from ArhCheks a, SprTov b where a.kod_name=b.kod_name and b.art_code=#tmps.art_code and a.date_chek>#tmps.time_nakl),0)  ');
       DM.Qr.SQL.Add('                       -IsNull((select Sum(kol) from Moves a, SprTov b, JMoves j where a.debcrd=1 and j.nn_nakl not like ''%��-%'' and j.iddoc=a.iddoc and a.kod_name=b.kod_name and b.art_code=#tmps.art_code and j.time_nakl>=#tmps.time_nakl),0)   ');
       DM.Qr.SQL.Add('                       +IsNull((select Sum(kol) from Moves a, SprTov b, JMoves j where a.debcrd=2 and j.nn_nakl not like ''%��-%'' and j.iddoc=a.iddoc and a.kod_name=b.kod_name and b.art_code=#tmps.art_code and j.time_nakl>=#tmps.time_nakl),0) ');

       DM.Qr.SQL.Add('select b.Art_code,b.Names,Max(b.Cena)'+ss+' as Cena,'+ss1+' IsNull(Max(s.CenaP),0)'+ss+' as CenaP, dbo.GetCenaOpt(b.art_code)'+ss+' as CenaOpt,Max(l.art_code) as Skd3,            ');

       if MainF.MaxSkd>0 then
        DM.Qr.SQL.Add('IsNull((select top 1 skd from Skd_limit where type_skd=4 and art_code=b.art_code),IsNull((select Max(skd) from Skd where type_skd=1),0)) as Skd, ') else
       if MainF.MaxSkd<=-3 then
        DM.Qr.SQL.Add('IsNull((select top 1 skd from Skd_limit where skd<3 and type_skd=4 and art_code=b.art_code),'+IntToStr(Abs(Round(MainF.MaxSkd)))+') as Skd, ')
       else
        DM.Qr.SQL.Add('0 as Skd, ');

       DM.Qr.SQL.Add('       IsNull((select Max(ean13) from SprEan where art_code=b.art_code),'''') as Ean13,c.P1,c.P2,c.P3');
       DM.Qr.SQL.Add(' from SprTovar s  left join SkdLimit0 l on s.art_code=l.art_code, #tmps b left join Inform..SprReg c on b.art_code=c.art_code                   ');
       DM.Qr.SQL.Add(' where s.art_code=b.art_code and b.ostat<=0 ');
       if CheckBox5.Checked then
        DM.Qr.SQL.Add(' and (c.P2>0 or IsNull(c.L2,'''')<>'''') ');
      end;
   end;
   DM.Qr.SQL.Add('group by b.Art_code,b.Names,c.P1,c.P2,c.P3');

   Case Param of
    1:DM.Qr.SQL.Add('order by b.Names');
    2:DM.Qr.SQL.Add('order by c.P1,c.P2,c.P3,b.Names');
   end;
   DM.Qr.Open;

   // if CheckBox2.Checked then PrintRep.PrintStiker else

   PrintCennikListExt(DM.Qr,W_CENNIK,CheckBox3.Checked,CheckBox2.Checked,False,Param);
  except
   on E:Exception do MainF.MessBox('������ ������������ ������ ��������: '+E.Message);
  end;
end;

procedure TViewNaklF.DrawGridCheckBox(Canvas:TCanvas; Rect:TRect; Checked:boolean);
var DrawFlags:Integer;
begin
  Canvas.TextRect(Rect,Rect.Left+1,Rect.Top+1,' ');
  DrawFrameControl(Canvas.Handle, Rect, DFC_BUTTON, DFCS_BUTTONPUSH or DFCS_ADJUSTRECT);
  DrawFlags:=DFCS_BUTTONCHECK or DFCS_ADJUSTRECT;// DFCS_BUTTONCHECK
  if Checked then DrawFlags:=DrawFlags or DFCS_CHECKED;
  DrawFrameControl(Canvas.Handle,Rect,DFC_BUTTON,DrawFlags);
end;

procedure TViewNaklF.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var db:TDBGrid;
    dR,sR,R:TRect;
    Pr,Kol,i,j:Integer;
    C,C1:TColor;
begin
  if Sender=nil then Exit;
  db:=TDBGrid(Sender);
  if Copy(db.DataSource.DataSet.FieldByName('NN_NAKL').AsString,2,3)='��-' then db.Canvas.Font.Color:=$00858ECD else
  if DataCol=1 then
   begin
    Pr:=db.DataSource.DataSet.FieldByName('NumScan').AsInteger;
    Kol:=db.DataSource.DataSet.FieldByName('Cnt').AsInteger;
    if Pr>0 then
     begin
      if Kol=Pr then db.Canvas.Brush.Color:=clLime else
      if Pr<Kol then db.Canvas.Brush.Color:=clYellow
                else db.Canvas.Brush.Color:=$008080FF;
     end;

   end;

  if (DataCol=0) and (db.DataSource.DataSet.FieldByName('EANDriver').AsString<>'') then
   db.Canvas.Brush.Color:=$00C08000;

  if gdSelected in State then
   begin
    db.Canvas.Brush.Color:=clNavy;
    db.Canvas.Font.Color:=clWhite;
   end;
  db.DefaultDrawColumnCell(Rect,DataCol,Column,State);
  if Column=db.Columns[2] then
   begin
    R.Left:=Rect.Left;
    R.Top:=Rect.Top;
    R.Right:=Rect.Right;
    R.Bottom:=Rect.Bottom+1;
    DrawGridCheckBox(db.Canvas,R,db.DataSource.DataSet.FieldByName('f').AsInteger=1);
   end;

  if (db.DataSource.DataSet.FieldByName('Marked').AsInteger=1) and (DataCol=0) then
   begin
    dr:=Rect;
    dr.Left:=dr.Left+2; dr.Top:=dr.Top+1;
    dr.Right:=dR.Left+imChp.Width; dr.Bottom:=dR.Top+imChp.Height;

    db.Canvas.FillRect(Rect);
    db.Canvas.TextOut(Rect.Left+imChp.Width+6, Rect.Top+1,db.DataSource.DataSet.FieldByName('Date_Nakl').AsString);

    C1:=imChp.Canvas.Pixels[0,0];
    C:=$00DFE2EC;
    for i:=0 to imChp.Width-1 do
     for j:=0 to imChp.Height-1 do
      if imChp.Canvas.Pixels[i,j]=C1 then imChp.Canvas.Pixels[i,j]:=C;
    sR.Left:=0; sR.Top:=0; sR.Right:=imChp.Width; sR.Bottom:=imChp.Height;
    db.Canvas.CopyRect(dR,imChp.Canvas,sR);
   end;
end;


procedure TViewNaklF.BitBtn1Click(Sender: TObject);
var Tb:TTableObj;
    i,F_NDS,It,Kol,Tn:Integer;
    NDS:Boolean;
    VzDescr,FirmName,AptekaName,S:String;
begin
  It:=0;
  Tb:=nil;
  if DM.spY_NaklList.IsEmpty then Exit;
  if DM.qrShowNakl.IsEmpty then Exit;

  if DM.spY_NaklList.FieldByName('obl').AsInteger=2 then // ������ ��������� �� ���
   begin
    try
     PrintRep.Clear;
     PrintRep.SetDefault;
     PrintRep.Font.Size:=6;
 
     PrintRep.AddText('��������� ��� � '+DM.spY_NaklList.FieldByName('NN_Nakl').AsString+'�� '+DateToStrRU(DM.spY_NaklList.FieldByName('Date_Nakl').AsDateTime)+#10);
     PrintRep.AddText('�� ����: '+Prm.AptekaNameRU+#10#10);
     PrintRep.Font.Size:=4;
     PrintRep.Align:=AL_LEFT;

     DM.Qr.Close;
     if rbPr.Checked then
      DM.Qr.SQL.Text:='exec spY_NaklListTMC '+DM.spY_NaklList.FieldByName('iddoc').AsString+',1'
     else
      DM.Qr.SQL.Text:='exec spY_NaklListTMC '+DM.spY_NaklList.FieldByName('iddoc').AsString+',2';

     DM.Qr.Open;

     PrintRep.Qr:=DM.Qr;
     PrintRep.PrintTable(False,0,0);
     PrintRep.PreView;
    except
     on E:Exception do MainF.MessBox('������ ������ ��������� ���:'+E.Message);
    end;
    Exit;
   end;

  try
   F_NDS:=DM.qrShowNakl.FieldByName('F_NDS').AsInteger;
   if F_NDS<=2 then
    begin
     if Prm.AptekaNameLic<>Prm.AptekaNameRU then AptekaName:=Prm.AptekaNameLic+' ('+Prm.AptekaNameRU+')'
                                            else AptekaName:=Prm.AptekaNameLic;

     FirmName:=Prm.FirmNameRU;
    end else begin
              AptekaName:=Opt.CHPAddr;
              FirmName:=Opt.CHPName;
             end;
   Tn:=DM.spY_NaklList.FieldByName('DebCrd').AsInteger;
   PrintRep.Clear;
   PrintRep.SetDefault;
   PrintRep.Font.Name:='Arial';
   PrintRep.Font.Size:=4;
   Case Tn of
    DC_INCOME:begin
               PrintRep.AddTable(4,5);
               Tb:=PrintRep.LastTable;
               Tb.SetWidths('1200,1400,2600,1400');
               Tb.MergeCells(1,1,3,1);
               Tb.MergeCells(1,5,3,5);
               for i:=1 to 3 do Tb.Cell[4,i].Align:=AL_CENTER;
               Tb.SetBorders(1,1,4,5,EMPTY_BORDER);
               if Prm.FirmID<>5 then
                begin
                 Tb.SetBorders(4,1,4,3,Border(clBlack,5,psSolid));

                 Tb.Cell[4,1].AddText(Prm.FirmNameUA);
                 Tb.Cell[4,2].Font.Size:=3;
                 Tb.Cell[4,2].AddText('������� ��������');
                 Tb.Cell[4,3].AddText('��������___________');

                 Tb.Cell[4,2].TopBorder:=EMPTY_BORDER;
                 Tb.Cell[4,3].TopBorder:=EMPTY_BORDER;
                end;

               Tb.Cell[1,1].Font.Style:=[fsBold];
               Tb.Cell[1,5].Font.Style:=[fsBold];
               Tb.Cell[1,1].AddText(FirmName);
               Tb.Cell[1,1].Font.Style:=[];
               Tb.Cell[1,1].AddText(' ('+Prm.SkladAdress+')');

               Tb.Cell[1,4].AddText('�� ������ ������');
               Tb.Cell[1,5].AddText('����: '+AptekaName);
               if Prm.FirmID<>5 then
                Tb.Cell[4,5].AddText(FormatDateTime('dd.mm.yyyy hh:nn:ss',Now));

               Tb.Cell[2,2].AddInterv(2);
               Tb.Cell[1,2].Font.Style:=[fsBold];
               Tb.Cell[1,2].AddText(DateToStrRU(DM.spY_NaklList.FieldByName('Date_Nakl').AsDateTime));
               Tb.Cell[1,3].Font.Style:=[fsBold];
               Tb.Cell[1,3].AddText('��������� �');
               Tb.SetBorders(2,3,2,3,Border(clBlack,4,psSolid));
               Tb.Cell[2,3].AddText(DM.spY_NaklList.FieldByName('NN_Nakl').AsString);
              end;
    DC_BACK:  begin

               PrintRep.Font.Size:=6;
               PrintRep.Font.Style:=[fsBold];
               PrintRep.Align:=AL_CENTER;
               PrintRep.AddText('��������� � '+DM.spY_NaklList.FieldByName('NN_Nakl').AsString+#10);
               PrintRep.Font.Size:=5;
               PrintRep.AddText('�� ������� ������ �� �������'+#10);
               PrintRep.AddText('�� '+DateToStrRU(DM.spY_NaklList.FieldByName('Date_Nakl').AsDateTime)+#10#10);
               PrintRep.Font.Size:=4;
               PrintRep.Align:=AL_LEFT;

               PrintRep.AddText('�� ����: '+AptekaName+#10);

               DM.QrEx3.Close;
               DM.QrEx3.SQL.Text:='select priznak from JMoves where iddoc='+DM.spY_NaklList.FieldByName('iddoc').AsString;
               DM.QrEx3.Open;

               Case DM.QrEx3.FieldByName('priznak').AsInteger of
                 1:PrintRep.AddText('���������: ������ �������'+#10);
                 7:PrintRep.AddText('���������: ��� ������'+#10);
                12:PrintRep.AddText('���������: ��� - ������'+#10) else PrintRep.AddText('���������: '+DBText4.Caption+#10);
               end;

               PrintRep.AddText('� ��������� (����� ���������)'+#10#10);

               PrintRep.AddText('����: '+FirmName);
              end;
   end;


   PrintRep.AddInterv(4);
   if DM.spY_NaklList.FieldByName('f_nds').AsInteger=1 then NDS:=True else NDS:=False;
   DM.Qr.Close;
   DM.Qr.SQL.Clear;
   Kol:=4;
   Case Tn of
    DC_INCOME:begin
               PrintRep.Font.Size:=5;
               PrintRep.Font.Style:=[fsBold];
               PrintRep.Indent:=0;
               PrintRep.AddText(#10+'������ ��������� ��������� ����������� ������� � �����������'+#10);
               PrintRep.AddInterv(1);
               PrintRep.Font.Style:=[];
               PrintRep.Font.Size:=4;
               if NDS then
                begin
                 DM.Qr.SQL.Add('select ''NumS'' as [� ��._S_1150],');
                 DM.Qr.SQL.Add('       b.Names+'' ''+convert(varchar,b.art_code) as ������������_S_7800,');
                 DM.Qr.SQL.Add('       ''��.'' as [��. ���_S_1150],');
                 DM.Qr.SQL.Add('       Sum(a.Kol) as [���-��_I_1500],');
                 DM.Qr.SQL.Add('Max(a.Cena)-Max(a.Cena)/6. as [���� ��� ���_N_1700],');
                 DM.Qr.SQL.Add('Max(a.Cena)/6. as [��� �� ��_N_1500],');
                 DM.Qr.SQL.Add('Max(a.Cena) as [���� � ���_N_1500],');
                 DM.Qr.SQL.Add('Sum(a.Kol*a.Cena) as [�����_N_1900]');
                 It:=8;
                end else begin
                          DM.Qr.SQL.Add('select ''NumS'' as [� ��._S_1150],');
                          DM.Qr.SQL.Add('       b.Names+'' ''+convert(varchar,b.art_code) as ������������_S_7800,');
                          DM.Qr.SQL.Add('       ''��.'' as [��. ���_S_1150],');
                          DM.Qr.SQL.Add('       Sum(a.Kol) as [���-��_I_1500],');
                          DM.Qr.SQL.Add('Max(a.Cena)-Max(a.Cena)*(7./107.) as [���� ��� ���_N_1700],');
                          DM.Qr.SQL.Add('Max(a.Cena)*(7./107.) as [��� �� ��_N_1500],');
                          DM.Qr.SQL.Add('Max(a.Cena) as [���� � ���_N_1500],');
                          DM.Qr.SQL.Add('Sum(a.Kol*a.Cena) as [�����_N_1900]');
                          It:=8;
                         end;
               DM.Qr.SQL.Add('from Moves a, SprTov b where a.kod_name=b.kod_name and a.iddoc='+DM.spY_NaklList.FieldByName('IDDOC').AsString);
               DM.Qr.SQL.Add('group by b.art_code,b.Names,b.f_nds');
               DM.Qr.SQL.Add('order by b.Names');
              end;
    DC_BACK:  begin
               if NDS then
                begin
                 DM.Qr.SQL.Add('select ''NumS'' as [� ��._S_1050],');
                 DM.Qr.SQL.Add('       b.art_code as ���_S_1100,');
                 DM.Qr.SQL.Add('       b.Names+'' ''+convert(varchar,b.art_code) as ������������_S_7800,');
                 DM.Qr.SQL.Add('       ''��.'' as [��. ���_S_1150],');
                 DM.Qr.SQL.Add('       Sum(a.Kol) as [���-��_I_1500],');
                 DM.Qr.SQL.Add('Max(a.Cena)-Max(a.Cena)/6. as [���� ��� ���_N_1700],');
                 DM.Qr.SQL.Add('Max(a.Cena)/6. as [��� �� ��_N_1500],');
                 DM.Qr.SQL.Add('Max(a.Cena) as [���� � ���_N_1500],');
                 DM.Qr.SQL.Add('Sum(a.Kol*a.Cena) as [�����_N_1900]');
                 It:=9;
                end else begin
                          DM.Qr.SQL.Add('select ''NumS'' as [� ��._S_1050],');
                          DM.Qr.SQL.Add('       b.art_code as ���_S_1100,');
                          DM.Qr.SQL.Add('       b.Names+'' ''+convert(varchar,b.art_code) as ������������_S_7800,');
                          DM.Qr.SQL.Add('       ''��.'' as [��. ���_S_1150],');
                          DM.Qr.SQL.Add('       Sum(a.Kol) as [���-��_I_1500],');
                          DM.Qr.SQL.Add('Max(a.Cena)-Max(a.Cena)*(7./107.) as [���� ��� ���_N_1700],');
                          DM.Qr.SQL.Add('Max(a.Cena)*(7./107.) as [��� �� ��_N_1500],');
                          DM.Qr.SQL.Add('Max(a.Cena) as [���� � ���_N_1500],');
                          DM.Qr.SQL.Add('Sum(a.Kol*a.Cena) as [�����_N_1900]');
                          It:=9;
                         end;

               DM.Qr.SQL.Add('from Moves a, SprTov b where a.kod_name=b.kod_name and a.iddoc='+DM.spY_NaklList.FieldByName('IDDOC').AsString);
               DM.Qr.SQL.Add('group by b.art_code,b.Names,b.f_nds');
               DM.Qr.SQL.Add('order by b.Names');
              end;
   end;
   DM.Qr.Open;
   PrintRep.Qr:=DM.Qr;
   PrintRep.PrintTable(Nds,It,Kol);

   Case Tn of
    DC_INCOME:begin
               S:='______________/                             /';
               PrintRep.Font.Size:=4;
               PrintRep.Font.Style:=[fsBold];
               PrintRep.AddText(#10#10+'������ ��������:'+S+'         ');
               PrintRep.Font.Size:=3;
               PrintRep.Font.Style:=[];

               PrintRep.Font.Size:=4;
               PrintRep.Font.Style:=[fsBold];

               if Copy(DM.spY_NaklList.FieldByName('NN_Nakl').AsString,1,3)<>'���' then
                begin
                 PrintRep.AddText(#10#10+'��������:'+S+'     �������:_____________    __________    _____________ ');
                 PrintRep.Font.Size:=3;
                 PrintRep.Font.Style:=[];
                 PrintRep.AddText(#10+'                                                                                                 '
                                     +'                                                                     (���������)                 (�������)                      (���)');
                end else begin
                          PrintRep.AddText(#10#10+'�������:_____________    __________    _____________ ');
                          PrintRep.Font.Size:=3;
                          PrintRep.Font.Style:=[];
                          PrintRep.AddText(#10+'                        (���������)                 (�������)                      (���)');
                         end;
              end;
    DC_BACK:  PrintRep.AddText(#10#10+'��������:_______________________           �������:_________________________'+#10);
   end;

   PrintRep.PreView;
  except
   on E:Exception do MainF.MessBox('������ ������������ �������� ����� ���������: '+E.Message);
  end;
 end;

procedure TViewNaklF.rbPrClick(Sender:TObject);
begin
  rbVz.Checked:=false;
  BitBtn11.Enabled:=true;
  BitBtn12.Enabled:=false;
  BitBtn13.Enabled:=false;
  BitBtn15.Enabled:=false;
  BitBtn14.Enabled:=false;

  CheckBox4.Caption:='��������� �� ����������';
  if DM.spY_NaklList.RecordCount<=0 then BitBtn11.Enabled:=false;

  BitBtn5Click(BitBtn5);
  BitBtn5Click(BitBtn5);
  N3.Visible:=rbVz.Checked;
end;

procedure TViewNaklF.rbVzClick(Sender:TObject);
begin
  rbPr.Checked:=false;
  BitBtn11.Enabled:=false;
  BitBtn12.Enabled:=true;
  BitBtn13.Enabled:=true;
  BitBtn15.Enabled:=true;
  BitBtn14.Enabled:=true;

  CheckBox4.Caption:='��������� � ����������';
  if DM.spY_NaklList.RecordCount<=0 then BitBtn11.Enabled:=false;

  BitBtn5Click(BitBtn5);
  BitBtn5Click(BitBtn5);
  N3.Visible:=rbVz.Checked;
end;

procedure TViewNaklF.btDelClick(Sender:TObject);
var
  iddoc:Integer;
begin
  if Not MainF.CheckPassword('0523574825') then Exit;
  if DM.spY_NaklList.IsEmpty then Exit;
  if MainF.MessBox('������� ���������: '+DM.spY_NaklList.FieldByName('nn_nakl').AsString+' ?',52)<>ID_YES then Exit;
  iddoc:=DM.spY_NaklList.FieldByName('iddoc').AsInteger;
  try
    DM.Qr.Close;
    DM.Qr.SQL.Text:='exec spY_DeleteNakl '+IntToStr(iddoc)+' select 999 as Res';
    DM.Qr.Open;

    BitBtn5Click(BitBtn5);
    if MainF.Design=False then MainF.FilterSklad;
  except
    MainF.MessBox('������ �������� ���������: '+DM.spY_NaklList.FieldByName('nn_nakl').AsString+'.');
  end;
end;

procedure TViewNaklF.SelectNakls(ColName:String; All:Boolean; Value:Boolean);
var V,RID:Integer;
begin
  if DM.spY_NaklList.IsEmpty then Exit;
  if ColName='f' then
   try
    RID:=DM.spY_NaklList.FieldByName('ROW_ID').AsInteger;
    DM.Qr.Close;
    if Value then V:=1 else V:=0;
    DM.Qr.SQL.Clear;
    if Not All then
     DM.Qr.SQL.Add('Update ##nakllist set F=1-F where id_user='+IntToStr(Prm.UserID)+' and compname=host_name() and row_id='+DM.spY_NaklList.FieldByName('row_id').AsString)
    else begin
          DM.Qr.SQL.Add('Update ##nakllist set F='+IntToStr(V)+' where nn_nakl not like ''%��-%'' and priznak not in (select Descr from SPRPRVOZR where id in (9,10)) and compname=host_name() and id_user='+IntToStr(Prm.UserID));
         end;
    DM.Qr.SQL.Add('Update ##nakllist set F=0 where priznak in (select Descr from SPRPRVOZR where id in (9,10))');
    DM.Qr.ExecSQL;
    NaklList(1);
    DM.spY_NaklList.Locate('ROW_ID',RID,[]);
   except
   end;
end;

procedure TViewNaklF.DBGrid1CellClick(Column:TColumn);
begin
  SelectNakls(Column.FieldName,False,False);
end;

procedure TViewNaklF.CheckBox1Click(Sender:TObject);
begin
  SelectNakls('f',True,CheckBox1.Checked);
end;

procedure TViewNaklF.BitBtn3Click(Sender:TObject);
var i,iii:Integer;
    EAN13,S:String;
begin
  try
   DM.Qr.Close;
   DM.Qr.SQL.Clear;
   DM.Qr.SQL.Add('if Object_ID(N''tempdb..#tmpnspis'') is not null drop table #tmpnspis ');
   DM.Qr.SQL.Add('select iddoc,nn_nakl ');
   DM.Qr.SQL.Add('into #tmpnspis ');
   DM.Qr.SQL.Add('from  Moves (nolock) ');
   DM.Qr.SQL.Add('where IsNull(IsScan,0)>0 and IsNull(Shtrih,0)=0 ');
   DM.Qr.SQL.Add('      and iddoc in (select iddoc from ##nakllist where id_user='+IntToStr(Prm.UserID)+' and compname=host_name() and f=1 )');
   DM.Qr.SQL.Add('group by iddoc,nn_nakl');

   DM.Qr.SQL.Add('select * from #tmpnspis ');
   DM.Qr.SQL.Add('order by 2');
   DM.Qr.Open;
   if DM.Qr.IsEmpty=False then
    begin
     S:='';
     for i:=1 to DM.Qr.RecordCount do
      begin
       if i=1 then DM.Qr.First else DM.Qr.Next;
       S:=S+'      '+DM.Qr.FieldByName('nn_nakl').AsString+#10;
     end;
     ShowText('��� ��������� ��������� ���������� ���������� ��� ������-��������, ��� ��� �� ��� ����� �������: '#10+S);
    end;

   if (Prm.UserRole<>R_ADMIN) then
    begin
     RegPredstF:=TRegPredstF.Create(Self);
     try

      RegPredstF.crPref:=CR_DRIVER;
      RegPredstF.OnlyScan:=True;
      RegPredstF.Cap:='��������';
      RegPredstF.Tab:='RegDrivers';
      Application.ProcessMessages;
      RegPredstF.ShowModal;

      if RegPredstF.Flag=False then Exit;
      EAN13:=RegPredstF.EAN13;
      try
       if Length(EAN13)<>13 then Abort;

       DM.QrEx.Close;
       DM.QrEx.SQL.Clear;
       DM.QrEx.SQL.Add('update JMoves set Date_Close=getdate(), EANDriver='''+EAN13+''' where iddoc in (select iddoc from ##nakllist where id_user='+IntToStr(Prm.UserID)+' and compname=host_name() and f=1 and iddoc not in (select iddoc from #tmpnspis) group by iddoc)');
       DM.QrEx.SQL.Add('select top 1 EANDriver from JMoves where IsNull(EANDriver,'''')='''' and iddoc in (select iddoc from ##nakllist where id_user='+IntToStr(Prm.UserID)+' and compname=host_name() and f=1 and iddoc not in (select iddoc from #tmpnspis) group by iddoc) ');
       DM.QrEx.Open;

       if DM.QrEx.IsEmpty=False then Abort;
      except
       MainF.MessBox('�����-��� �������� ������������! ������������� ��� ���!');
       Exit;
      end;
     finally
      RegPredstF.Free;
     end;
    end;

   PrintRep.Clear;
   PrintRep.SetDefault;
   PrintRep.Font.Name:='Arial';
   PrintRep.Font.Size:=3;

   DM.QrEx.Close;
   DM.QrEx.SQL.Text:='select id_p from ##nakllist where id_p>0 and id_user='+IntToStr(Prm.UserID)+' and compname=host_name() and f=1 and iddoc not in (select iddoc from #tmpnspis) group by id_p';
   DM.QrEx.Open;

   for i:=1 to DM.QrEx.RecordCount do
    begin
     if i=1 then DM.QrEx.First else DM.QrEx.Next;
     for iii:=1 to 2 do
      begin
       PrintRep.Align:=AL_LEFT;

       DM.Qr.Close;
       DM.Qr.SQL.Clear;
       DM.Qr.SQL.Add('select nn_nakl+''-'+IntToStr(Prm.AptekaID)+''' +case Priznak when 19 then ''     �����'' else ''''      end as [������ ���������_S_600], ');
       DM.Qr.SQL.Add('       date_nakl as [����_S_400], ');
       DM.Qr.SQL.Add('       Summa as [�����_N_300] ');
       DM.Qr.SQL.Add('from JMoves ');
       DM.Qr.SQL.Add('where iddoc in (select iddoc from ##nakllist where id_user='+IntToStr(Prm.UserID)+' and compname=host_name() and f=1 and iddoc not in (select iddoc from #tmpnspis) and id_p='+DM.QrEx.FieldByName('id_p').AsString+')');
       DM.Qr.Open;

       PrintRep.AddTable(2,1);
       PrintRep.LastTable.SetWidths('7000,3000');
       PrintRep.LastTable.SetBorders(1,1,2,1,EMPTY_BORDER);

       PrintRep.LastTable.Cell[1,1].AddText('���������� �2');

       PrintRep.LastTable.Cell[2,1].AddText('���������� �2');
       PrintRep.Font.Size:=3;

       PrintRep.Align:=AL_CENTER;
       PrintRep.AddText(#10+'���'+#10);
       PrintRep.AddText('������-�������� ������'+#10);
       PrintRep.AddTable(2,1);
       PrintRep.LastTable.SetBorders(1,1,2,1,EMPTY_BORDER);
       PrintRep.LastTable.Cell[1,1].Align:=AL_LEFT;
       PrintRep.LastTable.Cell[1,1].AddText('�.�������');
       PrintRep.LastTable.Cell[2,1].Align:=AL_RIGHT;
       PrintRep.LastTable.Cell[2,1].AddText(DateToStr(Date));
       PrintRep.Align:=AL_JUST;

       PrintRep.Indent:=15;
       PrintRep.AddText(#10+'���������� (���. ����������) ������ "'+Prm.AptekaNameRU+' '+Prm.FirmNameRU+' ______________/���/, ');
       PrintRep.AddText('������� ����� � ������������� ���������� ������ (�������), ������� ��������� � �� ����� ������� �����������, � ��������');
       PrintRep.AddText('(����������) __________/���/ ������ ��������� �����  ��� ����������� �������� ���������� �� "����� 55"');
       PrintRep.AddText(#10#10);
       PrintRep.AddText('���������� ������ (�������) ��� ������� ����������� ___________________');
       PrintRep.AddText(#10);

       PrintRep.Qr:=DM.Qr;
       PrintRep.PrintTable(False,0,0);
       PrintRep.AddText(#10+'��������� '+IntToStr(DM.Qr.RecordCount)+' �� ����� ');
       DM.Qr.Close;
       DM.Qr.SQL.Text:='select Sum(Summa) as Summa from ##nakllist where  id_user='+IntToStr(Prm.UserID)+' and compname=host_name() and f=1 and iddoc not in (select iddoc from #tmpnspis) and id_p='+DM.QrEx.FieldByName('id_p').AsString;
       DM.Qr.Open;
       PrintRep.AddText(CurrToStrF(DM.Qr.FieldByName('Summa').AsFloat,ffFixed,2)+' ���. '#10);

       DM.Qr.Close;
       DM.Qr.SQL.Clear;
       DM.Qr.SQL.Add('select art_code');
       DM.Qr.SQL.Add('from  Moves a, SprTov b');
       DM.Qr.SQL.Add('where a.kod_name=b.kod_name ');
       DM.Qr.SQL.Add('      and iddoc in (select iddoc from ##nakllist where id_user='+IntToStr(Prm.UserID)+' and compname=host_name() and f=1 and iddoc not in (select iddoc from #tmpnspis) and id_p='+DM.QrEx.FieldByName('id_p').AsString+')');
       DM.Qr.SQL.Add('group by art_code');
       DM.Qr.Open;
       PrintRep.AddText('���������� ������������: '+IntToStr(DM.Qr.RecordCount)+'   ');

       DM.Qr.Close;
       DM.Qr.SQL.Clear;
       DM.Qr.SQL.Add('select Sum(kol) as kol');
       DM.Qr.SQL.Add('from Moves');
       DM.Qr.SQL.Add('where iddoc in (select iddoc from ##nakllist where id_user='+IntToStr(Prm.UserID)+' and compname=host_name() and f=1 and iddoc not in (select iddoc from #tmpnspis) and id_p='+DM.QrEx.FieldByName('id_p').AsString+')');
       DM.Qr.Open;
       PrintRep.AddText('���������� ����: '+DM.Qr.FieldByName('kol').AsString+#10);
       PrintRep.AddText('��� �����������: '+FormatDateTime('dd.mm.yyyy hh:nn:ss',Now)+#10#10);

       PrintRep.Font.Size:=3;
       PrintRep.AddTable(2,1);
       PrintRep.LastTable.SetWidths('2000,1300');
       PrintRep.LastTable.SetBorders(1,1,2,1,EMPTY_BORDER);
       PrintRep.LastTable.Cell[1,1].Align:=AL_LEFT;
       PrintRep.LastTable.Cell[1,1].AddText('�������� ����� � ������'+#10#10+'_____________________________');
       
       PrintRep.LastTable.Cell[2,1].Align:=AL_LEFT;
       PrintRep.LastTable.Cell[2,1].AddText('������ ���������� (��������)'+#10#10+'_____________________________'+#10#10);
       PrintRep.LastTable.Cell[2,1].AddText('������ ����� '+#10+'_____________________________');
       
       DM.Qr1.Close;
       DM.Qr1.SQL.Clear;
       DM.Qr1.SQL.Add('select a.nn_nakl as [� ����._S_2500],a.date_nakl as [���� ����._S_1800], b.art_code as [���_I_1500],b.names as [������������_S_7000],Sum(a.kol) as [���. ����._I_1500],Sum(IsNull(IsScan,0)) as [���. ����._I_1500], ');
       DM.Qr1.SQL.Add('       Sum(a.kol)-Sum(IsNull(IsScan,0)) as [���������._I_2000]');
       DM.Qr1.SQL.Add('from Moves a (nolock), SprTov b (nolock) ');
       DM.Qr1.SQL.Add('where IsNull(a.IsScan,0)>0 and IsNull(a.Shtrih,0)=0 and a.date_nakl>=''2014-02-25'' and a.kod_name=b.kod_name and a.iddoc in (select iddoc from ##nakllist where id_user='+IntToStr(Prm.UserID)+' and compname=host_name() and f=1 and iddoc not in (select iddoc from #tmpnspis) and id_p='+DM.QrEx.FieldByName('id_p').AsString+')');
       DM.Qr1.SQL.Add('group by a.nn_nakl,a.date_nakl,b.art_code,b.names ');
       DM.Qr1.SQL.Add('having Sum(a.kol)>Sum(Isnull(IsScan,0)) ');
       DM.Qr1.SQL.Add('order by 2 ');
       DM.Qr1.Open;

       if DM.Qr1.IsEmpty=False then
        begin
         PrintRep.AddText(#10#10'������ ����������������� ����� ����� ��������� ��� ���������');
         PrintRep.Qr:=DM.Qr1;
         PrintRep.PrintTable(False,0,0);
        end;

       if iii=1 then PrintRep.AddInterv(12);

      end;
     PrintRep.AddText(#12);
    end;

   PrintRep.PreView;
  except
   on E:Exception do
    MainF.MessBox('������ ������������ ������ ��� ����: '+E.Message);
  end;
 end;

procedure TViewNaklF.BitBtn6Click(Sender: TObject);
 begin
  try
   PrintRep.Clear;
   PrintRep.SetDefault;
   PrintRep.Font.Name:='Arial';
   PrintRep.Font.Size:=5;
   PrintRep.Font.Style:=[fsBold];
   PrintRep.AddText('������ ���������� ��������� �� ������ ��������'+#10#10);
   PrintRep.AddText('�������� �����: '+Prm.AptekaNameRU+#10);
   PrintRep.AddText('��������� �: '+DM.spY_NaklList.FieldByName('nn_nakl').AsString+#10);
   PrintRep.AddText('���� : '+DM.spY_NaklList.FieldByName('date_nakl').AsString+#10#10);
   PrintRep.Orientation:=O_LANDS;
   PrintRep.Font.Size:=4;
   PrintRep.Font.Style:=[];

   DM.Qr.Close;
   DM.Qr.SQL.Clear;
   DM.Qr.SQL.Add('select b.Art_Code as ���_I_1400,');
   DM.Qr.SQL.Add('       b.Names as ������������_S_11000,');
   DM.Qr.SQL.Add('       Sum(a.Kol) as [���-��_I_1000],');
   DM.Qr.SQL.Add('       convert(varchar(10),case Min(p.t1) when -999 then null else Min(p.t1) end)+char(176) as [����. ���. '#10'�_C_1200],');
   DM.Qr.SQL.Add('       convert(varchar(10),case Min(p.t2) when -999 then null else Min(p.t2) end)+char(176) as [����. ���. ��_C_1200],');
   DM.Qr.SQL.Add('       (case Max(p.Svet) when 2 then ''��'' when 1 then ''���'' else '''' end) as [�����������._S_1200],');
   DM.Qr.SQL.Add('       (case when n.art_code is null then ''������.'' else '''' end) as [������._S_1700],');
   DM.Qr.SQL.Add('       (case Max(p.in_out) when 0 then ''�����.'' when 1 then ''������.'' else ''������'' end) as [�����- �����_S_1700],');
   DM.Qr.SQL.Add('       (case Max(p.Nds) when 3 then ''��'' else '''' end) as [������� �������_S_1700],');
   DM.Qr.SQL.Add('       Max(p.KategMorion) as [���������_S_1700],');
   DM.Qr.SQL.Add('       IsNull(convert(varchar(10),c.P1),'''')+IsNull(c.L1,'''') as [���_S_1000],');
   DM.Qr.SQL.Add('       IsNull(convert(varchar(10),c.P2),'''')+IsNull(c.L2,'''') as [����_S_1000],');
   DM.Qr.SQL.Add('       IsNull(convert(varchar(10),c.P3),'''')+IsNull(c.L3,'''') as [���_S_1000]');
   DM.Qr.SQL.Add('from Moves a, ');
   DM.Qr.SQL.Add('     SprTov b ');
   DM.Qr.SQL.Add('      left join ');
   DM.Qr.SQL.Add('     Inform..SprReg c on b.art_code=c.art_code ');
   DM.Qr.SQL.Add('      left join ');
   DM.Qr.SQL.Add('     Plist p on b.art_code=p.art_code ');
   DM.Qr.SQL.Add('      left join ');
   DM.Qr.SQL.Add('     SprNoRecipt n on b.art_code=n.art_code');
   DM.Qr.SQL.Add('where a.kod_name=b.kod_name and a.iddoc='+DM.spY_NaklList.FieldByName('IDDOC').AsString);
   DM.Qr.SQL.Add('group by b.art_code,n.art_code,b.Names,c.P1,c.P2,c.P3,c.L1,c.L2,c.L3');
   DM.Qr.SQL.Add('order by b.Names');
   DM.Qr.Open;
   PrintRep.Qr:=DM.Qr;
   PrintRep.PrintTable(False,0,0);
   PrintRep.PreView;

{
 2-������
 1-������.
 0-�����.
}
  except
   on E:Exception do MainF.MessBox('������ ������������ �������� ����� ���������: '+E.Message);
  end;
 end;

procedure TViewNaklF.BitBtn7Click(Sender:TObject);
var Ex:Boolean;
 begin
  try
   PrintMarkBoxF:=TPrintMarkBoxF.Create(Self);
   try
    PrintMarkBoxF.Flag:=1;
    PrintMarkBoxF.CreateList(Ex);
    Application.ProcessMessages;
    if Ex=False then PrintMarkBoxF.ShowModal;
   finally
    PrintMarkBoxF.Free;
   end;
  except
   MainF.MessBox(ER_CR_FORM);
  end;
 end;

procedure TViewNaklF.N1Click(Sender: TObject);
 begin
  if Sender=nil then Exit;
  if DM.qrShowNakl.IsEmpty then Exit;
  PrintCen(TControl(Sender).Tag);
 end;

procedure TViewNaklF.CheckBox2Click(Sender: TObject);
 begin
  if CheckBox2.Checked=False then
   begin
    BitBtn2.Caption:='������ ��������';
    BitBtn8.Caption:='������ �������� �� ������ �������';
   end else begin
             BitBtn2.Caption:='������ ��������';
             BitBtn8.Caption:='������ �������� �� ������ �������';
            end;
 end;

procedure TViewNaklF.BitBtn9Click(Sender: TObject);
var Tb:TTableObj;
begin
  if DM.spY_NaklList.IsEmpty then Exit;
  try
   PrintRep.Clear;
   PrintRep.SetDefault;
   PrintRep.Font.Name:='Arial';
   PrintRep.Font.Size:=5;
   PrintRep.Font.Style:=[fsBold];
   PrintRep.Align:=AL_CENTER;
   PrintRep.AddText('��� � �������������� ������������ ������'#10);
   PrintRep.AddText(Prm.FirmNameRU+'                    �� '+DateToStr(Date)+#10);
   PrintRep.AddText('�� ����� �������� ������� ��������������� �������� ����� '+Prm.AptekaNameRU+#10);
   PrintRep.AddText('���������� ��������� ������������� ������������� ������ � ������� �� ��������� '+DM.spY_NaklList.FieldByName('nn_nakl').AsString+' �� '+DM.spY_NaklList.FieldByName('date_nakl').AsString+#10#10);
   PrintRep.Align:=AL_LEFT;

   PrintRep.AddText('�������'#10);
   PrintRep.Font.Size:=4;
   PrintRep.Font.Style:=[];
   DM.Qr.Close;
   DM.Qr.SQL.Clear;
   DM.Qr.SQL.Add('if Object_ID(N''tempdb..#akt'') is not null drop table #akt');
   DM.Qr.SQL.Add('select ''NumS'' as [� ��._S_700],');
   DM.Qr.SQL.Add('       a.art_code as [���_I_1300],');
   DM.Qr.SQL.Add('       a.names as [������������_S_6000],');
   DM.Qr.SQL.Add('       a.kol as [���-��_I_1300],');
   DM.Qr.SQL.Add('       b.kolscan as [������_I_1300],');
   DM.Qr.SQL.Add('       Abs(a.kol-IsNull(b.kolscan,0)) as [����_I_1300],');
   DM.Qr.SQL.Add('       a.cena as [����_N_1300],');
   DM.Qr.SQL.Add('       a.cena*Abs(a.kol-IsNull(b.kolscan,0)) as [�����_N_1300],');
   DM.Qr.SQL.Add('       c.Users as [��������_S_4000]');
   DM.Qr.SQL.Add('into #akt');
   DM.Qr.SQL.Add('from  (select m.nn_nakl,m.date_nakl,s.art_code,s.names,Sum(m.kol) as kol,m.cena from Moves m, SprTov s where m.kod_name=s.kod_name and m.nn_nakl='''+DM.spY_NaklList.FieldByName('nn_nakl').AsString+''' and m.date_nakl='''+FormatDateTime('yyyy-mm-dd',DM.spY_NaklList.FieldByName('date_nakl').AsDateTime)+' 00:00:00'' group by m.nn_nakl,m.date_nakl,s.art_code,s.names,m.cena) a ');
   DM.Qr.SQL.Add('      left join ScanNakl b on a.art_code=b.art_code and a.nn_nakl=b.nn_nakl and a.date_nakl=b.date_nakl left join SprUser c on b.id_user=c.id');
   DM.Qr.SQL.Add('where a.kol<IsNull(b.kolscan,0)');
   DM.Qr.SQL.Add('order by 3');

   DM.Qr.SQL.Add('if (select Count(*) from #akt)>0');
   DM.Qr.SQL.Add(' insert into #akt([� ��._S_700],[������������_S_6000],[�����_N_1300]) ');
   DM.Qr.SQL.Add(' select '''',''�����'',Sum(a.cena*Abs(a.kol-IsNull(b.kolscan,0))) ');
   DM.Qr.SQL.Add(' from  (select m.nn_nakl,m.date_nakl,s.art_code,s.names,Sum(m.kol) as kol,m.cena from Moves m, SprTov s where m.kod_name=s.kod_name and m.nn_nakl='''+DM.spY_NaklList.FieldByName('nn_nakl').AsString+''' and m.date_nakl='''+FormatDateTime('yyyy-mm-dd',DM.spY_NaklList.FieldByName('date_nakl').AsDateTime)+' 00:00:00'' group by m.nn_nakl,m.date_nakl,s.art_code,s.names,m.cena) a ');
   DM.Qr.SQL.Add('       left join ScanNakl b on a.art_code=b.art_code and a.nn_nakl=b.nn_nakl and a.date_nakl=b.date_nakl left join SprUser c on b.id_user=c.id');
   DM.Qr.SQL.Add(' where a.kol<IsNull(b.kolscan,0)');
   DM.Qr.SQL.Add('select * from #akt order by 1 desc,3');
   DM.Qr.Open;

   PrintRep.Qr:=DM.Qr;
   PrintRep.PrintTable(False,0,0);

   PrintRep.Font.Size:=5;
   PrintRep.Font.Style:=[fsBold];
   PrintRep.AddText(#10#10'���������'#10);
   PrintRep.Align:=AL_LEFT;
   PrintRep.Font.Size:=4;
   PrintRep.Font.Style:=[];

   DM.Qr.Close;
   DM.Qr.SQL.Clear;
   DM.Qr.SQL.Add('if Object_ID(N''tempdb..#akt'') is not null drop table #akt');
   DM.Qr.SQL.Add('select ''NumS'' as [� ��._S_700],');
   DM.Qr.SQL.Add('       a.art_code as [���_I_1300],');
   DM.Qr.SQL.Add('       a.names as [������������_S_6000],');
   DM.Qr.SQL.Add('       a.kol as [���-��_I_1300],');
   DM.Qr.SQL.Add('       b.kolscan as [������_I_1300],');
   DM.Qr.SQL.Add('       Abs(a.kol-IsNull(b.kolscan,0)) as [����_I_1300],');
   DM.Qr.SQL.Add('       a.cena as [����_N_1300],');
   DM.Qr.SQL.Add('       a.cena*Abs(a.kol-IsNull(b.kolscan,0)) as [�����_N_1300],');
   DM.Qr.SQL.Add('       c.Users as [��������_S_4000]');
   DM.Qr.SQL.Add('into #akt');
   DM.Qr.SQL.Add('from  (select m.nn_nakl,m.date_nakl,s.art_code,s.names,Sum(m.kol) as kol,m.cena from Moves m, SprTov s where m.kod_name=s.kod_name and m.nn_nakl='''+DM.spY_NaklList.FieldByName('nn_nakl').AsString+''' and m.date_nakl='''+FormatDateTime('yyyy-mm-dd',DM.spY_NaklList.FieldByName('date_nakl').AsDateTime)+' 00:00:00'' group by m.nn_nakl,m.date_nakl,s.art_code,s.names,m.cena) a ');
   DM.Qr.SQL.Add('      left join ScanNakl b on a.art_code=b.art_code and a.nn_nakl=b.nn_nakl and a.date_nakl=b.date_nakl left join SprUser c on b.id_user=c.id');
   DM.Qr.SQL.Add('where a.kol>IsNull(b.kolscan,0)');
   DM.Qr.SQL.Add('order by 3');

   DM.Qr.SQL.Add('if (select Count(*) from #akt)>0');
   DM.Qr.SQL.Add(' insert into #akt([� ��._S_700],[������������_S_6000],[�����_N_1300]) ');
   DM.Qr.SQL.Add(' select '''',''�����'',Sum(a.cena*Abs(a.kol-IsNull(b.kolscan,0))) ');
   DM.Qr.SQL.Add(' from  (select m.nn_nakl,m.date_nakl,s.art_code,s.names,Sum(m.kol) as kol,m.cena from Moves m, SprTov s where m.kod_name=s.kod_name and m.nn_nakl='''+DM.spY_NaklList.FieldByName('nn_nakl').AsString+''' and m.date_nakl='''+FormatDateTime('yyyy-mm-dd',DM.spY_NaklList.FieldByName('date_nakl').AsDateTime)+' 00:00:00'' group by m.nn_nakl,m.date_nakl,s.art_code,s.names,m.cena) a ');
   DM.Qr.SQL.Add('       left join ScanNakl b on a.art_code=b.art_code and a.nn_nakl=b.nn_nakl and a.date_nakl=b.date_nakl left join SprUser c on b.id_user=c.id');
   DM.Qr.SQL.Add(' where a.kol>IsNull(b.kolscan,0)');
   DM.Qr.SQL.Add('select * from #akt order by 1 desc,3');
   DM.Qr.Open;

   PrintRep.Qr:=DM.Qr;
   PrintRep.PrintTable(False,0,0);

   PrintRep.Font.Size:=5;
   PrintRep.AddText(#10#10'������������� �������� ����� '+Prm.UserName+#10);

   PrintRep.PreView;
  except
   on E:Exception do MainF.MessBox('������ ������������ �������� �����: '+E.Message);
  end;
end;

procedure TViewNaklF.DBGrid2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
 begin
  if Key in K_ARROW_KEYS then FSr:='';
  if Key=VK_RETURN then DBGrid2DblClick(Sender);
 end;

procedure TViewNaklF.DBGrid2KeyPress(Sender: TObject; var Key: Char);
var db:TDBGrid;
    NC:Integer;
    IsFind:Boolean;
begin
  if Sender=nil then Exit;
  if DM.spY_NaklList.IsEmpty then Exit;
  if DM.qrShowNakl.IsEmpty then Exit;
  if Copy(DM.spY_NaklList.FieldByName('nn_nakl').AsString,2,3)='��-' then Exit;
  if Key in CH_DIGIT then
   begin
    FSr:=FSr+Key;
    FSr:=MainF.FindEAN13(TDBGrid(Sender),FSr,SC_MOVES,1,IsFind,DM.spY_NaklList.FieldByName('iddoc').AsInteger);
    if isFind then EnterKol(DM.qrShowNakl.FieldByName('art_code').AsInteger,0);
   end;
end;

procedure TViewNaklF.DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var Kol,Pr:Integer;
    db:TDBGrid;
begin
  if Sender=nil then Exit;
  db:=TDBGrid(Sender);
  Kol:=db.DataSource.DataSet.FieldByName('Kol').AsInteger;
  pr:=db.DataSource.DataSet.FieldByName('IsScan').AsInteger;
  if pr<>0 then
   begin
    if (gdSelected in State) and (DataCol=2) then
     begin
      db.Canvas.Brush.Color:=clNavy;
      db.Canvas.Font.Color:=clWhite;
     end else begin
               if Kol=Pr then db.Canvas.Brush.Color:=clLime else
               if Pr<Kol then db.Canvas.Brush.Color:=clYellow
                         else db.Canvas.Brush.Color:=$008080FF;
               db.Canvas.Font.Color:=clBlack;
              end;
    db.DefaultDrawColumnCell(Rect,DataCol,Column,State);
   end;
end;

procedure TViewNaklF.DBGrid2DblClick(Sender: TObject);
begin
  try
   if DM.qrShowNakl.IsEmpty then Exit;
   EnterKol(DM.qrShowNakl.FieldByName('Art_Code').AsInteger,1);
  except
   on E:Exception do MainF.MessBox('������ ������ � ������ ������������ ���������: '+E.Message);
  end;
end;

procedure TViewNaklF.EnterKol(AC:Integer; P:Byte);
var Kol,Kol1,TP:Integer;
    IsOne:Boolean;
begin

  if DM.qrShowNakl.IsEmpty then Exit;
  if CheckMarked=False then Exit;

  DM.Qr6.Close;
  DM.Qr6.SQL.Text:='select dbo.GetKoefUpak('+IntToStr(AC)+') as Koef';
  DM.Qr6.Open;

  IsOne:=DM.qrShowNakl.FieldByName('Priznak').AsInteger=18;

  EnterKolScanF:=TEnterKolScanF.Create(Self);
  try
   Kol:=DM.Qr6.FieldByName('Koef').AsInteger;
   EnterKolScanF.Label2.Caption:=DM.qrShowNakl.FieldByName('Names').AsString;
   Kol1:=DM.qrShowNakl.FieldByName('Kol').AsInteger-DM.qrShowNakl.FieldByName('IsScan').AsInteger;
   if Kol1<0 then Kol1:=0;

   if IsOne then
    begin
     EnterKolScanF.edKol.Text:='1';
     EnterKolScanF.edKol.Enabled:=False;
    end else begin
              if Kol<Kol1 then
               EnterKolScanF.edKol.Text:=IntToStr(Kol)
              else
               EnterKolScanF.edKol.Text:=IntToStr(Kol1);
             end;

   if P=1 then
    begin
    end;

   Application.ProcessMessages;
   EnterKolScanF.ShowModal;
   if EnterKolScanF.Flag<>1 then Exit;

   Kol:=StrToInt(EnterKolScanF.edKol.Text);
   if P=1 then TP:=3 else
    begin
     TP:=1;
     if EnterKolScanF.cbHand.Checked then TP:=2;
    end;
   DM.Qr6.Close;
   DM.Qr6.SQL.Clear;
   DM.Qr6.SQL.Add('declare @rowid int, @kol int');

   DM.Qr6.SQL.Add('set @kol=IsNull((select Sum(IsScan)');
   DM.Qr6.SQL.Add('from Moves a, SprTov b');
   DM.Qr6.SQL.Add('where a.kod_name=b.kod_name and b.art_Code='+DM.qrShowNakl.FieldByName('Art_Code').AsString);
   DM.Qr6.SQL.Add('      and a.iddoc='+DM.spY_NaklList.FieldByName('iddoc').AsString+'),0)');

   DM.Qr6.SQL.Add('update a set IsScan=0');
   DM.Qr6.SQL.Add('from rTovar a, SprTov b');
   DM.Qr6.SQL.Add('where a.kod_name=b.kod_name and b.art_Code='+DM.qrShowNakl.FieldByName('Art_Code').AsString);
   DM.Qr6.SQL.Add('      and a.iddoc='+DM.spY_NaklList.FieldByName('iddoc').AsString);

   DM.Qr6.SQL.Add('set @rowid=(select top 1 a.id from rTovar a, SprTov b ');
   DM.Qr6.SQL.Add('where a.kod_name=b.kod_name and b.art_Code='+DM.qrShowNakl.FieldByName('Art_Code').AsString);
   DM.Qr6.SQL.Add('      and a.iddoc='+DM.spY_NaklList.FieldByName('iddoc').AsString+')');
   DM.Qr6.SQL.Add('');
   DM.Qr6.SQL.Add(' update rTovar set IsScan=@kol+'+IntToStr(Kol)+' where id=@rowid');
   DM.Qr6.SQL.Add(' update rTovar set DateScan=getdate(),id_user='+IntToStr(Prm.UserID)+',prscan='+IntToStr(TP));
   DM.Qr6.SQL.Add(' where iddoc='+DM.spY_NaklList.FieldByName('iddoc').AsString+' and kod_name in (select kod_name from SprTov (nolock) where art_code='+DM.qrShowNakl.FieldByName('Art_Code').AsString+')');

   DM.Qr6.ExecSQL;

  finally
   FSr:='';
   EnterKolScanF.Free;
   NaklList(0);
  end;
end;

procedure TViewNaklF.pm11Click(Sender: TObject);
begin
  if DM.qrShowNakl.IsEmpty then Exit;
  if CheckMarked=False then Exit;

  if MainF.MessBox('�� ������������� ������ �������� ������?',52)<>ID_YES then Exit;
  try
   DM.Qr6.Close;
   DM.Qr6.SQL.Clear;
   DM.Qr6.SQL.Add('update a set IsScan=0, Shtrih=null ');
   DM.Qr6.SQL.Add('from rTovar a, SprTov b ');
   DM.Qr6.SQL.Add('where a.kod_name=b.kod_name and b.art_Code='+DM.qrShowNakl.FieldByName('Art_Code').AsString);
   DM.Qr6.SQL.Add('      and a.iddoc='+DM.spY_NaklList.FieldByName('iddoc').AsString);
   DM.Qr6.ExecSQL;
   NaklList(0);
  except
   on E:Exception do MainF.MessBox('������ ������� ������: '+E.Message);
  end;
end;

function TViewNaklF.CheckMarked:Boolean;
begin
  Result:=False;
  if Not (DM.spY_NaklList.FieldByName('idpriznak').AsInteger in [4,5,6]) then
   begin
    Result:=True;
    Exit;
   end;

  if DM.spY_NaklList.FieldByName('Marked').AsInteger=1 then
   begin
    MainF.MessBox('������� ��� ������� ��� ���������������. ����� �������� �� �������������� � ������������ ������ ���������!');
    Result:=False;
   end else Result:=True;
end;

procedure TViewNaklF.bbCloseBoxClick(Sender:TObject);
var Num,NumBox:String;
begin
  try
   if DM.spY_NaklList.IsEmpty then Exit;
   if CheckMarked=False then Exit;

   DM.Qr.Close;
   DM.Qr.SQL.Text:='select top 1 shtrih from Moves where IsNull(IsScan,0)>0 and IsNull(Shtrih,0)=0 and iddoc='+DM.spY_NaklList.FieldByName('iddoc').AsString;
   DM.Qr.Open;

   if DM.Qr.IsEmpty then begin MainF.MessBox('��� ���������� ������!'); Exit; end;
   if MainF.MessBox('�� ������������� ������ ������� ����?',52)<>ID_YES then Exit;

   DM.Qr.Close;
   DM.Qr.SQL.Clear;
   DM.Qr.SQL.Add('declare @ida varchar(5), @num bigint, @numfull varchar(20) ');
   DM.Qr.SQL.Add('set @ida=(select Value from Spr_const where Descr=''ID_APTEKA'') ');
   DM.Qr.SQL.Add('set @num=IsNull((select convert(bigint,Value) from Spr_const where Descr=''NumBox''),0)+1 ');
   DM.Qr.SQL.Add('select ''2''+replicate(''0'',6-len(convert(varchar,@num)))+convert(varchar,@num)+replicate(''0'',3-len(convert(varchar(3),@ida)))+@ida+''01'' as NumBox, @num as  Num');
   DM.Qr.Open;
   if DM.Qr.IsEmpty then Abort;

   Num:=DM.Qr.FieldByName('Num').AsString;
   NumBox:=DM.Qr.FieldByName('NumBox').AsString;

   DM.Qr.Close;
   DM.Qr.SQL.Clear;
   DM.Qr.SQL.Add('update rTovar set shtrih='+NumBox+' where IsNull(IsScan,0)>0 and IsNull(Shtrih,0)=0 and iddoc='+DM.spY_NaklList.FieldByName('iddoc').AsString);
   DM.Qr.SQL.Add('update rTovar set shtrih=(select Max(shtrih) from rTovar m (nolock), SprTov s (nolock) where m.iddoc=a.iddoc and IsNull(Shtrih,0)>0 and m.kod_name=s.kod_name and s.art_code=b.art_code) ');
   DM.Qr.SQL.Add('from rTovar a (nolock), SprTov b (nolock) ');
   DM.Qr.SQL.Add('where a.kod_name=b.kod_name and a.iddoc='+DM.spY_NaklList.FieldByName('iddoc').AsString);

   DM.Qr.SQL.Add('delete from Spr_Const where Descr=''NumBox'' ');
   DM.Qr.SQL.Add('insert into Spr_Const(Descr,Value) values(''NumBox'','''+Num+''') ');

   DM.Qr.ExecSQL;
   NaklList(0);

  except
   on E:Exception do MainF.MessBox('������ �������� �����: '+E.Message);
  end;
end;

procedure TViewNaklF.BitBtn10Click(Sender: TObject);
var Res:String;
begin
  if DM.spY_NaklList.IsEmpty then Exit;

  DM.Qr.Close;
  DM.Qr.SQL.Text:='select top 1 shtrih from Moves where IsNull(IsScan,0)>0 and IsNull(Shtrih,0)=0 and iddoc='+DM.spY_NaklList.FieldByName('iddoc').AsString;
  DM.Qr.Open;
  if DM.Qr.IsEmpty=False then begin MainF.MessBox('������� ����� ������� ����!'); Exit; end;

  if MainF.MessBox('�� ������������� ������ �������� ��������� "'+DM.spY_NaklList.FieldByName('nn_nakl').AsString+'" ��� ���������������?'#10#10+
                   '��� ������ ����� �������� ����� ���� ��� �� ������������� ��������� � ������� ��� �����!!!',
                   52,GetFont('MS Sans Serif',12,clBlue,[fsBold]),0,Res)<>ID_YES then Exit;
  try
   DM.Qr.Close;
   DM.Qr.SQL.Clear;
   DM.Qr.SQL.Add('update JMoves set Marked=1 where iddoc='+DM.spY_NaklList.FieldByName('iddoc').AsString);
   DM.Qr.ExecSQL;

   NaklList(0);
  except
   on E:Exception do MainF.MessBox('������ ������� � ����������� ���������: '+E.Message);
  end;

end;

procedure TViewNaklF.N3Click(Sender: TObject);
begin
  if DM.spY_NaklList.IsEmpty then Exit;
  if Not MainF.CheckPassword('2726011013') then Exit;
  DM.Qr.Close;
  DM.Qr.SQL.Text:='update Jmoves set Marked=null where iddoc=:iddoc';
  DM.Qr.Parameters.ParamByName('iddoc').Value:=DM.spY_NaklList.FieldByName('iddoc').AsInteger;
  DM.Qr.ExecSQL;
  BitBtn5Click(BitBtn5);
end;

procedure TViewNaklF.bbVzrClick(Sender: TObject);
begin
  if DM.spY_NaklList.IsEmpty then Exit;
  VozrPartF:=TVozrPartF.Create(Self);
  try
   VozrPartF.iddoc:=DM.spY_NaklList.FieldByName('iddoc').AsInteger;
   VozrPartF.ShowModal;
  finally
   VozrPartF.Free;
  end;
end;

procedure TViewNaklF.BitBtn11Click(Sender: TObject);
//var
//  psw: string;
begin
//  psw:='';
////  if (DM.spY_NaklList.Active) and (DM.spY_NaklList.FieldByName('Date_Nakl').Value < Date() - 3) then
////  begin
//    with aTmp do
//    begin
//      SQL.Clear;
//      SQL.Add('select passw,dtend from sprprvozr where id=27');
//      Open;
//    end;
//    if aTmp.FieldByName('dtend').Value>date() then psw:=aTmp.FieldByName('passw').Value;
//    if Not MainF.CheckPassword(psw) then Exit;
////  end;

  if (not rbPr.Checked)and(DM.spY_NaklList.RecordCount<=0) then exit;
  ReturnToProviderF:=TReturnToProviderF.Create(self);

  try
    ReturnToProviderF.Position:=poMainFormCenter;

    if not ViewNaklF.ADOQuery1.FieldByName('nn_nakl').IsNull then ReturnToProviderF.lblnn_nakl.Caption:=ViewNaklF.ADOQuery1.FieldByName('nn_nakl').Value else ReturnToProviderF.lblnn_nakl.Caption:='';
    if not ViewNaklF.ADOQuery1.FieldByName('date_nakl').IsNull then ReturnToProviderF.lbldt_nakl.Caption:=ViewNaklF.ADOQuery1.FieldByName('date_nakl').Value else ReturnToProviderF.lbldt_nakl.Caption:='';
    if not ViewNaklF.ADOQuery1.FieldByName('descr').IsNull then ReturnToProviderF.lblPostavschik.Caption:=ViewNaklF.ADOQuery1.FieldByName('descr').Value else ReturnToProviderF.lblPostavschik.Caption:='';
    if not ViewNaklF.ADOQuery1.FieldByName('nn_prih').IsNull then ReturnToProviderF.lblNaklNomber.Caption:=ViewNaklF.ADOQuery1.FieldByName('nn_prih').Value else ReturnToProviderF.lblNaklNomber.Caption:='';
    if not ViewNaklF.ADOQuery1.FieldByName('dt_prih').IsNull then ReturnToProviderF.lblNaklDate.Caption:=ViewNaklF.ADOQuery1.FieldByName('dt_prih').Value else ReturnToProviderF.lblNaklDate.Caption:='';
    if not ViewNaklF.ADOQuery1.FieldByName('iddoc').IsNull then ReturnToProviderF.IDDoc:=ViewNaklF.ADOQuery1.FieldByName('iddoc').Value else ReturnToProviderF.IDDoc:=0;

    ReturnToProviderF.ShowModal;
  finally
    ReturnToProviderF.Free;
  end;
end;

procedure TViewNaklF.CheckBox4Click(Sender: TObject);
 begin
  BitBtn5Click(Sender);
 end;

procedure TViewNaklF.BitBtn12Click(Sender: TObject);
var
  Tb:TTableObj;
  code_name: integer;
  rec_count: integer;
  i: integer;
  p_nds: double;
  summa_vozvrata: double;
  summa_nds: double;
  kol_naim: Integer;
  kol_upak: double;
  str: string;

const
  underlines = '_____________________';
  Guaranie = '���������, �� �� ������ ������, �� ������ � ��� �������� �������� ������ ������ ����������� � ������ ���������� � ���������� � ������� ���������, ������������� ����������.';
  responsible='������������ �����:';
  sign1 = '(�.�.�.)';
  sign = 'ϳ����:';
  releaser = '³�������:';
  goter = '�������:';
  white_spaces='                               ';
begin
  try
    PrintRep.Clear;
    PrintRep.SetDefault;
    PrintRep.Font.Name:='Arial'; PrintRep.Font.Size:=4; PrintRep.Font.Style:=[];
    PrintRep.Orientation:=O_PORTR; PrintRep.PageSize:=PF_A4; PrintRep.Align:=AL_LEFT;

    PrintRep.Font.Size:=7; PrintRep.Font.Style:=[fsBold];
    PrintRep.AddText(Prm.FirmNameUA+#10);
    PrintRep.AddText('______________________________________________________'+#10);

    PrintRep.Font.Size:=4; PrintRep.Font.Style:=[]; PrintRep.Align:=AL_LEFT;

    PrintRep.AddText(#10);
    PrintRep.AddTable(2,4);
    Tb:=PrintRep.LastTable;
    Tb.SetWidths('700,1500'); Tb.SetBorders(1,1,2,4,EMPTY_BORDER);

    with ADOQuery2 do
    begin
      SQL.Clear;
      SQL.Add('declare @id_firm int set @id_firm = :id_firm');
      SQL.Add('select * from SPRFIRMS (nolock) where id_firm=@id_firm');
      Parameters.Clear;
      Parameters.CreateParameter('id_firm',ftInteger,pdInput,10,Prm.FirmID);
      Open;
    end;

    Tb.Cell[2,1].Font.Style:=[]; Tb.Cell[2,1].AddText('�/� ');
    Tb.Cell[2,1].Font.Style:=[fsBold,fsUnderline];
    if not ADOQuery2.FieldByName('r_r').IsNull then Tb.Cell[2,1].AddText(ADOQuery2.FieldByName('r_r').Value+' ') else Tb.Cell[2,1].AddText(underlines+' ');

    Tb.Cell[2,1].Font.Style:=[fsBold,fsUnderline];
    if not ADOQuery2.FieldByName('bank').IsNull then Tb.Cell[2,1].AddText(ADOQuery2.FieldByName('bank').Value+'; ') else Tb.Cell[2,1].AddText(underlines+'; ');

    Tb.Cell[2,1].Font.Style:=[]; Tb.Cell[2,1].AddText('��� ');
    Tb.Cell[2,1].Font.Style:=[fsBold,fsUnderline];
    if not ADOQuery2.FieldByName('mfo').IsNull then Tb.Cell[2,1].AddText(ADOQuery2.FieldByName('mfo').Value+'; ') else Tb.Cell[2,1].AddText(underlines+'; ');

    Tb.Cell[2,1].Font.Style:=[]; Tb.Cell[2,1].AddText('��� ���� ');
    Tb.Cell[2,1].Font.Style:=[fsBold,fsUnderline];
    if not ADOQuery2.FieldByName('okpo').IsNull then Tb.Cell[2,1].AddText(ADOQuery2.FieldByName('okpo').Value+#10) else Tb.Cell[2,1].AddText(underlines+#10);

    with ADOQuery1 do
    begin
      SQL.Clear;
      SQL.Add('select * from SPRFIRMS (nolock) where DescrUA=:firm');
      Parameters.Clear;
      Parameters.CreateParameter('firm',ftString,pdInput,100,Prm.FirmNameUA);
      Open;
    end;

    Tb.Cell[2,2].AddText('�������� ������: '+ADOQuery1.FieldByName('SkladAdress').Value+#10);
    Tb.Cell[2,3].AddText('�������� ������: '+Prm.aAdress+#10);
    Tb.Cell[2,4].AddText('�������: '+underlines+#10);

    PrintRep.AddText(#10+'�������� �� ���������� � '); PrintRep.Font.Style:=[fsUnderline]; PrintRep.AddText(' '+DM.spY_NaklList.FieldByName('nn_nakl').Value+' '+#10);
    PrintRep.Font.Style:=[]; PrintRep.AddText('�� '+underlines+#10);

    if (assigned(ViewNaklF))and(ViewNaklF.Showing) then
      ReturnList(ViewNaklF,ADOQuery1);
    ADOQuery1.First;

    PrintRep.Align:=AL_CENTER;
    PrintRep.AddText(#10+'�� ��������� � ');
    if not ADOQuery1.FieldByName('id_postav').IsNull then
    begin
      if not ADOQuery1.FieldByName('nn_prih').IsNull then
      begin
        PrintRep.Font.Style:=[fsUnderline];
        PrintRep.AddText(' '+ADOQuery1.FieldByName('nn_prih').Value+' ');
      end
      else
        PrintRep.AddText(' '+underlines+' ');
      PrintRep.Font.Style:=[]; PrintRep.AddText(' �� '); PrintRep.Font.Style:=[fsUnderline];
      if not ADOQuery1.FieldByName('dt_prih').IsNull then
        PrintRep.AddText(' '+FormatDateTime('DD.MM.YYYY',ADOQuery1.FieldByName('dt_prih').Value)+' '+#10+#10)
      else
        PrintRep.AddText(' '+underlines+' '+#10+#10)
    end
    else
    begin
      PrintRep.Font.Style:=[]; PrintRep.AddText(' '+underlines+'  ��  '+underlines+' '+#10+#10);
    end;

    PrintRep.Align:=AL_LEFT;
    PrintRep.Font.Style:=[]; PrintRep.AddText('³� ����: '); PrintRep.Font.Style:=[fsBold,fsUnderline]; PrintRep.AddText(' '+Prm.FirmNameUA+' '+#10);
    PrintRep.Font.Style:=[]; PrintRep.AddText('����: '); PrintRep.Font.Style:=[fsBold,fsUnderline];
    if not ADOQuery1.FieldByName('descr').IsNull then PrintRep.AddText(ADOQuery1.FieldByName('descr').Value+#10) else PrintRep.AddText(underlines+#10);
    PrintRep.Font.Style:=[]; PrintRep.AddText('������: '); PrintRep.Font.Style:=[fsBold,fsUnderline];

//    if not ADOQuery1.FieldByName('Adres').IsNull then PrintRep.AddText(ADOQuery1.FieldByName('Adres').Value+#10) else PrintRep.AddText(underlines+#10); //������ ����� ���������� ����� ������������� �� � ������������ (�����������)
    PrintRep.AddText(underlines+#10); //������ ����� �������  � �������� ���������� ����� ������������� �� � ������������ (�����������)

    PrintRep.Font.Style:=[];
    PrintRep.AddText('����� ����: '+#10);
    PrintRep.AddText('��������� � '+underlines+' ���� '+underlines+' �� '+underlines+#10);
    PrintRep.AddText('����� � ��������� '+#10+#10);

    //������ ������ ������� � ��������
    rec_count:=0;

    rec_count:=ADOQuery1.RecordCount+1;
    PrintRep.AddTable(9,rec_count);
    Tb:=PrintRep.LastTable;
    Tb.SetWidths('150,1200,225,375,375,375,375,375,600');
    Tb.SetBorders(1,1,9,1,Border(clBlack,4,psInsideFrame));
    Tb.Cell[1,1].Font.Style:=[fsBold]; Tb.Cell[1,1].Align:=AL_CENTER; Tb.Cell[1,1].AddText('��');
    Tb.Cell[2,1].Font.Style:=[fsBold]; Tb.Cell[2,1].Align:=AL_CENTER; Tb.Cell[2,1].AddText('������������ ������');
    Tb.Cell[3,1].Font.Style:=[fsBold]; Tb.Cell[3,1].Align:=AL_CENTER; Tb.Cell[3,1].AddText('��.');
    Tb.Cell[4,1].Font.Style:=[fsBold]; Tb.Cell[4,1].Align:=AL_CENTER; Tb.Cell[4,1].AddText('ʳ������ ��������');
    Tb.Cell[5,1].Font.Style:=[fsBold]; Tb.Cell[5,1].Align:=AL_CENTER; Tb.Cell[5,1].AddText('ֳ�� ��� ���');
    Tb.Cell[6,1].Font.Style:=[fsBold]; Tb.Cell[6,1].Align:=AL_CENTER; Tb.Cell[6,1].AddText('���� ��� ���');
    Tb.Cell[7,1].Font.Style:=[fsBold]; Tb.Cell[7,1].Align:=AL_CENTER; Tb.Cell[7,1].AddText('����');
    Tb.Cell[8,1].Font.Style:=[fsBold]; Tb.Cell[8,1].Align:=AL_CENTER; Tb.Cell[8,1].AddText('�����');
    Tb.Cell[9,1].Font.Style:=[fsBold]; Tb.Cell[9,1].Align:=AL_CENTER; Tb.Cell[9,1].AddText('��������');

    //����� ���������
    i:=2;
    summa_vozvrata:=0;
    summa_nds:=0;
    kol_naim:=0;
    ADOQuery1.First;
    while not ADOQuery1.Eof do
    begin
      //����� ������ � ���������
      Tb.Cell[1,i].Align:=AL_RIGHT; Tb.Cell[1,i].AddText(IntToStr(i-1));
      //�������� ������������� ���������
      Tb.Cell[2,i].Align:=AL_CENTER; Tb.Cell[2,i].AddText(ADOQuery1.FieldByName('Names').Value);
      //������� ���������
//      Tb.Cell[3,i].Align:=AL_CENTER; Tb.Cell[3,i].AddText(ADOQuery1.FieldByName('EdName').Value);
      Tb.Cell[3,i].Align:=AL_CENTER; Tb.Cell[3,i].AddText('����.');
      //���������� ��������. ����� ���� �������: ���������� �������� � ��������� / �����������(���������� ������ � ��������)
      Tb.Cell[4,i].Align:=AL_CENTER; Tb.Cell[4,i].AddText(FloatToStr(StrToFloat(FloatToStrF(ADOQuery1.FieldByName('kol').Value/ADOQuery1.FieldByName('koef').Value,10,3))));
      //���� ��� ��� �� ������� (�� ��������)
      case ADOQuery1.FieldByName('f_nds').Value of
        1: p_nds:=0.2;
        2: p_nds:=0.07;
      end;
      Tb.Cell[5,i].Align:=AL_CENTER; Tb.Cell[5,i].
      AddText(FloatToStr(RoundCurr(ADOQuery1.FieldByName('koef').Value*ADOQuery1.FieldByName('cenazakup').Value)));
//      AddText(FloatToStr(RoundCurr(ADOQuery1.FieldByName('koef').Value*ADOQuery1.FieldByName('cenazakup').Value*(1-p_nds))));
//      AddText(FloatToStr(RoundCurr(ADOQuery1.FieldByName('koef').Value*ADOQuery1.FieldByName('cena').Value*(1-p_nds))));
//      AddText(FloatToStr(RoundCurr(ADOQuery1.FieldByName('kol').Value/ADOQuery1.FieldByName('koef').Value*ADOQuery1.FieldByName('cena').Value*(1-p_nds))));
      //����� ���� ������������� ������ ��� ���: ���������� ������ * ���� ��� ��� �� �������
      Tb.Cell[6,i].Align:=AL_CENTER;
      Tb.Cell[6,i].AddText(CurrToStr(RoundCurr(ADOQuery1.FieldByName('kol').Value*(ADOQuery1.FieldByName('cenazakup').Value))));
//      Tb.Cell[6,i].AddText(CurrToStr(RoundCurr(ADOQuery1.FieldByName('kol').Value*(ADOQuery1.FieldByName('cenazakup').Value*(1-p_nds)))));
//      Tb.Cell[6,i].AddText(CurrToStr(RoundCurr(ADOQuery1.FieldByName('kol').Value*(ADOQuery1.FieldByName('cena').Value*(1-p_nds)))));

      Tb.Cell[7,i].Align:=AL_CENTER;
      if not ADOQuery1.FieldByName('NumSeriya').IsNull then Tb.Cell[7,i].AddText(ADOQuery1.FieldByName('NumSeriya').Value);
      Tb.Cell[8,i].Align:=AL_CENTER;
      if not ADOQuery1.FieldByName('SrokGodn').IsNull then Tb.Cell[8,i].AddText(FormatDateTime('DD/MM/YYYY',ADOQuery1.FieldByName('SrokGodn').Value));
      Tb.Cell[9,i].Align:=AL_CENTER;
      Tb.Cell[9,i].Font.Size:=3;
      Tb.Cell[9,i].AddText(ADOQuery1.FieldByName('Manufacturer').Value);
      //����� �������� ��� ���
      summa_vozvrata:=summa_vozvrata+ADOQuery1.FieldByName('kol').Value*(ADOQuery1.FieldByName('cenazakup').Value);
//      summa_vozvrata:=summa_vozvrata+ADOQuery1.FieldByName('kol').Value*(ADOQuery1.FieldByName('cenazakup').Value*(1-p_nds));
//      summa_vozvrata:=summa_vozvrata+ADOQuery1.FieldByName('kol').Value*(ADOQuery1.FieldByName('cena').Value*(1-p_nds));
      summa_nds:=summa_nds+ADOQuery1.FieldByName('kol').Value*(ADOQuery1.FieldByName('cenazakup').Value*p_nds);
//      summa_nds:=summa_nds+ADOQuery1.FieldByName('kol').Value*(ADOQuery1.FieldByName('cena').Value*p_nds);
      //���������� ������������ � ���������� ��������
      kol_naim:=kol_naim+1;
      kol_upak:=kol_upak+ADOQuery1.FieldByName('kol').Value/ADOQuery1.FieldByName('koef').Value;

      i:=i+1;
      ADOQuery1.Next;
    end;

    PrintRep.AddText(#10);
    PrintRep.AddTable(3,5);
    PrintRep.Font.Style:=[fsBold];
    PrintRep.Align:=AL_RIGHT;
    Tb:=PrintRep.LastTable;
    Tb.SetWidths('2325,375,1275');
    Tb.SetBorders(1,1,3,5,EMPTY_BORDER);//Border(clBlack,4,psSolid)
    Tb.Cell[1,1].Align:=AL_RIGHT; Tb.Cell[1,1].AddText('���� ��� ��� '); Tb.Cell[2,1].Align:=AL_RIGHT; Tb.Cell[2,1].AddText(CurrToStr(RoundCurr(summa_vozvrata)));
    Tb.Cell[1,3].Align:=AL_RIGHT; Tb.Cell[1,3].AddText('���� ��� '); Tb.Cell[2,3].Align:=AL_RIGHT; Tb.Cell[2,3].AddText(CurrToStr(RoundCurr(summa_nds)));
    Tb.Cell[1,5].Align:=AL_RIGHT; Tb.Cell[1,5].AddText('���� � ����������� ��� '); Tb.Cell[2,5].Align:=AL_RIGHT; Tb.Cell[2,5].AddText(CurrToStr(RoundCurr(summa_vozvrata+summa_nds)));

    PrintRep.Align:=AL_LEFT;
    PrintRep.Font.Style:=[]; PrintRep.AddText(#10+'������ ����������� ');
    PrintRep.Font.Style:=[fsBold,fsUnderline]; PrintRep.AddText(IntToWordsUA(kol_naim,0)+#10);

    str:='';
    PrintRep.Font.Style:=[]; PrintRep.AddText('�������� ������� ');
    PrintRep.Font.Style:=[fsBold,fsUnderline];
    str:=FloatToWordsUA(kol_upak,10,3);
    PrintRep.AddText(str); PrintRep.Font.Style:=[]; PrintRep.AddText(' ��������(�)'+#10);

    PrintRep.AddText('�� ���� '); PrintRep.Font.Style:=[fsBold,fsUnderline];
    PrintRep.AddText(CurrToWordsUA(summa_vozvrata,1));
    PrintRep.Font.Style:=[]; PrintRep.AddText(' ��� ���'+#10);

    PrintRep.AddText('��� '); PrintRep.Font.Style:=[fsBold,fsUnderline]; PrintRep.AddText(CurrToWordsUA(summa_nds,1)+#10);

    PrintRep.Font.Style:=[]; PrintRep.AddText('�� ����� '); PrintRep.Font.Style:=[fsBold,fsUnderline];
    PrintRep.AddText(CurrToWordsUA((summa_vozvrata+summa_nds),1));
    PrintRep.Font.Style:=[]; PrintRep.AddText(' � ����������� ���'+#10);

    //�������� ��������
    PrintRep.Font.Style:=[fsBold]; PrintRep.AddText(#10+#10+Guaranie+#10);

    //�������
    PrintRep.Font.Size:=4;
    PrintRep.Font.Style:=[];
    PrintRep.AddText(#10+responsible+' '+underlines+' '+' '+sign1+#10);
    PrintRep.AddText(#10+sign+underlines+#10);
    PrintRep.AddText(#10+#10+releaser+underlines+'(������, �.�.�.)'+white_spaces+goter+underlines+'(������, �.�.�.)'+#10);
    PrintRep.AddText(#10+sign+underlines+#10);
    PrintRep.AddText('                                                  ̳��� �������');

    PrintRep.PreView;
  except
    on E:Exception do MainF.MessBox('������ ������������ �������� ����� ���������: '+E.Message);
  end;
end;

procedure TViewNaklF.BitBtn14Click(Sender: TObject);
var
  Tb: TTableObj;
const
  underlines = '_____________________';
begin
  try
    PrintRep.Clear;
    PrintRep.SetDefault;
    PrintRep.Font.Name:='Arial'; PrintRep.Font.Size:=6; PrintRep.Font.Style:=[];
    PrintRep.PageSize:=PF_A4; PrintRep.Orientation:=O_PORTR; PrintRep.Align:=AL_LEFT;

    if (assigned(ViewNaklF))and(ViewNaklF.Showing) then
      ReturnList(ViewNaklF,ADOQuery1);
    PrintRep.AddTable(1,6);
    Tb:=PrintRep.LastTable;
    Tb.SetWidths('2500');
    Tb.SetBorders(1,1,6,1,DEFAULT_BORDER);
    Tb.Cell[1,1].AddText('������� ���������� ');
    if not ADOQuery1.FieldByName('descr').IsNull then Tb.Cell[1,1].AddText(' '+ADOQuery1.FieldByName('descr').Value) else Tb.Cell[1,1].AddText(' '+underlines);
    if not ADOQuery1.FieldByName('adres').IsNull then Tb.Cell[1,1].AddText(' '+ADOQuery1.FieldByName('adres').Value+' '+#10) else Tb.Cell[1,1].AddText(' '+underlines+underlines+' '+#10);
    Tb.Cell[1,2].AddText('�� '+Prm.FirmNameRU);
    Tb.Cell[1,3].AddText(Prm.AptekaNameRU);
    Tb.Cell[1,4].AddText('�����: '+Prm.aAdress);
    Tb.Cell[1,5].AddText(ADOQuery1.FieldByName('nn_nakl').Value);
    Tb.Cell[1,6].AddText('�������: ������� ����������');
    PrintRep.AddText(#10);
    PrintRep.Font.Size:=8; PrintRep.Font.Style:=[fsBold]; PrintRep.Align:=AL_CENTER;
    PrintRep.AddText('����� �� ����� �� ����������'+#10);
    PrintRep.Font.Size:=3; PrintRep.Font.Style:=[fsBold]; PrintRep.Align:=AL_LEFT; PrintRep.LeftIndent:=0; PrintRep.AddText(underlines+underlines+underlines+underlines+underlines+underlines+#10);

    PrintRep.PreView;
  except
    on E:Exception do MainF.MessBox('������ ������������ �������� ����� ���������: '+E.Message);
  end;
end;

procedure TViewNaklF.BitBtn15Click(Sender: TObject);
var
  Tb: TTableObj;
  Rec_Count: integer;
  rec_no: integer;
  kol_return: double;
const
  underlines = '_____________________';
begin
  try
    PrintRep.Clear;
    PrintRep.SetDefault;
    PrintRep.Font.Name:='Arial'; PrintRep.Font.Size:=4; PrintRep.Font.Style:=[];
    PrintRep.PageSize:=PF_A4; PrintRep.Orientation:=O_PORTR; PrintRep.Align:=AL_LEFT;

    PrintRep.AddTable(2,1);
    Tb:=PrintRep.LastTable;
    Tb.SetWidths('1000,1500');
    Tb.SetBorders(1,1,2,1,EMPTY_BORDER);

    if (assigned(ViewNaklF))and(ViewNaklF.Showing) then
      ReturnList(ViewNaklF,ADOQuery1);
    Tb.Cell[2,1].AddText('��������� �������� �������'+#10);
    if not ADOQuery1.FieldByName('descr').IsNull then Tb.Cell[2,1].AddText(ADOQuery1.FieldByName('descr').Value+#10) else Tb.Cell[2,1].AddText('� '+underlines+#10+#10);
    if not ADOQuery1.FieldByName('adres').IsNull then Tb.Cell[2,1].AddText(' '+ADOQuery1.FieldByName('adres').Value+' '+#10) else Tb.Cell[2,1].AddText(' '+underlines+underlines+' '+#10);
    Tb.Cell[2,1].AddText(#10+underlines+underlines+#10);

    PrintRep.Align:=AL_CENTER;
    PrintRep.AddText(#10+#10+#10+'���������� ����'+#10+#10);

    PrintRep.Align:=AL_LEFT;
    PrintRep.AddText('��� ������ �, '+underlines+underlines+' (�.�.�.) '+underlines+' (������) ');
    PrintRep.Font.Style:=[fsBold,fsUnderline]; PrintRep.AddText(Prm.AptekaNameUA+' '+Prm.aAdress);
    PrintRep.Font.Style:=[]; PrintRep.AddText(' (����� ��������) ');
    PrintRep.AddText('����������, �� ���������, �������� ����� �������� � ');
    PrintRep.Font.Style:=[fsBold,fsUnderline];
    if not ADOQuery1.FieldByName('nn_prih').IsNull then PrintRep.AddText(ADOQuery1.FieldByName('nn_prih').Value) else PrintRep.AddText(underlines);
    PrintRep.Font.Style:=[];
    PrintRep.AddText(' �� ');
    PrintRep.Font.Style:=[fsBold,fsUnderline];
    if not ADOQuery1.FieldByName('dt_prih').IsNull then PrintRep.AddText(FormatDateTime('DD.MM.YYYY',ADOQuery1.FieldByName('dt_prih').Value)+#10) else PrintRep.AddText(underlines+#10);
    PrintRep.AddText(#10);

    //������ �������� ���������� (�������)
    if (assigned(ViewNaklF))and(ViewNaklF.Showing) then
      ReturnList(ViewNaklF,ADOQuery1);
    Rec_Count:=ADOQuery1.RecordCount+1;
    PrintRep.Font.Style:=[];
    PrintRep.Align:=AL_CENTER;
    PrintRep.AddTable(4,Rec_Count);
    PrintRep.Font.Size:=4;
    Tb:=PrintRep.LastTable;
    Tb.SetWidths('1000,1500,700,500');
    Tb.SetBorders(1,1,4,1,Border(clBlack,4,psInsideFrame));
    Tb.Cell[1,1].AddText('� ��������� ��������');
    Tb.Cell[2,1].AddText('������������ ���������');
    Tb.Cell[3,1].AddText('����');
    Tb.Cell[4,1].AddText('����� ����������');
    Tb.SetBorders(1,2,4,Rec_Count,DEFAULT_BORDER);
    Tb.SetBorders(1,1,4,1,Border(clBlack,4,psInsideFrame));

    kol_return:=0;
    rec_no:=2;
    ADOQuery1.First;
    while not ADOQuery1.Eof do
    begin //nn_prih, dt_prih numseriya,SrokGodn
      if not ADOQuery1.FieldByName('nn_prih').IsNull then Tb.Cell[1,rec_no].AddText(ADOQuery1.FieldByName('nn_prih').Value);
      if not ADOQuery1.FieldByName('dt_prih').IsNull then Tb.Cell[1,rec_no].AddText(' �� '+FormatDateTime('DD.MM.YYYY',ADOQuery1.FieldByName('dt_prih').Value));
      Tb.Cell[2,rec_no].AddText(ADOQuery1.FieldByName('names').Value);
      if not ADOQuery1.FieldByName('numseriya').IsNull then Tb.Cell[3,rec_no].AddText(ADOQuery1.FieldByName('numseriya').Value);
      if not ADOQuery1.FieldByName('SrokGodn').IsNull then Tb.Cell[4,rec_no].AddText(FormatDateTime('DD.MM.YYYY',ADOQuery1.FieldByName('SrokGodn').Value));
      kol_return:=kol_return+ADOQuery1.FieldByName('kol').Value/ADOQuery1.FieldByName('koef').Value;
      inc(rec_no);
      ADOQuery1.Next;
    end;

    PrintRep.Font.Style:=[];
    PrintRep.Align:=AL_LEFT;
    PrintRep.AddText(#10+' �� ������� ����������� ���������� ����� �������� � ');
    PrintRep.Font.Style:=[fsBold,fsUnderline];
    PrintRep.AddText(ADOQuery1.FieldByName('nn_nakl').Value+' (� ��������) ');
    PrintRep.Font.Style:=[];
    PrintRep.AddText(' �� ');
    PrintRep.Font.Style:=[fsBold,fsUnderline];
    PrintRep.AddText(underlines);
    PrintRep.Font.Style:=[];
    PrintRep.AddText(' (���� ��������) ');
    PrintRep.AddText(' ���������� ��� �������� ���������� �� ������� ��������, �� �������� ���������� �� �������� �� �������� �� � ���������� ��� ��������� ������������.'+#10);
    PrintRep.AddText('��������� ��������� �������� � ������� ');
    PrintRep.Font.Style:=[fsBold,fsItalic];
//    PrintRep.AddText(FloatToStr(StrToFloat(FloatToStrF(kol_return,10,3)))+' ('+FloatToWordsUA(kol_return,10,3)+') '+#10+#10+#10);
    PrintRep.AddText( FloatToStrF( kol_return,10,3 ) + ' (' + FloatToWordsUA( kol_return, 10, 3)+') '+#10+#10+#10 );

    PrintRep.Font.Style:=[];
    PrintRep.Align:=AL_CENTER;
    PrintRep.AddTable(3,1);
    Tb:=PrintRep.LastTable;
    Tb.SetWidths('750,1500,750');
    Tb.SetBorders(1,1,3,1,EMPTY_BORDER);

    Tb.Cell[1,1].Font.Size:=4;
    Tb.Cell[1,1].AddText(underlines+#10);
    Tb.Cell[1,1].Font.Size:=3;
    Tb.Cell[1,1].AddText('(����)');

    Tb.Cell[2,1].Font.Size:=4;
    Tb.Cell[2,1].AddText(underlines+#10);
    Tb.Cell[2,1].Font.Size:=3;
    Tb.Cell[2,1].AddText('(�.�.�)');

    Tb.Cell[3,1].Font.Size:=4;
    Tb.Cell[3,1].AddText(underlines+#10);
    Tb.Cell[3,1].Font.Size:=3;
    Tb.Cell[3,1].AddText('(�����)'+#10);
    Tb.Cell[3,1].Align:=AL_RIGHT;
    Tb.Cell[3,1].Font.Size:=4;
    Tb.Cell[3,1].AddText('̳��� �������');

    PrintRep.PreView;
  except
    on E:Exception do MainF.MessBox('������ ������������ �������� ����� ���������: '+E.Message);
  end;
end;

procedure TViewNaklF.FormActivate(Sender: TObject);
begin
  rbPr.Checked:=true;
  rbVz.Checked:=false;
  BitBtn11.Enabled:=true;
  BitBtn12.Enabled:=false;
  BitBtn13.Enabled:=false;
  BitBtn15.Enabled:=false;
  BitBtn14.Enabled:=false;
  lblPostavschik.Caption:='';
  lblNaklNomber.Caption:='';
  lblNaklDate.Caption:='';

  if rbPr.Checked then
    CheckBox4.Caption:='��������� �� ����������'
  else
    if rbVz.Checked then
      CheckBox4.Caption:='��������� � ����������';

    if DM.spY_NaklList.RecordCount<=0 then BitBtn11.Enabled:=false;

  CheckBox4Click(sender);
end;

procedure TViewNaklF.NaklAfterScroll(DataSet: TDataSet);
begin
  if (Assigned(ViewNaklF))and(ViewNaklF.Showing) then
  begin
    if (assigned(ViewNaklF))and(ViewNaklF.Showing) then
      ReturnList(ViewNaklF,ADOQuery1);
    if not ADOQuery1.FieldByName('descr').IsNull then lblPostavschik.Caption:=ADOQuery1.FieldByName('descr').Value else lblPostavschik.Caption:='';
    if not ADOQuery1.FieldByName('nn_prih').IsNull then lblNaklNomber.Caption:=ADOQuery1.FieldByName('nn_prih').Value else lblNaklNomber.Caption:='';
    if not ADOQuery1.FieldByName('dt_prih').IsNull then lblNaklDate.Caption:=ADOQuery1.FieldByName('dt_prih').Value else lblNaklDate.Caption:='';

    if not ADOQuery1.FieldByName('id_postav').IsNull then BitBtn11.Enabled:=true else BitBtn11.Enabled:=false;

    if rbVz.Checked then
      if DM.spY_NaklList.FieldByName('priznakI').AsInteger=27 then
      begin
        BitBtn12.Enabled:=true;
        BitBtn13.Enabled:=true;
        BitBtn15.Enabled:=true;
        BitBtn14.Enabled:=true;
      end
      else
      begin
        BitBtn12.Enabled:=false;
        BitBtn13.Enabled:=false;
        BitBtn15.Enabled:=false;
        BitBtn14.Enabled:=false;
      end;
  end;
end;

procedure TViewNaklF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DM.spY_NaklList.AfterScroll:=sp_Temp.AfterScroll;
  sp_Temp.Free;
end;

procedure TViewNaklF.N5Click(Sender: TObject);
begin
  if Not MainF.CheckPassword('0523574825') then Exit;
  if DM.qrShowNakl.IsEmpty then Exit;
  ListBackPartF:=TListBackPartF.Create(Self);
  try
    ListBackPartF.ShowModal;
    if ListBackPartF.Flag=1 then BitBtn5Click(BitBtn5);
  finally
    ListBackPartF.Free;
  end;
end;

procedure TViewNaklF.BitBtn13Click(Sender: TObject);
{
  type
    TReturn = set of Byte;
    ttmp = record
      vis_f: boolean;
      col: integer;
      flds: TReturn;
    end;
  var
    Tb: TTableObj;
    cols: array [0..6] of ttmp;
    code_name: integer;
    rec_count: integer;  //���������� ����� � �������
    row_count: integer;  //���������� ������� � �������
    i, j: integer;
    row_no: integer; //����� ������ � ������� ��������
    f_brak, f_nedovoz, f_tovar: boolean;
    kol_return: string;//���������� ������ ������ ������������ � �������� ��� ����������� � ��������������� ������� ������� �������� ������� ���������
    sum_nedovoz, sum_brak, sum_srok, sum_nezakaz, sum_seria, sum_instrukcia, sum_farminspekcia: double; //����� �������� ��� ���
    sum: array [0..6] of double; //������ �������� ��� ������ �����, ���.
    kol_nedovoz, kol_brak, kol_srok, kol_nezakaz, kol_seria, kol_instrukcia, kol_farminspekcia: double;  //���������� ��������
    kol: array [0..6] of double; //������ �������� ��� ������ �����, ��.
    sum_nedovoz_nds, sum_brak_nds, sum_srok_nds, sum_nezakaz_nds, sum_seria_nds, sum_instrukcia_nds, sum_farminspekcia_nds: double;  //����� ��� � ��������
    sum_nds: array [0..6] of double; //������ �������� ��� ������ ����� � ���, ���.
    f_nds: double;
    sum_all, kol_all: double;
    iddoc: integer;
    sum_prih_all, sum_prih_all_nds: double;
    vz_deskr: string;
  const
    white_spaces='               ';
    underlines = '_____________________';
    header: array[0..15] of string = ('� �/�','������','������������ ������','��.','�����','���� (���.)','���������� �� ���������','����������� ���������� ��������� ������','�������','����','����� �� �������','����������','�������������','�����','���� ��������','����������');
    garanie = '����������, ��� ��� ������������� ��������, ��������� � ���� ���������, �� ���������� ����� ������� ���������� � ������ ��������� � ������������ � ��������� ��������, ������������� ��������������.';
}
begin
{
    //������� = 9, 10, 26
    //���� = 3
    //����� �� ������� = 21, 30
    //���������� = 28
    //������������� = 5
    //����� = 29
    //���� �������� = 4
  //�������� �������� �� ��������
  //cols[0].flds:=[9, 10, 26];
  cols[0].flds:=[26];
  cols[1].flds:=[3];
  //cols[2].flds:=[21, 30];
  cols[2].flds:=[30];
  cols[3].flds:=[28];
  cols[4].flds:=[5];
  cols[5].flds:=[29];
  cols[6].flds:=[4];

  //������������� ����� ����� � ���������� ���������
  sum_nedovoz:=0; sum_brak:=0; sum_srok:=0; sum_nezakaz:=0; sum_seria:=0; sum_instrukcia:=0; sum_farminspekcia:=0;
  kol_nedovoz:=0; kol_brak:=0; kol_srok:=0; kol_nezakaz:=0; kol_seria:=0; kol_instrukcia:=0; kol_farminspekcia:=0;
  sum_nedovoz_nds:=0; sum_brak_nds:=0; sum_srok_nds:=0; sum_nezakaz_nds:=0; sum_seria_nds:=0; sum_instrukcia_nds:=0; sum_farminspekcia_nds:=0;
  //������������� ������ ����� � ���������� ��������
  for i:=0 to 6 do
  begin
    sum[i]:=0;
    kol[i]:=0;
    sum_nds[i]:=0;
  end;
  sum_all:=0;
  kol_all:=0;

  try
    PrintRep.Clear;
    PrintRep.SetDefault;
    PrintRep.Font.Name:='Arial'; PrintRep.Font.Size:=4; PrintRep.Font.Style:=[];
    PrintRep.PageSize:=PF_A4; PrintRep.Orientation:=O_PORTR; PrintRep.Align:=AL_CENTER;

    PrintRep.Font.Style:=[fsBold]; PrintRep.AddText('���'+#10);
    PrintRep.AddText('�������������� ������������ ������'+#10);

    PrintRep.AddTable(2,1);
    Tb:=PrintRep.LastTable;
    Tb.SetBorders(1,1,2,1,EMPTY_BORDER);
    Tb.Cell[1,1].Font.Style:=[]; Tb.Cell[1,1].Align:=AL_LEFT; Tb.Cell[1,1].AddText(#10+'�.�������');
    Tb.Cell[2,1].Font.Style:=[]; Tb.Cell[2,1].Align:=AL_RIGHT; Tb.Cell[2,1].AddText(FormatDateTime('DD MMMM YYYY',int(date()))+#10+#10);
    PrintRep.Align:=AL_CENTER; PrintRep.Font.Style:=[fsBold]; PrintRep.AddText(Prm.FirmNameRU+#10+#10);

    if (assigned(ViewNaklF))and(ViewNaklF.Showing) then
      ReturnList(ViewNaklF,ADOQuery1);
    ADOQuery1.First;

    PrintRep.Align:=AL_JUST;
    PrintRep.Font.Style:=[];
    PrintRep.AddText('�� ����� ������ �������-������������ ��������� �� ��������� � ');
    PrintRep.Font.Style:=[fsUnderline,fsBold];
    if not ADOQuery1.FieldByName('nn_prih').IsNull then PrintRep.AddText(' '+ADOQuery1.FieldByName('nn_prih').Value+' ') else PrintRep.AddText(white_spaces);
    PrintRep.Font.Style:=[];
    PrintRep.AddText(' �� ');
    PrintRep.Font.Style:=[fsUnderline,fsBold];
    if not ADOQuery1.FieldByName('dt_prih').IsNull then PrintRep.AddText(' '+FormatDateTime('DD.MM.YYYY',ADOQuery1.FieldByName('dt_prih').Value)+' ') else PrintRep.AddText(white_spaces);
    PrintRep.Font.Style:=[];
    PrintRep.AddText(' ����������� �������������� ������������ ������ � ������� ���������������� ���������� �� ���������� � ��������:'+#10+#10);

    //������ ������ ������� � ��������
    rec_count:=0;  //���������� �����
    row_count:=0;  //���������� �������
    ADOQuery1.First;

    //������������� ��������� �������� � ������� ��������
    with ADOQuery2 do
    begin
      SQL.Clear;
      SQL.Add('declare @iddoc int set @iddoc = :iddoc');
      SQL.Add('select distinct pr_vz_post from rtovar (nolock) where iddoc=@iddoc');
      Parameters.Clear;
      Parameters.CreateParameter('iddoc',ftInteger,pdInput,10,ADOQuery1.FieldByName('iddoc').Value);
      Open;
      First;
    end;
    f_brak:=false;
    f_nedovoz:=false;
    f_tovar:=false;
    while not ADOQuery2.Eof do
    begin //'�������','����','����� �� �������','����������','�������������','�����','���� ��������'
      if ADOQuery2.FieldByName('pr_vz_post').Value=26 then //�������
        if not f_nedovoz then
        begin
          f_nedovoz:=true;
          row_count:=row_count+1;
        end;
      if (ADOQuery2.FieldByName('pr_vz_post').Value=3) then //����
      begin
        row_count:=row_count+2;
        f_brak:=true;
      end;
      if (ADOQuery2.FieldByName('pr_vz_post').Value=4) then row_count:=row_count+1; //���� ��������
      if ADOQuery2.FieldByName('pr_vz_post').Value=30 then //����� �� �������
        if not f_tovar then
        begin
          f_tovar:=true;
          row_count:=row_count+1;
        end;
      if ADOQuery2.FieldByName('pr_vz_post').Value=29 then row_count:=row_count+1; //�����
      if ADOQuery2.FieldByName('pr_vz_post').Value=28 then row_count:=row_count+1; //����������
      if ADOQuery2.FieldByName('pr_vz_post').Value=5 then row_count:=row_count+1; //�������������
      ADOQuery2.Next;
    end;

    //����������� ������� ������� ��������� ��� ����������
    row_count:=row_count+8;
    rec_count:=ADOQuery1.RecordCount+5;
    PrintRep.AddTable(row_count,rec_count);
    Tb:=PrintRep.LastTable;
    Tb.SetBorders(1,1,row_count,1,Border(clBlack,4,psInsideFrame));
    Tb.SetBorders(1,rec_count-3,row_count,rec_count,EMPTY_BORDER);
    Tb.SetBorders(1,rec_count-4,row_count,rec_count-4,DEFAULT_BORDER);
    for i:=1 to row_count do
    begin
      Tb.Cell[i,1].Font.Style:=[fsBold];
      Tb.Cell[i,1].Align:=AL_CENTER;
    end;
    case row_count of
                        //� �/� ������  ������������ ��. ����� ����   ���������� ����������� ������� ���� �����   ���������� ������������� ����� ����     ����������'
                        //              ������                 (���.) ��         ����������               ��                                     ��������
                        //                                            ���������  ���������                �������
                        //                                                       ������
       8:   Tb.SetWidths('250,  250,    1000,        250,250,  250,   250,       250');
       9:   Tb.SetWidths('250,  250,    1000,        250,250,  250,   250,       250,        250');
      10: if f_brak then
            Tb.SetWidths('250,  250,    1000,        250,250,  250,   250,       250,        250,    500')
          else
            Tb.SetWidths('250,  250,    1000,        250,250,  250,   250,       250,        250,    250');
      11: if f_brak then
            Tb.SetWidths('250,  250,    1000,        250,250,  250,   250,       250,        250,    250, 500')
          else
            Tb.SetWidths('250,  250,    1000,        250,250,  250,   250,       250,        250,    250, 250');
      12: if f_brak then
            Tb.SetWidths('250,  250,    1000,        250,250,  250,   250,       250,        250,    250, 250,    500')
          else
            Tb.SetWidths('250,  250,    1000,        250,250,  250,   250,       250,        250,    250, 250,    250');
      13: if f_brak then
            Tb.SetWidths('250,  250,    1000,        250,250,  250,   250,       250,        250,    250, 250,    250,       500')
          else
            Tb.SetWidths('250,  250,    1000,        250,250,  250,   250,       250,        250,    250, 250,    250,       250');
      14: if f_brak then
            Tb.SetWidths('250,  250,    1000,        250,250,  250,   250,       250,        250,    250, 250,    250,       250,          500')
          else
            Tb.SetWidths('250,  250,    1000,        250,250,  250,   250,       250,        250,    250, 250,    250,       250,          250');
      15: if f_brak then
            Tb.SetWidths('250,  250,    1000,        250,250,  250,   250,       250,        250,    250, 250,    250,       250,          250,  500')
          else
            Tb.SetWidths('250,  250,    1000,        250,250,  250,   250,       250,        250,    250, 250,    250,       250,          250,  250');
      16: if f_brak then
            Tb.SetWidths('250,  250,    1000,        250,250,  250,   250,       250,        250,    250, 250,    250,       250,          250,  250,     500')
          else
            Tb.SetWidths('250,  250,    1000,        250,250,  250,   250,       250,        250,    250, 250,    250,       250,          250,  250,     250');
    end;
    for i:=0 to 7 do
    begin
      Tb.Cell[i+1,1].AddText(header[i]+#10);
      cols[i].vis_f:=false;
    end;

    //���������� ����� ������� ���������
    with ADOQuery2 do
    begin
      SQL.Clear;
      SQL.Add('declare @iddoc int set @iddoc = :iddoc');
      SQL.Add('select');
      SQL.Add('  r.iddoc,r.pr_vz_post,v.id,v.descr');
      SQL.Add('from');
      SQL.Add('  rtovar r (nolock)');
      SQL.Add('  left join sprprvozr v (nolock) on v.id = r.pr_vz_post and v.vis_vz_post=1');
      SQL.Add('where ');
      SQL.Add('  r.iddoc=@iddoc');
      Parameters.Clear;
      Parameters.CreateParameter('iddoc',ftInteger,pdInput,10,ADOQuery1.FieldByName('iddoc').Value);
      Open;
      First;
    end;
    while not ADOQuery2.Eof do
    begin     //'�������','����','����� �� �������','����������','�������������','�����','���� ��������'
      if ADOQuery2.FieldByName('pr_vz_post').Value=26 then cols[0].vis_f:=true; //�������
      if ADOQuery2.FieldByName('pr_vz_post').Value=3 then cols[1].vis_f:=true; //����
      if ADOQuery2.FieldByName('pr_vz_post').Value=30 then cols[2].vis_f:=true; //����� �� �������
      if ADOQuery2.FieldByName('pr_vz_post').Value=28 then cols[3].vis_f:=true; //����������
      if ADOQuery2.FieldByName('pr_vz_post').Value=5 then cols[4].vis_f:=true; //�������������
      if ADOQuery2.FieldByName('pr_vz_post').Value=29 then cols[5].vis_f:=true; //�����
      if ADOQuery2.FieldByName('pr_vz_post').Value=4 then cols[6].vis_f:=true; //���� ��������
      ADOQuery2.Next;
    end;

    j:=9; //'�������','����','����� �� �������','����������','�������������','�����','���� ��������'
    i:=0;
    repeat
      if cols[i].vis_f then
      begin
        cols[i].col:=j;
        Tb.Cell[j,1].AddText(header[j-1]);
        inc(j);
      end;
      inc(i);
    until i=7;

    if f_brak then Tb.Cell[row_count,1].AddText(header[15]);

    //������ ������ � ��������
    row_no:=2;
    ADOQuery1.First;
    while not ADOQuery1.Eof do
    begin
      vz_deskr:='';
      Tb.Cell[1,row_no].Align:=AL_CENTER; Tb.Cell[1,row_no].AddText(IntToStr(row_no-1)); //� �/�
      Tb.Cell[2,row_no].Align:=AL_CENTER; Tb.Cell[2,row_no].AddText(ADOQuery1.FieldByName('art_code').Value); //������
      Tb.Cell[3,row_no].Align:=AL_CENTER; Tb.Cell[3,row_no].AddText(ADOQuery1.FieldByName('names').Value); //������������ ������
      Tb.Cell[4,row_no].Align:=AL_CENTER; Tb.Cell[4,row_no].AddText('����.'); //������� ���������
      Tb.Cell[5,row_no].Align:=AL_CENTER; if not ADOQuery1.FieldByName('numseriya').IsNull then Tb.Cell[5,row_no].AddText(ADOQuery1.FieldByName('numseriya').Value); //�����
      Tb.Cell[6,row_no].Align:=AL_CENTER; Tb.Cell[6,row_no].AddText( CurrToStr( RoundCurr(ADOQuery1.FieldByName('cenazakup').Value * ADOQuery1.FieldByName('koef').Value) )); //���� (���.)
//      Tb.Cell[6,row_no].Align:=AL_CENTER; Tb.Cell[6,row_no].AddText( CurrToStr( RoundCurr(ADOQuery1.FieldByName('cenazakup').Value / ADOQuery1.FieldByName('koef').Value) )); //���� (���.)
//      Tb.Cell[6,row_no].Align:=AL_CENTER; Tb.Cell[6,row_no].AddText( CurrToStr( RoundCurr(ADOQuery1.FieldByName('cena').Value / ADOQuery1.FieldByName('koef').Value) )); //���� (���.)


      //���������� �� ���������
      IncomingNakl;


      Tb.Cell[7,row_no].Align:=AL_CENTER; Tb.Cell[7,row_no].AddText( FloatToStr(StrToFloat(FloatToStrF( ADOQuery2.FieldByName('kol').Value / ADOQuery1.FieldByName('koef').Value,10,3 ))));
      //����������� ���������� ��������� ������
      Tb.Cell[8,row_no].Align:=AL_CENTER; Tb.Cell[8,row_no].AddText(FloatToStr(StrToFloat(FloatToStrF(ADOQuery2.FieldByName('kol').Value/ADOQuery1.FieldByName('koef').Value-ADOQuery1.FieldByName('kol').Value/ADOQuery1.FieldByName('koef').Value,10,3))));
//      Tb.Cell[8,row_no].Align:=AL_CENTER; Tb.Cell[8,row_no].AddText(FloatToStr(StrToFloat(FloatToStrF((ADOQuery2.FieldByName('kol').Value  - ADOQuery1.FieldByName('kol').Value) / ADOQuery1.FieldByName('koef').Value,10,3))));
//      Tb.Cell[8,row_no].Align:=AL_CENTER; Tb.Cell[8,row_no].AddText(FloatToStr(StrToFloat(FloatToStrF((ADOQuery2.FieldByName('kol').Value  - ADOQuery1.FieldByName('kol').Value) / ADOQuery1.FieldByName('koef').Value,10,3))));
//      Tb.Cell[8,row_no].Align:=AL_CENTER; Tb.Cell[8,row_no].AddText(FloatToStr(StrToFloat(FloatToStrF((ADOQuery2.FieldByName('kol').Value-ADOQuery1.FieldByName('kol').Value)/ADOQuery1.FieldByName('koef').Value,10,3))));

      //������� ��� ���� ��� ����� �� ������� ��� ���������� ��� ������������� ��� ����� ��� ���� ��������
      kol_return:=FloatToStr(StrToFloat(FloatToStrF(ADOQuery1.FieldByName('kol').Value/ADOQuery1.FieldByName('koef').Value,10,3)));
      if not ADOQuery1.FieldByName('VzDescr').IsNull then vz_deskr:=ADOQuery1.FieldByName('VzDescr').Value;
      for i:=8 to row_count do Tb.Cell[i,row_no].Align:=AL_CENTER;

      f_nds:=0;
      i:=0;
      repeat
//        case ADOQuery1.FieldByName('f_nds').Value of
//          1: f_nds:=0.2;
//          2: f_nds:=0.07;
//        end;
        case ADOQuery1.FieldByName('f_nds').Value of
          1: f_nds:=0.2;
          2: f_nds:=0.07;
        end;

        if ADOQuery1.FieldByName('pr_vz_post').AsInteger in [26] then
        begin
          if cols[i].flds=[26] then //�������
          begin
            Tb.Cell[cols[i].col,row_no].AddText(kol_return);
            kol_nedovoz:=kol_nedovoz+(ADOQuery1.FieldByName('kol').Value/ADOQuery1.FieldByName('koef').Value);
            sum_nedovoz:=sum_nedovoz+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cenazakup').Value);
//            sum_nedovoz:=sum_nedovoz+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cenazakup').Value*(1-f_nds));
//            sum_nedovoz:=sum_nedovoz+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cena').Value*(1-f_nds));
            sum_nedovoz_nds:=sum_nedovoz_nds+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cenazakup').Value*f_nds);
//            sum_nedovoz_nds:=sum_nedovoz_nds+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cena').Value*f_nds);
//            inc(i);
//            break;
          end;
        end
        else
          if ADOQuery1.FieldByName('pr_vz_post').AsInteger in [3] then //����
          begin
            if cols[i].flds=[3] then
            begin
              Tb.Cell[cols[i].col,row_no].AddText(kol_return);
              if Length(Trim(vz_deskr))>=0 then Tb.Cell[row_count,row_no].AddText(vz_deskr);
//              if not ADOQuery1.FieldByName('VzDescr').IsNull then Tb.Cell[row_count,row_no].AddText(ADOQuery1.FieldByName('VzDescr').Value);
              kol_brak:=kol_brak+(ADOQuery1.FieldByName('kol').Value/ADOQuery1.FieldByName('koef').Value);
              sum_brak:=sum_brak+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cenazakup').Value);
//              sum_brak:=sum_brak+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cenazakup').Value*(1-f_nds));
//              sum_brak:=sum_brak+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cena').Value*(1-f_nds));
              sum_brak_nds:=sum_brak_nds+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cenazakup').Value*f_nds);
//              sum_brak_nds:=sum_brak_nds+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cena').Value*f_nds);
//              inc(i);
//              break;
            end;
          end
          else
            if ADOQuery1.FieldByName('pr_vz_post').AsInteger in [30] then //����� �� �������
            begin
              if cols[i].flds=[30] then
              begin
                Tb.Cell[cols[i].col,row_no].AddText(kol_return);
                kol_nezakaz:=kol_nezakaz+(ADOQuery1.FieldByName('kol').Value/ADOQuery1.FieldByName('koef').Value);
                sum_nezakaz:=sum_nezakaz+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cenazakup').Value);
//                sum_nezakaz:=sum_nezakaz+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cenazakup').Value*(1-f_nds));
//                sum_nezakaz:=sum_nezakaz+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cena').Value*(1-f_nds));
                sum_nezakaz_nds:=sum_nezakaz_nds+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cenazakup').Value*f_nds);
//                sum_nezakaz_nds:=sum_nezakaz_nds+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cena').Value*f_nds);
//                inc(i);
//                break;
              end;
            end
            else
              if ADOQuery1.FieldByName('pr_vz_post').AsInteger in [28] then //����������
              begin
                if cols[i].flds=[28] then
                begin
                  Tb.Cell[cols[i].col,row_no].AddText(kol_return);
                  kol_instrukcia:=kol_instrukcia+(ADOQuery1.FieldByName('kol').Value/ADOQuery1.FieldByName('koef').Value);
                  sum_instrukcia:=sum_instrukcia+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cenazakup').Value);
//                  sum_instrukcia:=sum_instrukcia+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cenazakup').Value*(1-f_nds));
//                  sum_instrukcia:=sum_instrukcia+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cena').Value*(1-f_nds));
                  sum_instrukcia_nds:=sum_instrukcia_nds+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cenazakup').Value*f_nds);
//                  sum_instrukcia_nds:=sum_instrukcia_nds+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cena').Value*f_nds);
//                  inc(i);
//                  break;
                end;
              end
              else
                if ADOQuery1.FieldByName('pr_vz_post').AsInteger in [5] then //�������������
                begin
                  if cols[i].flds=[5] then
                  begin
                    Tb.Cell[cols[i].col,row_no].AddText(kol_return);
                    kol_farminspekcia:=kol_farminspekcia+(ADOQuery1.FieldByName('kol').Value/ADOQuery1.FieldByName('koef').Value);
                    sum_farminspekcia:=sum_farminspekcia+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cenazakup').Value);
//                    sum_farminspekcia:=sum_farminspekcia+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cenazakup').Value*(1-f_nds));
//                    sum_farminspekcia:=sum_farminspekcia+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cena').Value*(1-f_nds));
                    sum_farminspekcia_nds:=sum_farminspekcia_nds+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cenazakup').Value*f_nds);
//                    sum_farminspekcia_nds:=sum_farminspekcia_nds+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cena').Value*f_nds);
//                    inc(i);
//                    break;
                  end;
                end
                else
                  if ADOQuery1.FieldByName('pr_vz_post').AsInteger in [29] then //�����
                  begin
                    if cols[i].flds=[29] then
                    begin
                      Tb.Cell[cols[i].col,row_no].AddText(kol_return);
                      kol_seria:=kol_seria+(ADOQuery1.FieldByName('kol').Value/ADOQuery1.FieldByName('koef').Value);
                      sum_seria:=sum_seria+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cenazakup').Value);
//                      sum_seria:=sum_seria+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cenazakup').Value*(1-f_nds));
//                      sum_seria:=sum_seria+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cena').Value*(1-f_nds));
                      sum_seria_nds:=sum_seria_nds+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cenazakup').Value*f_nds);
//                      sum_seria_nds:=sum_seria_nds+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cena').Value*f_nds);
//                      inc(i);
//                      break;
                    end;
                  end
                  else
                    if ADOQuery1.FieldByName('pr_vz_post').AsInteger in [4] then //���� ��������
                    begin
                      if cols[i].flds=[4] then
                      begin
                        Tb.Cell[cols[i].col,row_no].AddText(kol_return);
                        kol_srok:=kol_srok+(ADOQuery1.FieldByName('kol').Value/ADOQuery1.FieldByName('koef').Value);
                        sum_srok:=sum_srok+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cenazakup').Value);
//                        sum_srok:=sum_srok+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cenazakup').Value*(1-f_nds));
//                        sum_srok:=sum_srok+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cena').Value*(1-f_nds));
                        sum_srok_nds:=sum_srok_nds+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cenazakup').Value*f_nds);
//                        sum_srok_nds:=sum_srok_nds+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cena').Value*f_nds);
//                        inc(i);
//                        break;
                      end;
//                    end
//                    else
//                    begin
//                      inc(i);
//                      Break;
                    end;
        inc(i);
      until i=7;

      row_no:=row_no+1;
      ADOQuery1.Next;
    end;

    //���������� �������� ��� ������ ��������� ���������� �� ��������
    //����� �������� ��� ���
    sum[0]:=sum_nedovoz; sum[1]:=sum_brak; sum[2]:=sum_nezakaz; sum[3]:=sum_instrukcia; sum[4]:=sum_farminspekcia; sum[5]:=sum_seria; sum[6]:=sum_srok;
    //���������� ��������
    kol[0]:=kol_nedovoz; kol[1]:=kol_brak; kol[2]:=kol_nezakaz; kol[3]:=kol_instrukcia; kol[4]:=kol_farminspekcia; kol[5]:=kol_seria; kol[6]:=kol_srok;
    //����� ��� � ��������
    sum_nds[0]:=sum_nedovoz_nds; sum_nds[1]:=sum_brak_nds; sum_nds[2]:=sum_nezakaz_nds; sum_nds[3]:=sum_instrukcia_nds; sum_nds[4]:=sum_farminspekcia_nds; sum_nds[5]:=sum_seria_nds; sum_nds[6]:=sum_srok_nds;

    for i:=rec_count-3 to rec_count do
    begin
      Tb.MergeCells(1,i,8,i);
      Tb.Cell[1,i].Align:=AL_RIGHT;
    end;
    Tb.Cell[1,rec_count-3].AddText('�����, ��.');
    Tb.Cell[1,rec_count-2].AddText('�����, ���.');
    Tb.Cell[1,rec_count-1].AddText('���, ���.');
    Tb.Cell[1,rec_count].AddText('����� � ���, ���.');
    Tb.SetBorders(9,rec_count-4,row_count,rec_count,DEFAULT_BORDER);

    //'�������','����','����� �� �������','����������','�������������','�����','���� ��������'
    j:=9;
    i:=0;
    repeat
      if cols[i].vis_f then
      begin
        Tb.Cell[j,rec_count-3].Align:=AL_CENTER; Tb.Cell[j,rec_count-3].AddText(FloatToStr(StrToFloat(FloatToStrF(kol[i],10,3)))); //�����, ��.
        Tb.Cell[j,rec_count-2].Align:=AL_RIGHT; Tb.Cell[j,rec_count-2].AddText(CurrToStr(RoundCurr(sum[i]))); //�����, ���.
        Tb.Cell[j,rec_count-1].Align:=AL_RIGHT; Tb.Cell[j,rec_count-1].AddText(CurrToStr(RoundCurr(sum_nds[i]))); //���, ���.
        Tb.Cell[j,rec_count].Align:=AL_RIGHT; Tb.Cell[j,rec_count].AddText(CurrToStr(RoundCurr(sum[i]+sum_nds[i]))); //����� � ���, ���.
        inc(j);
      end;
      sum_all:=sum_all+sum[i]+sum_nds[i];
      kol_all:=kol_all+kol[i];
      inc(i);
    until i=7;
    with PrintRep do
    begin
      Font.Style:=[fsBold];
      AddText(#10+'�����, ��� �������� ���������� ������������� ������, �������� �������������� ������, �������� � ���������, ����� � ���������� ');
      Font.Style:=[fsBold,fsUnderline]; AddText(FloatToStr(StrToFloat(FloatToStrF(kol_all,10,3)))+' ('+FloatToWordsRU(kol_all,10,3)+') ');
      Font.Style:=[fsBold]; AddText(' ��. �� ����� ����� ');
      Font.Style:=[fsBold,fsUnderline]; AddText(CurrToWordsRU(sum_all,0));
      Font.Style:=[]; AddText(#10+#10+'��������������: '+#10+#10);
      AddText('� ���������� ��������� �������������� �� ��������� � ');
      Font.Style:=[fsBold,fsUnderline]; if not ADOQuery1.FieldByName('nn_prih').IsNull then PrintRep.AddText(' '+ADOQuery1.FieldByName('nn_prih').Value+' ') else PrintRep.AddText(white_spaces);
      Font.Style:=[]; AddText(' �� '); Font.Style:=[fsBold,fsUnderline]; if not ADOQuery1.FieldByName('dt_prih').IsNull then PrintRep.AddText(' '+FormatDateTime('DD.MM.YYYY',ADOQuery1.FieldByName('dt_prih').Value)+' ') else PrintRep.AddText(white_spaces);
      Font.Style:=[]; AddText(' ���� �� ����� �������������� ������ �� ��������� ���������� ��� ��� ');

      //���������� � ����� �� ��������� ���������
      IncomingNakl;
      ADOQuery2.First;
      iddoc:=ADOQuery2.FieldByName('iddoc').Value;

//      with ADOQuery2 do
//      begin
//        SQL.Clear;
//        SQL.Add('declare @iddoc int set @iddoc = :iddoc');
//        SQL.Add('select');
//        SQL.Add('  j.iddoc, j.F_NDS, r.KOL, s.CenaZakup as CenaZakup, s.CENA as CENA, p.koef, j.sum_prih');
////        SQL.Add('  j.iddoc, j.F_NDS, r.KOL, r.CenaZakup as Cena, p.koef');
////        SQL.Add('  j.iddoc, j.F_NDS, r.KOL, r.CENA, p.koef');
//        SQL.Add('from');
//        SQL.Add('  jmoves j (nolock)');
//        SQL.Add('  left join rtovar r (nolock) on r.iddoc=j.iddoc');
//        SQL.Add('  inner join sprtov s (nolock) on s.kod_name=r.kod_name');
//        SQL.Add('  left join PList p (nolock) on p.art_code=s.art_code');
//        SQL.Add('where');
//        SQL.Add('  j.type_nakl = 1');
//        SQL.Add('  and j.reoc=0 and j.obl in (0, 1)');
//        SQL.Add('  and not j.id_postav is null');
//        SQL.Add('  and j.iddoc = @iddoc');
//        SQL.Add('order by');
//        SQL.Add('  j.iddoc, j.nn_nakl');
//        Parameters.Clear;
//        Parameters.CreateParameter('iddoc',ftInteger,pdInput,10,iddoc);
//        Open;
//        First;
//      end;
//
//      sum_prih_all:=0; sum_prih_all_nds:=0;
//      while not ADOQuery2.Eof do
//      begin
////        case ADOQuery1.FieldByName('f_nds').Value of
////          1: f_nds:=0.07;
////          2: f_nds:=0.2;
////        end;
//        case ADOQuery1.FieldByName('f_nds').Value of
//          1: f_nds:=0.2;
//          2: f_nds:=0.07;
//        end;
//        sum_prih_all:=sum_prih_all+ADOQuery2.FieldByName('kol').Value*ADOQuery2.FieldByName('cenazakup').Value;
////        sum_prih_all:=sum_prih_all+ADOQuery2.FieldByName('kol').Value*ADOQuery2.FieldByName('cenazakup').Value*(1-f_nds);
////        sum_prih_all:=sum_prih_all+ADOQuery2.FieldByName('kol').Value*ADOQuery2.FieldByName('cena').Value*(1-f_nds);
//        sum_prih_all_nds:=sum_prih_all_nds+ADOQuery2.FieldByName('kol').Value*ADOQuery2.FieldByName('cenazakup').Value*f_nds;
////        sum_prih_all_nds:=sum_prih_all_nds+ADOQuery2.FieldByName('kol').Value*ADOQuery2.FieldByName('cena').Value*f_nds;
//        ADOQuery2.Next;
//      end;

      with ADOQuery2 do
      begin
        SQL.Clear;
        SQL.Add('declare @iddoc int set @iddoc = :iddoc');
        SQL.Add('select ');
        SQL.Add('  top 1 j.sum_prih, j.F_NDS');
        SQL.Add('from');
        SQL.Add('  jmoves j (nolock)');
        SQL.Add('  left join rtovar r (nolock) on r.iddoc=j.iddoc');
        SQL.Add('  inner join sprtov s (nolock) on s.kod_name=r.kod_name');
        SQL.Add('  left join PList p (nolock) on p.art_code=s.art_code');
        SQL.Add('where');
        SQL.Add('  j.type_nakl = 1');
        SQL.Add('  and j.reoc=0 and j.obl in (0, 1)');
        SQL.Add('  and not j.id_postav is null');
        SQL.Add('  and j.iddoc = @iddoc');
        SQL.Add('order by');
        SQL.Add('  j.iddoc, j.nn_nakl');
        Parameters.Clear;
        Parameters.CreateParameter('iddoc',ftInteger,pdInput,10,iddoc);
        Open;
        First;
      end;

      f_nds:=0;
      case ADOQuery2.FieldByName('f_nds').Value of
        1: f_nds:=0.2;
        2: f_nds:=0.07;
      end;

      Font.Style:=[fsBold,fsUnderline];
      if (not ADOQuery2.FieldByName('sum_prih').IsNull)and(f_nds > 0) then AddText(CurrencyToStr(RoundCurr(ADOQuery2.FieldByName('sum_prih').Value / (1+f_nds)))+' ���. ') else AddText(white_spaces);
//      AddText(CurrencyToStr(RoundCurr(sum_prih_all))+' ���. ('+CurrToWordsRU(RoundCurr(sum_prih_all),0)+') ');
      Font.Style:=[];
      AddText(', ��� ');
      Font.Style:=[fsBold,fsUnderline];
      if (not ADOQuery2.FieldByName('sum_prih').IsNull)and(f_nds > 0) then AddText(CurrencyToStr(RoundCurr(ADOQuery2.FieldByName('sum_prih').Value - ADOQuery2.FieldByName('sum_prih').Value / (1+f_nds)))+' ���. ') else AddText(white_spaces);
//      AddText(CurrencyToStr(RoundCurr(sum_prih_all_nds))+'���. ');
      Font.Style:=[];
      AddText(', ����� � ��� ');
      Font.Style:=[fsBold,fsUnderline];
      if not ADOQuery2.FieldByName('sum_prih').IsNull then AddText(CurrencyToStr(RoundCurr(ADOQuery2.FieldByName('sum_prih').Value))+' ���. ('+CurrToWordsRU(RoundCurr(ADOQuery2.FieldByName('sum_prih').Value),0)+').') else AddText(white_spaces);
//      AddText(CurrencyToStr(RoundCurr(sum_prih_all)+RoundCurr(sum_prih_all_nds))+' ���. ('+CurrToWordsRU(RoundCurr(sum_prih_all)+RoundCurr(sum_prih_all_nds),0)+').');
      Font.Style:=[];
      AddText(#10+#10+'��� ������� ��������-���������� '+underlines+' '+underlines+' /���/'+#10+#10);
      AddText('������ �������� ���� ������� ��������-���������� '+underlines+' '+underlines+' /���/'+#10+#10);
      Font.Style:=[fsBold];
      AddText(#10+#10+garanie+#10+#10);
    end;

    PrintRep.AddTable(3,1);
    PrintRep.Font.Style:=[fsBold];
    Tb:=PrintRep.LastTable;
    Tb.SetBorders(1,1,3,1,EMPTY_BORDER);
    Tb.SetWidths('1000,200,1000');
    Tb.Cell[1,1].Font.Style:=[];
    Tb.Cell[2,1].Font.Style:=[];
    Tb.Cell[3,1].Font.Style:=[];

    Tb.Cell[1,1].Font.Size:=4;
    Tb.Cell[1,1].AddText('������������� ���� '+underlines+#10);
    Tb.Cell[1,1].Font.Size:=3;
    Tb.Cell[1,1].AddText('                                                  (�.�.�., �������)'+#10);
    Tb.Cell[1,1].Font.Size:=4;
    Tb.Cell[1,1].AddText(#10+#10);
    Tb.Cell[1,1].AddText('�������� '+underlines+#10);
    Tb.Cell[1,1].Font.Size:=3;
    Tb.Cell[1,1].AddText('                                   (�.�.�., �������)');
    Tb.Cell[1,1].Font.Size:=4;
    Tb.Cell[1,1].Align:=AL_RIGHT;
    Tb.Cell[1,1].AddText(#10+#10+#10+#10+#10+#10+'����� ������');

    Tb.Cell[3,1].AddText('��������� ');
    Tb.Cell[3,1].Font.Style:=[fsBold];
    if not ADOQuery1.FieldByName('descr').IsNull then Tb.Cell[3,1].AddText(' '+ADOQuery1.FieldByName('descr').Value+' '+#10) else Tb.Cell[3,1].AddText(' '+underlines+underlines+' '+#10);
    Tb.Cell[3,1].Font.Style:=[];
    Tb.Cell[3,1].AddText(underlines+underlines+#10);
    Tb.Cell[3,1].AddText(underlines+underlines+#10);
    Tb.Cell[3,1].AddText(underlines+underlines+#10);
    Tb.Cell[3,1].AddText(underlines+underlines+#10);
    Tb.Cell[3,1].AddText(underlines+underlines+#10);
    Tb.Cell[3,1].AddText(underlines+underlines+#10);
    Tb.Cell[3,1].AddText(underlines+underlines+#10);
    Tb.Cell[3,1].AddText(underlines+underlines+#10+#10);
    Tb.Cell[3,1].Align:=AL_RIGHT;
    Tb.Cell[3,1].AddText('����� ������');
    PrintRep.PreView;
  except
    on E:Exception do MainF.MessBox('������ ������������ �������� ����� ���������: '+E.Message);
  end;
}

  PrintActOfNonConformity;
end;

procedure TViewNaklF.PrintActOfNonConformity;
type
  TReturn = set of Byte;
  TReturns = record
    vis_f: boolean;
    col: integer;
    flds: TReturn;
  end;
var
  Tb: TTableObj;
  iddoc: integer;
  f_nds: double;
  rec_count: integer;  //���������� ����� � �������
  col_count: integer;  //���������� ������� � �������
  f_nedovoz, f_brak, f_tovar, f_instruction, f_farminspect, f_serii, f_srok: boolean; //'�������','����','����� �� �������','����������','�������������','�����','���� ��������'
  i, j: integer;
  row_no: integer; //����� ������ � ������� ��������
  column_no: integer; //����� ������� �������
  cols: array [0..6] of TReturns;
  kol_return: string;//���������� ������ ������ ������������ � �������� ��� ����������� � ��������������� ������� ������� �������� ������� ���������
  kol_nedovoz,     kol_brak,     kol_nezakaz,     kol_instrukcia,     kol_farminspekcia,     kol_seria,     kol_srok: double;  //���������� ��������
  sum_nedovoz,     sum_brak,     sum_nezakaz,     sum_instrukcia,     sum_farminspekcia,     sum_seria,     sum_srok: double; //����� �������� ��� ���
  sum_nedovoz_nds, sum_brak_nds, sum_nezakaz_nds, sum_instrukcia_nds, sum_farminspekcia_nds, sum_seria_nds, sum_srok_nds: double;  //����� ��� � ��������
  kol: array [0..6] of double; //������ �������� ��� ������ �����, ��.
  sum: array [0..6] of double; //������ �������� ��� ������ �����, ���.
  sum_nds: array [0..6] of double; //������ �������� ��� ������ ����� � ���, ���.
  vz_deskr: string;
  sum_all, kol_all: double;
const
  FIXED_COLUMN_COUNT = 8;
  FIXED_RECORD_COUNT = 5;
  WHITE_SPACES='               ';
  UNDERLINES = '_____________________';
  GARANTIE = '����������, ��� ��� ������������� ��������, ��������� � ���� ���������, �� ���������� ����� ������� ���������� � ������ ��������� � ������������ � ��������� ��������, ������������� ��������������.';
  TABLE_HEADER: array[0..15] of string = ('� �/�','������','������������ ������','��.','�����','���� (���.)','���������� �� ���������','����������� ���������� ��������� ������','�������','����','����� �� �������','����������','�������������','�����','���� ��������','����������');
begin
  //������� = 26
  //���� = 3
  //����� �� ������� = 30
  //���������� = 28
  //������������� = 5
  //����� = 29
  //���� �������� = 4

  Tb:=nil;

  //������������� ������ ��������� �������
  f_nedovoz:=false; f_brak:=false; f_tovar:=false; f_instruction:=false; f_farminspect:=false; f_serii:=false; f_srok:=false;

  //�������� �������� �� ��������
  for i:=0 to 6 do
  begin
    cols[i].vis_f:=false;
    cols[i].col:=0;
  end;
  cols[0].flds:=[26]; //������� = 26
  cols[1].flds:=[3]; //���� = 3
  cols[2].flds:=[30]; //����� �� ������� = 30
  cols[3].flds:=[28]; //���������� = 28
  cols[4].flds:=[5]; //������������� = 5
  cols[5].flds:=[29]; //����� = 29
  cols[6].flds:=[4]; //���� �������� = 4

  //������������� ����� ����� � ���������� ���������
  kol_nedovoz:=0;     kol_brak:=0;     kol_nezakaz:=0;     kol_instrukcia:=0;     kol_farminspekcia:=0;     kol_seria:=0;     kol_srok:=0;
  sum_nedovoz:=0;     sum_brak:=0;     sum_nezakaz:=0;     sum_instrukcia:=0;     sum_farminspekcia:=0;     sum_seria:=0;     sum_srok:=0;
  sum_nedovoz_nds:=0; sum_brak_nds:=0; sum_nezakaz_nds:=0; sum_instrukcia_nds:=0; sum_farminspekcia_nds:=0; sum_seria_nds:=0; sum_srok_nds:=0;

  //������������� ������ ����� � ���������� ��������
  for i:=0 to 6 do
  begin
    kol[i]:=0;
    sum[i]:=0;
    sum_nds[i]:=0;
  end;
  sum_all:=0;
  kol_all:=0;

  try
    PrintRep.Clear;
    PrintRep.SetDefault;
    PrintRep.Font.Name:='Arial'; PrintRep.Font.Size:=4; PrintRep.Font.Style:=[];
    PrintRep.PageSize:=PF_A4; PrintRep.Orientation:=O_PORTR; PrintRep.Align:=AL_CENTER;

    PrintRep.Font.Style:=[fsBold]; PrintRep.AddText('���'+#10);
    PrintRep.AddText('�������������� ������������ ������'+#10);

    PrintRep.AddTable(2,1);
    Tb:=PrintRep.LastTable;
    Tb.SetBorders(1,1,2,1,EMPTY_BORDER);
    Tb.Cell[1,1].Font.Style:=[]; Tb.Cell[1,1].Align:=AL_LEFT; Tb.Cell[1,1].AddText(#10+'�.�������');
    Tb.Cell[2,1].Font.Style:=[]; Tb.Cell[2,1].Align:=AL_RIGHT; Tb.Cell[2,1].AddText(FormatDateTime('DD MMMM YYYY',int(date()))+#10+#10);
    PrintRep.Align:=AL_CENTER; PrintRep.Font.Style:=[fsBold]; PrintRep.AddText(Prm.FirmNameRU+#10+#10);

    if (assigned(ViewNaklF))and(ViewNaklF.Showing) then
      ReturnList(ViewNaklF,ADOQuery1);
    ADOQuery1.First;

    PrintRep.Align:=AL_JUST;
    PrintRep.Font.Style:=[];
    PrintRep.AddText('�� ����� ������ �������-������������ ��������� �� ��������� � ');
    PrintRep.Font.Style:=[fsUnderline,fsBold];
    if not ADOQuery1.FieldByName('nn_prih').IsNull then PrintRep.AddText(' '+ADOQuery1.FieldByName('nn_prih').Value+' ') else PrintRep.AddText(WHITE_SPACES);
    PrintRep.Font.Style:=[];
    PrintRep.AddText(' �� ');
    PrintRep.Font.Style:=[fsUnderline,fsBold];
    if not ADOQuery1.FieldByName('dt_prih').IsNull then PrintRep.AddText(' '+FormatDateTime('DD.MM.YYYY',ADOQuery1.FieldByName('dt_prih').Value)+' ') else PrintRep.AddText(WHITE_SPACES);
    PrintRep.Font.Style:=[];
    PrintRep.AddText(' ����������� �������������� ������������ ������ � ������� ���������������� ���������� �� ���������� � ��������:'+#10+#10);

    //������ ������ ������� � ��������
    rec_count:=FIXED_RECORD_COUNT;  //���������� �����
    col_count:=FIXED_COLUMN_COUNT;  //���������� �������
    ADOQuery1.Last;
    rec_count:=rec_count+ADOQuery1.RecordCount;

    //������������� ��������� �������� � ������� ��������
    with ADOQuery2 do
    begin
      SQL.Clear;
      SQL.Add('declare @iddoc int set @iddoc = :iddoc');
      SQL.Add('select distinct pr_vz_post from rtovar (nolock) where iddoc=@iddoc');
      Parameters.Clear;
      Parameters.CreateParameter('iddoc',ftInteger,pdInput,10,ADOQuery1.FieldByName('iddoc').Value);
      Open;
      First;
    end;

    while not ADOQuery2.Eof do
    begin //'�������','����','����� �� �������','����������','�������������','�����','���� ��������'
      case ADOQuery2.FieldByName('pr_vz_post').Value of
        26:  // �������
          if not f_nedovoz then
          begin
            f_nedovoz:=true;
            col_count:=col_count+1;
          end;
         3: // ����
          if not f_brak then
          begin
            f_brak:=true;
            col_count:=col_count+2; //���������� �� ����� + ����������
          end;
        30: // ����� �� �������
          if not f_tovar then
          begin
            f_tovar:=true;
            col_count:=col_count+1;
          end;
        28: // ����������
          if not f_instruction then
          begin
            f_instruction:=true;
            col_count:=col_count+1;
          end;
         5: // �������������
          if not f_farminspect then
          begin
            f_farminspect:=true;
            col_count:=col_count+1;
          end;
        29: // �����
          if not f_serii then
          begin
            f_serii:=true;
            col_count:=col_count+1;
          end;
         4: // ���� ��������
          if not f_srok then
          begin
            f_srok:=true;
            col_count:=col_count+1;
          end;
      end;
      ADOQuery2.Next;
    end;

    // ������������� ���������� ����� ��������
    if f_nedovoz then cols[0].vis_f:=true; //�������
    if f_brak then cols[1].vis_f:=true; //���� + ����������
    if f_tovar then cols[2].vis_f:=true; //����� �� �������
    if f_instruction then cols[3].vis_f:=true; //����������
    if f_farminspect then cols[4].vis_f:=true; //�������������
    if f_serii then cols[5].vis_f:=true; //�����
    if f_srok then cols[6].vis_f:=true; //���� ��������
    column_no:=FIXED_COLUMN_COUNT;
    for i:=0 to 6 do
      if cols[i].vis_f then
      begin
        cols[i].col:=column_no+1;
        column_no:=column_no+1;
      end;

    //����������� ������� ������� ��������� ��� ����������
    PrintRep.AddTable(col_count,rec_count);
    Tb:=PrintRep.LastTable;
    Tb.SetBorders(1,1,col_count,1,Border(clBlack,4,psInsideFrame));
    Tb.SetBorders(1,rec_count-3,col_count,rec_count,EMPTY_BORDER);
    Tb.SetBorders(1,rec_count-4,col_count,rec_count-4,DEFAULT_BORDER);
    for i:=1 to col_count do
    begin
      Tb.Cell[i,1].Font.Style:=[fsBold];
      Tb.Cell[i,1].Align:=AL_CENTER;
    end;

    for i:=0 to FIXED_COLUMN_COUNT-1 do Tb.Cell[i+1,1].AddText(TABLE_HEADER[i]+#10);
    for i:=0 to 6 do
      if cols[i].vis_f then Tb.Cell[cols[i].col,1].AddText(TABLE_HEADER[FIXED_COLUMN_COUNT+i]+#10);
    if f_brak then Tb.Cell[col_count,1].AddText(TABLE_HEADER[length(TABLE_HEADER)-1]+#10);

    case col_count of
                        //� �/� ������  ������������ ��. ����� ����   ���������� ����������� ������� ���� �����   ���������� ������������� ����� ����     ����������'
                        //              ������                 (���.) ��         ����������               ��                                     ��������
                        //                                            ���������  ���������                �������
                        //                                                       ������
       9:   Tb.SetWidths('250,  250,    1000,        250,250,  250,   250,       250,        250'); 
      10: if f_brak then
            Tb.SetWidths('250,  250,    1000,        250,250,  250,   250,       250,        250,    500')
          else
            Tb.SetWidths('250,  250,    1000,        250,250,  250,   250,       250,        250,    250');
      11: if f_brak then
            Tb.SetWidths('250,  250,    1000,        250,250,  250,   250,       250,        250,    250, 500')
          else
            Tb.SetWidths('250,  250,    1000,        250,250,  250,   250,       250,        250,    250, 250');
      12: if f_brak then
            Tb.SetWidths('250,  250,    1000,        250,250,  250,   250,       250,        250,    250, 250,    500')
          else
            Tb.SetWidths('250,  250,    1000,        250,250,  250,   250,       250,        250,    250, 250,    250');
      13: if f_brak then
            Tb.SetWidths('250,  250,    1000,        250,250,  250,   250,       250,        250,    250, 250,    250,       500')
          else
            Tb.SetWidths('250,  250,    1000,        250,250,  250,   250,       250,        250,    250, 250,    250,       250');
      14: if f_brak then
            Tb.SetWidths('250,  250,    1000,        250,250,  250,   250,       250,        250,    250, 250,    250,       250,          500')
          else
            Tb.SetWidths('250,  250,    1000,        250,250,  250,   250,       250,        250,    250, 250,    250,       250,          250');
      15: if f_brak then
            Tb.SetWidths('250,  250,    1000,        250,250,  250,   250,       250,        250,    250, 250,    250,       250,          250,  500')
          else
            Tb.SetWidths('250,  250,    1000,        250,250,  250,   250,       250,        250,    250, 250,    250,       250,          250,  250');
      16: if f_brak then
            Tb.SetWidths('250,  250,    1000,        250,250,  250,   250,       250,        250,    250, 250,    250,       250,          250,  250,     500')
          else
            Tb.SetWidths('250,  250,    1000,        250,250,  250,   250,       250,        250,    250, 250,    250,       250,          250,  250,     250');
    end;

    for i:=rec_count-3 to rec_count do
    begin
      Tb.MergeCells(1,i,8,i);
      Tb.Cell[1,i].Align:=AL_RIGHT;
    end;
    Tb.Cell[1,rec_count-3].AddText('�����, ��.');
    Tb.Cell[1,rec_count-2].AddText('�����, ���.');
    Tb.Cell[1,rec_count-1].AddText('���, ���.');
    Tb.Cell[1,rec_count].AddText('����� � ���, ���.');
    Tb.SetBorders(9,rec_count-4,col_count,rec_count,DEFAULT_BORDER);

    //������ ������ � ��������
    row_no:=2;
    ADOQuery1.First;
    while not ADOQuery1.Eof do
    begin
      Tb.Cell[1,row_no].Align:=AL_CENTER; Tb.Cell[1,row_no].AddText(IntToStr(row_no-1)); //� �/�
      Tb.Cell[2,row_no].Align:=AL_CENTER; Tb.Cell[2,row_no].AddText(ADOQuery1.FieldByName('art_code').Value); //������
      Tb.Cell[3,row_no].Align:=AL_CENTER; Tb.Cell[3,row_no].AddText(ADOQuery1.FieldByName('names').Value); //������������ ������
      Tb.Cell[4,row_no].Align:=AL_CENTER; Tb.Cell[4,row_no].AddText('����.'); //������� ���������
      Tb.Cell[5,row_no].Align:=AL_CENTER; if not ADOQuery1.FieldByName('numseriya').IsNull then Tb.Cell[5,row_no].AddText(ADOQuery1.FieldByName('numseriya').Value); //�����
      Tb.Cell[6,row_no].Align:=AL_CENTER; Tb.Cell[6,row_no].AddText( CurrToStr( RoundCurr(ADOQuery1.FieldByName('cenazakup').Value * ADOQuery1.FieldByName('koef').Value) )); //���� (���.)

      vz_deskr:='';
      //���������� �� ���������
      IncomingNakl;
      Tb.Cell[7,row_no].Align:=AL_CENTER; Tb.Cell[7,row_no].AddText( FloatToStr(StrToFloat(FloatToStrF( ADOQuery2.FieldByName('kol').Value / ADOQuery1.FieldByName('koef').Value,10,3 ))));
      //����������� ���������� ��������� ������
      Tb.Cell[8,row_no].Align:=AL_CENTER; Tb.Cell[8,row_no].AddText(FloatToStr(StrToFloat(FloatToStrF(ADOQuery2.FieldByName('kol').Value/ADOQuery1.FieldByName('koef').Value-ADOQuery1.FieldByName('kol').Value/ADOQuery1.FieldByName('koef').Value,10,3))));

      //������� ��� ���� ��� ����� �� ������� ��� ���������� ��� ������������� ��� ����� ��� ���� ��������
      kol_return:=FloatToStr(StrToFloat(FloatToStrF(ADOQuery1.FieldByName('kol').Value/ADOQuery1.FieldByName('koef').Value,10,3)));
      if not ADOQuery1.FieldByName('VzDescr').IsNull then vz_deskr:=ADOQuery1.FieldByName('VzDescr').Value;
      for i:=FIXED_COLUMN_COUNT to col_count do Tb.Cell[i,row_no].Align:=AL_CENTER;

      f_nds:=0;
      i:=0;
      repeat
        case ADOQuery1.FieldByName('f_nds').Value of
          1: f_nds:=0.2;
          2: f_nds:=0.07;
        end;
  
        if ADOQuery1.FieldByName('pr_vz_post').AsInteger in [26] then
        begin
          if cols[i].flds=[26] then //�������
          begin
            Tb.Cell[cols[i].col,row_no].AddText(kol_return);
            kol_nedovoz:=kol_nedovoz+(ADOQuery1.FieldByName('kol').Value/ADOQuery1.FieldByName('koef').Value);
            sum_nedovoz:=sum_nedovoz+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cenazakup').Value);
            sum_nedovoz_nds:=sum_nedovoz_nds+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cenazakup').Value*f_nds);
          end;
        end
        else
          if ADOQuery1.FieldByName('pr_vz_post').AsInteger in [3] then //����
          begin
            if cols[i].flds=[3] then
            begin
              Tb.Cell[cols[i].col,row_no].AddText(kol_return);
              if Length(Trim(vz_deskr))>=0 then Tb.Cell[col_count,row_no].AddText(vz_deskr);
              kol_brak:=kol_brak+(ADOQuery1.FieldByName('kol').Value/ADOQuery1.FieldByName('koef').Value);
              sum_brak:=sum_brak+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cenazakup').Value);
              sum_brak_nds:=sum_brak_nds+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cenazakup').Value*f_nds);
            end;
          end
          else
            if ADOQuery1.FieldByName('pr_vz_post').AsInteger in [30] then //����� �� �������
            begin
              if cols[i].flds=[30] then
              begin
                Tb.Cell[cols[i].col,row_no].AddText(kol_return);
                kol_nezakaz:=kol_nezakaz+(ADOQuery1.FieldByName('kol').Value/ADOQuery1.FieldByName('koef').Value);
                sum_nezakaz:=sum_nezakaz+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cenazakup').Value);
                sum_nezakaz_nds:=sum_nezakaz_nds+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cenazakup').Value*f_nds);
              end;
            end
            else
              if ADOQuery1.FieldByName('pr_vz_post').AsInteger in [28] then //����������
              begin
                if cols[i].flds=[28] then
                begin
                  Tb.Cell[cols[i].col,row_no].AddText(kol_return);
                  kol_instrukcia:=kol_instrukcia+(ADOQuery1.FieldByName('kol').Value/ADOQuery1.FieldByName('koef').Value);
                  sum_instrukcia:=sum_instrukcia+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cenazakup').Value);
                  sum_instrukcia_nds:=sum_instrukcia_nds+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cenazakup').Value*f_nds);
                end;
              end
              else
                if ADOQuery1.FieldByName('pr_vz_post').AsInteger in [5] then //�������������
                begin
                  if cols[i].flds=[5] then
                  begin
                    Tb.Cell[cols[i].col,row_no].AddText(kol_return);
                    kol_farminspekcia:=kol_farminspekcia+(ADOQuery1.FieldByName('kol').Value/ADOQuery1.FieldByName('koef').Value);
                    sum_farminspekcia:=sum_farminspekcia+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cenazakup').Value);
                    sum_farminspekcia_nds:=sum_farminspekcia_nds+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cenazakup').Value*f_nds);
                  end;
                end
                else
                  if ADOQuery1.FieldByName('pr_vz_post').AsInteger in [29] then //�����
                  begin
                    if cols[i].flds=[29] then
                    begin
                      Tb.Cell[cols[i].col,row_no].AddText(kol_return);
                      kol_seria:=kol_seria+(ADOQuery1.FieldByName('kol').Value/ADOQuery1.FieldByName('koef').Value);
                      sum_seria:=sum_seria+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cenazakup').Value);
                      sum_seria_nds:=sum_seria_nds+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cenazakup').Value*f_nds);
                    end;
                  end
                  else
                    if ADOQuery1.FieldByName('pr_vz_post').AsInteger in [4] then //���� ��������
                    begin
                      if cols[i].flds=[4] then
                      begin
                        Tb.Cell[cols[i].col,row_no].AddText(kol_return);
                        kol_srok:=kol_srok+(ADOQuery1.FieldByName('kol').Value/ADOQuery1.FieldByName('koef').Value);
                        sum_srok:=sum_srok+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cenazakup').Value);
                        sum_srok_nds:=sum_srok_nds+(ADOQuery1.FieldByName('kol').Value*ADOQuery1.FieldByName('cenazakup').Value*f_nds);
                      end;
                    end;
        inc(i);
      until i=7;

      row_no:=row_no+1;
      ADOQuery1.Next;
    end;

    //���������� �������� ��� ������ ��������� ���������� �� ��������
    //���������� ��������
    kol[0]:=kol_nedovoz;         kol[1]:=kol_brak;         kol[2]:=kol_nezakaz;         kol[3]:=kol_instrukcia;         kol[4]:=kol_farminspekcia;         kol[5]:=kol_seria;         kol[6]:=kol_srok;
    //����� �������� ��� ���
    sum[0]:=sum_nedovoz;         sum[1]:=sum_brak;         sum[2]:=sum_nezakaz;         sum[3]:=sum_instrukcia;         sum[4]:=sum_farminspekcia;         sum[5]:=sum_seria;         sum[6]:=sum_srok;
    //����� ��� � ��������
    sum_nds[0]:=sum_nedovoz_nds; sum_nds[1]:=sum_brak_nds; sum_nds[2]:=sum_nezakaz_nds; sum_nds[3]:=sum_instrukcia_nds; sum_nds[4]:=sum_farminspekcia_nds; sum_nds[5]:=sum_seria_nds; sum_nds[6]:=sum_srok_nds;

    //'�������','����','����� �� �������','����������','�������������','�����','���� ��������'
    j:=9;
    i:=0;
    repeat
      if cols[i].vis_f then
      begin
        Tb.Cell[j,rec_count-3].Align:=AL_CENTER; Tb.Cell[j,rec_count-3].AddText(FloatToStr(StrToFloat(FloatToStrF(kol[i],10,3)))); //�����, ��.
        Tb.Cell[j,rec_count-2].Align:=AL_RIGHT; Tb.Cell[j,rec_count-2].AddText(CurrToStr(RoundCurr(sum[i]))); //�����, ���.
        Tb.Cell[j,rec_count-1].Align:=AL_RIGHT; Tb.Cell[j,rec_count-1].AddText(CurrToStr(RoundCurr(sum_nds[i]))); //���, ���.
        Tb.Cell[j,rec_count].Align:=AL_RIGHT; Tb.Cell[j,rec_count].AddText(CurrToStr(RoundCurr(sum[i]+sum_nds[i]))); //����� � ���, ���.
        inc(j);
      end;
      sum_all:=sum_all+sum[i]+sum_nds[i];
      kol_all:=kol_all+kol[i];
      inc(i);
    until i=7;

    with PrintRep do
    begin
      Font.Style:=[fsBold];
      AddText(#10+'�����, ��� �������� ���������� ������������� ������, �������� �������������� ������, �������� � ���������, ����� � ���������� ');
      Font.Style:=[fsBold,fsUnderline];
      AddText(FloatToStr(StrToFloat(FloatToStrF(kol_all,10,3)))+' ('+FloatToWordsRU(kol_all,10,3)+') ');
      Font.Style:=[fsBold]; AddText(' ��. �� ����� ����� ');
      Font.Style:=[fsBold,fsUnderline];
      AddText(CurrToWordsRU(sum_all,0));
      Font.Style:=[];
      AddText(#10+#10+'��������������: '+#10+#10);
      AddText('� ���������� ��������� �������������� �� ��������� � ');
      Font.Style:=[fsBold,fsUnderline];
      if not ADOQuery1.FieldByName('nn_prih').IsNull then PrintRep.AddText(' '+ADOQuery1.FieldByName('nn_prih').Value+' ') else PrintRep.AddText(WHITE_SPACES);
      Font.Style:=[];
      AddText(' �� ');
      Font.Style:=[fsBold,fsUnderline];
      if not ADOQuery1.FieldByName('dt_prih').IsNull then PrintRep.AddText(' '+FormatDateTime('DD.MM.YYYY',ADOQuery1.FieldByName('dt_prih').Value)+' ') else PrintRep.AddText(WHITE_SPACES);
      Font.Style:=[];
      AddText(' ���� �� ����� �������������� ������ �� ��������� ���������� ��� ��� ');

      //���������� � ����� �� ��������� ���������
      IncomingNakl;
      ADOQuery2.First;
      iddoc:=ADOQuery2.FieldByName('iddoc').Value;

      with ADOQuery2 do
      begin
        SQL.Clear;
        SQL.Add('declare @iddoc int set @iddoc = :iddoc');
        SQL.Add('select ');
        SQL.Add('  top 1 j.sum_prih, j.F_NDS');
        SQL.Add('from');
        SQL.Add('  jmoves j (nolock)');
        SQL.Add('  left join rtovar r (nolock) on r.iddoc=j.iddoc');
        SQL.Add('  inner join sprtov s (nolock) on s.kod_name=r.kod_name');
        SQL.Add('  left join PList p (nolock) on p.art_code=s.art_code');
        SQL.Add('where');
        SQL.Add('  j.type_nakl = 1');
        SQL.Add('  and j.reoc=0 and j.obl in (0, 1)');
        SQL.Add('  and not j.id_postav is null');
        SQL.Add('  and j.iddoc = @iddoc');
        SQL.Add('order by');
        SQL.Add('  j.iddoc, j.nn_nakl');
        Parameters.Clear;
        Parameters.CreateParameter('iddoc',ftInteger,pdInput,10,iddoc);
        Open;
        First;
      end;

      f_nds:=0;
      case ADOQuery2.FieldByName('f_nds').Value of
        1: f_nds:=0.2;
        2: f_nds:=0.07;
      end;

      Font.Style:=[fsBold,fsUnderline];
      if (not ADOQuery2.FieldByName('sum_prih').IsNull)and(f_nds > 0) then AddText(CurrencyToStr(RoundCurr(ADOQuery2.FieldByName('sum_prih').Value / (1+f_nds)))+' ���. ') else AddText(WHITE_SPACES);
      Font.Style:=[];
      AddText(', ��� ');
      Font.Style:=[fsBold,fsUnderline];
      if (not ADOQuery2.FieldByName('sum_prih').IsNull)and(f_nds > 0) then AddText(CurrencyToStr(RoundCurr(ADOQuery2.FieldByName('sum_prih').Value - ADOQuery2.FieldByName('sum_prih').Value / (1+f_nds)))+' ���. ') else AddText(WHITE_SPACES);
      Font.Style:=[];
      AddText(', ����� � ��� ');
      Font.Style:=[fsBold,fsUnderline];
      if not ADOQuery2.FieldByName('sum_prih').IsNull then AddText(CurrencyToStr(RoundCurr(ADOQuery2.FieldByName('sum_prih').Value))+' ���. ('+CurrToWordsRU(RoundCurr(ADOQuery2.FieldByName('sum_prih').Value),0)+').') else AddText(WHITE_SPACES);
      Font.Style:=[];
      AddText(#10+#10+'��� ������� ��������-���������� '+UNDERLINES+' '+UNDERLINES+' /���/'+#10+#10);
      AddText('������ �������� ���� ������� ��������-���������� '+UNDERLINES+' '+UNDERLINES+' /���/'+#10+#10);
      Font.Style:=[fsBold];
      AddText(#10+#10+GARANTIE+#10+#10);
    end;

    PrintRep.AddTable(3,1);
    PrintRep.Font.Style:=[fsBold];
    Tb:=PrintRep.LastTable;
    Tb.SetBorders(1,1,3,1,EMPTY_BORDER);
    Tb.SetWidths('1000,200,1000');
    Tb.Cell[1,1].Font.Style:=[];
    Tb.Cell[2,1].Font.Style:=[];
    Tb.Cell[3,1].Font.Style:=[];

    Tb.Cell[1,1].Font.Size:=4;
    Tb.Cell[1,1].AddText('������������� ���� '+UNDERLINES+#10);
    Tb.Cell[1,1].Font.Size:=3;
    Tb.Cell[1,1].AddText('                                                  (�.�.�., �������)'+#10);
    Tb.Cell[1,1].Font.Size:=4;
    Tb.Cell[1,1].AddText(#10+#10);
    Tb.Cell[1,1].AddText('�������� '+UNDERLINES+#10);
    Tb.Cell[1,1].Font.Size:=3;
    Tb.Cell[1,1].AddText('                                   (�.�.�., �������)');
    Tb.Cell[1,1].Font.Size:=4;
    Tb.Cell[1,1].Align:=AL_RIGHT;
    Tb.Cell[1,1].AddText(#10+#10+#10+#10+#10+#10+'����� ������');

    Tb.Cell[3,1].AddText('��������� ');
    Tb.Cell[3,1].Font.Style:=[fsBold];
    if not ADOQuery1.FieldByName('descr').IsNull then Tb.Cell[3,1].AddText(' '+ADOQuery1.FieldByName('descr').Value+' '+#10) else Tb.Cell[3,1].AddText(' '+UNDERLINES+UNDERLINES+' '+#10);
    Tb.Cell[3,1].Font.Style:=[];
    Tb.Cell[3,1].AddText(UNDERLINES+UNDERLINES+#10);
    Tb.Cell[3,1].AddText(UNDERLINES+UNDERLINES+#10);
    Tb.Cell[3,1].AddText(UNDERLINES+UNDERLINES+#10);
    Tb.Cell[3,1].AddText(UNDERLINES+UNDERLINES+#10);
    Tb.Cell[3,1].AddText(UNDERLINES+UNDERLINES+#10);
    Tb.Cell[3,1].AddText(UNDERLINES+UNDERLINES+#10);
    Tb.Cell[3,1].AddText(UNDERLINES+UNDERLINES+#10);
    Tb.Cell[3,1].AddText(UNDERLINES+UNDERLINES+#10+#10);
    Tb.Cell[3,1].Align:=AL_RIGHT;
    Tb.Cell[3,1].AddText('����� ������');

    PrintRep.PreView;
  except
    on E:Exception do MainF.MessBox('������ ������������ �������� ����� ���������: '+E.Message);
  end;
end;

end.


