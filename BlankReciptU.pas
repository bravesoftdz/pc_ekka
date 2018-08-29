unit BlankReciptU;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
     Dialogs, ExtCtrls, StdCtrls, Buttons, PrintReport, Util;

type
  TBlankReciptF = class(TForm)
    Panel1: TPanel;
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Label4: TLabel;
    Label1: TLabel;
    Label5: TLabel;
    Edit4: TEdit;
    Label6: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label9: TLabel;
    Edit7: TEdit;
    Label10: TLabel;
    Edit8: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);

  private

    FKol:Integer;
    FFlag:Integer;
    FName: String;

  public

    property Kol:Integer read FKol write FKol;
    property Flag:Integer read FFlag write FFlag;
    property Names:String read FName write FName;

  end;

var BlankReciptF:TBlankReciptF;

implementation

uses MainU;

{$R *.dfm}

procedure TBlankReciptF.FormCreate(Sender: TObject);
 begin
  Caption:=MFC;
  Flag:=0;
 end;

procedure TBlankReciptF.BitBtn1Click(Sender: TObject);
 begin
  if Edit1.Text='' then
   begin
    MainF.MessBox('������� �������� � ���� "�������"!');
    Edit1.SetFocus;
   end else
  if Edit2.Text='' then
   begin
    MainF.MessBox('������� �������� � ���� "���"!');
    Edit2.SetFocus;
   end else
  if Edit3.Text='' then
   begin
    MainF.MessBox('������� �������� � ���� "��������"!');
    Edit3.SetFocus;
   end else
  if Edit7.Text='' then
   begin
    MainF.MessBox('������� �������� � ���� "�������"!');
    Edit7.SetFocus;
   end else
  if Edit8.Text='' then
   begin
    MainF.MessBox('������� �������� � ���� "�����"!');
    Edit8.SetFocus;
   end else
  if Edit4.Text='' then
   begin
    MainF.MessBox('������� �������� � ���� "�������"!');
    Edit4.SetFocus;
   end else
  if Edit5.Text='' then
   begin
    MainF.MessBox('������� �������� � ���� "���"!');
    Edit5.SetFocus;
   end else                                                                               
  if Edit6.Text='' then
   begin
    MainF.MessBox('������� �������� � ���� "��������"!');
    Edit6.SetFocus;
   end else begin
             try
              PrintRep.Clear;
              PrintRep.SetDefault;
              PrintRep.Stretch:=True;
              PrintRep.Align:=AL_RIGHT;
              if FileExists(WorkPath+'\Farmasta1.bmp') then PrintRep.AddImage(WorkPath+'\Farmasta1.bmp',22);
              PrintRep.Font.Name:='Arial';
              PrintRep.Font.Size:=7;
              PrintRep.Align:=AL_CENTER;
              PrintRep.Font.Size:=6;
              PrintRep.AddText(#10#10'��� �������i ��������� "'+Names+'"'#10#10#10#10);
              PrintRep.Align:=AL_LEFT;
              PrintRep.AddText('�.I.�. ���i���� '+UpperLowerStr(Edit1.Text)+' '+UpperLowerStr(Edit2.Text)+' '+UpperLowerStr(Edit3.Text)+#10#10);
              PrintRep.AddText('���.: '+Edit7.Text+#10#10);
              PrintRep.AddText('�i��� '+Edit8.Text+#10#10#10);
              PrintRep.AddText('�.I.�. �i���� '+UpperLowerStr(Edit4.Text)+' '+UpperLowerStr(Edit5.Text)+' '+UpperLowerStr(Edit6.Text)+#10#10#10);
              PrintRep.AddText('�������� ��������'+#10#10#10);
              PrintRep.AddText(Names+' � �i������i '+IntToStr(Kol)+' ��.'+#10#10#10#10#10);
              PrintRep.AddText('�i���� ___________________   ���� '+DateToStr(Date)+#10#10#10#10+'�������'#10#10#10);
              PrintRep.Align:=AL_RIGHT;
              if FileExists(WorkPath+'\Farmasta2.bmp') then PrintRep.AddImage(WorkPath+'\Farmasta2.bmp',22);
              PrintRep.Print;
              MainF.MessBox('�� ������� ���������� ���������� ����� �������! �� ������� �������� �� � ����, � ����� �������!');
              Flag:=1;
              Close;
             except
             end;
            end;
 end;

procedure TBlankReciptF.BitBtn2Click(Sender: TObject);
 begin
  Close;
 end;

end.



