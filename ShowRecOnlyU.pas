unit ShowRecOnlyU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TShowRecOnlyF = class(TForm)
    BitBtn1: TBitBtn;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private

  public

  end;

var ShowRecOnlyF:TShowRecOnlyF;

implementation

uses MainU;

{$R *.dfm}

procedure TShowRecOnlyF.FormCreate(Sender: TObject);
 begin
  Caption:=MFC;
  Label1.Caption:='��������!!!! �������� ������'#10' ������ �������� �� ������ ��������� ���������� ������ �� ������������ �������!!!!! ������ ��������� ��� ������� ������ ��������!!!!'
 end;

procedure TShowRecOnlyF.BitBtn1Click(Sender: TObject);
 begin
  Close;
 end;

end.
