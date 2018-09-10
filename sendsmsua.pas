unit SendSmsUA;
{*******************************************************************************
 *******************************************************************************
*   insert into SPR_CONST(Descr, Value) values ('SMSServ', 'SMSUA')            *
*   insert into SPR_CONST(Descr, Value) values ('SMSServPWD', 'ljrnjh[fec')    *
*   insert into SPR_CONST(Descr, Value) values ('SMSServLog', 'apteka-9-1-1')*
********************************************************************************
*******************************************************************************}

interface
uses
  SysUtils, Classes;

const
  LibraryName = 'smscua.dll';

type
  TSMSConfirmStatus = (stSendError, stOK, stNotConfirm, stNotActive);

type
  { ���� ������� �� ����������  smscua.dll }
  TSendSMSFunc =  function ( Login : PAnsiChar; Pass : PAnsiChar; Phones: PAnsiChar; mes: PAnsiChar) : integer; stdcall;
  TGetBalanceSMSFunc =  function(aLogin : PAnsiChar; aPassword : PAnsiChar) : Double; stdcall;

  { ���� ���������� ��� ������ � ������� �������� ��� }
    { ������ �������� ���������� }
  ELoadLibraryError = class(Exception);
    { ������, ���� ���������� �� ���������� ( ������ ���� � �������� � ������� ����������) }
  EFileNotFoundError = class(Exception);
    { ������, ������� �� ���������� }
  EProceureNofFoundError = class(Exception);
type

  TSendSms = class(TComponent)
  private
    fLogin : String;
    fPassword : String;
    IsSMSUAActive : Boolean;
    function GetActive: Boolean;
  private
    { Handle �� ���������� LibraryName }
    HndLib : THandle;
    { ������ �� ������������  ������� SendSMS �� dll LibraryName }
    fSendSMS : TSendSMSFunc;
    { ������ �� ������������  ������� GetBalance �� dll LibraryName }
    fGetBalance : TGetBalanceSMSFunc;
    procedure loadLibraryAndFunc;
    procedure UnLoadLibrary;

  public
    constructor Create(aOwner : TComponent); overload;
    constructor Create(aOwner : TComponent; aLogin, aPassword : String); overload;
    destructor Destroy;
    { ���������� SMS }
    function SendSMS(aPhone : String; aMessage : String) : integer;
    { �������� ������� ������ }
    function GetBalance : Double;
    { Active  = True ���� ���������� LibraryName ���������� �
      ������� fSendSMS � fGetBalance �������� }
    property Active : Boolean read GetActive;
   { �������� ��� � ����� ������������� ��� ����������� ��������
     �������� ��� �������� ����� ���� www.smsc.ua}
    function RegCard_SMSUA(P1,P2,P3 : String; IsLink : Boolean) : TSMSConfirmStatus;

  end;

implementation
uses
  WinProcs, Windows,
  DataModuleU, MainU, util, Graphics, CheckSMSKodU;
{ TSendSms }

constructor TSendSms.Create(aOwner : TComponent; aLogin, aPassword : String);
begin
  inherited Create(aOwner);
  HndLib := 0;
  @fSendSMS := nil;
  @fGetBalance := nil;
  { ������������� ������ � ������ }
  fLogin := aLogin;
  fPassword := aPassword;
  { �������� ��� � ������������� ������ �� ������� �� ���������� }
  loadLibraryAndFunc;
  IsSMSUAActive := False;
  try
    DM.QrEx.Close;
    DM.QrEx.SQL.Clear;
    DM.QrEx.SQL.Add(' select IsNULL((select Value from SPR_CONST where descr = ''SMSServ''),''default'') ServiceName ');
    DM.QrEx.Open;
    if not DM.QrEx.Eof then
       IsSMSUAActive := UpperCase(DM.QrEx.FieldByName('ServiceName').AsString) = 'SMSUA';
    DM.QrEx.Close;
  except

  end;
end;

constructor TSendSms.Create(aOwner: TComponent);
var
  Login, Pass : string;
begin
  Login := '';
  Pass := '';
  try

    DM.QrEx.Close;
    DM.QrEx.SQL.Clear;
    DM.QrEx.SQL.Add('select (select Value from SPR_CONST where descr = ''SMSServLog'') SMSLog, ');
    DM.QrEx.SQL.Add('       (select Value from SPR_CONST where descr = ''SMSServPWD'') SMSPWD ');
    DM.QrEx.Open;
    if not DM.QrEx.Eof then
    begin
      Login := DM.QrEx.FieldByName('SMSLog').AsString;
      Pass  := DM.QrEx.FieldByName('SMSPWD').AsString;
    end;
    DM.QrEx.Close;
  except

  end;
  Create(aOwner, Login, Pass);
end;

destructor TSendSms.Destroy;
begin
  UnLoadLibrary;
end;

function TSendSms.GetActive: Boolean;
begin
  Result := (HndLib <> 0) and (@fGetBalance <> nil) and (@fSendSMS <> nil) and IsSMSUAActive;
end;

{ ������� ��������� ������� � ������������ }
function TSendSms.GetBalance : Double;
begin
  if  (@fGetBalance = nil)  then
    raise EProceureNofFoundError.Create('��������� GetBalance �� ���������');

  Result := fGetBalance( PAnsiChar(AnsiString(fLogin)),
                         PAnsiChar(AnsiString(fPassword)));
end;

{ �������� ��������� � ������������� ������ �� ������� }
procedure TSendSms.loadLibraryAndFunc;
begin
  if not FileExists(LibraryName) then
    raise EFileNotFoundError.Create('Can''t load library '+LibraryName);

  HndLib := LoadLibrary(LibraryName);
  if HndLib = 0 then
    raise ELoadLibraryError.Create('Can''t load library '+LibraryName);

   @fGetBalance := GetProcAddress(HndLIb, 'GetBalance');
   @fSendSMS := GetProcAddress(HndLIb, 'SendSMS');
end;

{ �������� ��� �  ������ ������������� ��� ����������� �������� }
{ �������� ��� �������� ����� ���� www.smsc.ua}
function TSendSms.RegCard_SMSUA(P1, P2, P3: String; IsLink: Boolean): TSMSConfirmStatus;
var
  sKod : String;
  PhoneNum : string;
  Res : String;
  { �������� ���������� ������� �������� � ��
    ���������� ������ �������� ����� �� P1, P2, P3
    � �������� Phone
    ����������
      True ���� �������� ������ ������ �����  - FALSE
  }
  function CheckPhone(out Phone : String) : boolean;
  begin
    Result := False;
    try
      try
        DM.QrEx.Close;
        DM.QrEx.SQL.Clear;
        DM.QrEx.SQL.Add(' begin ');
        DM.QrEx.SQL.Add(' declare @Ph1 varchar(25); ');
        DM.QrEx.SQL.Add(' declare @Ph2 varchar(25); ');
        DM.QrEx.SQL.Add(' declare @Ph3 varchar(25); ');
        DM.QrEx.SQL.Add(' declare @Phone varchar(15); ');
        DM.QrEx.SQL.Add(' set @Ph1=replace(replace(replace(replace('''+P1+''','' '',''''),''-'',''''),''('',''''),'')'','''') ');
        DM.QrEx.SQL.Add(' set @Ph2=replace(replace(replace(replace('''+P2+''','' '',''''),''-'',''''),''('',''''),'')'','''') ');
        DM.QrEx.SQL.Add(' set @Ph3=replace(replace(replace(replace('''+P3+''','' '',''''),''-'',''''),''('',''''),'')'','''') ');
        DM.QrEx.SQL.Add(' set @Phone='''' ');
        DM.QrEx.SQL.Add(' if dbo.CheckPhone(@Ph1)=1 set @Phone=@Ph1 else ');
        DM.QrEx.SQL.Add(' if dbo.CheckPhone(@Ph2)=1 set @Phone=@Ph2 else ');
        DM.QrEx.SQL.Add(' if dbo.CheckPhone(@Ph3)=1 set @Phone=@Ph3; ');
        DM.QrEx.SQL.Add(' select @Phone as Phone; ');
        DM.QrEx.SQL.Add(' end ');

        DM.QrEx.Open;
        Phone := DM.QrEx.FieldByName('Phone').AsString;
        DM.QrEx.close;
        Result := Phone <> '';
      except
        on Exception do ;
      end;
    finally
      DM.QrEX.Close;
    end;
  end;
begin
  Result := stNotConfirm;
  { ������ ����� ��� ��������� �� RegCardSMS ��� ������������� }
  if IsLink=False then
  begin
     Result := stOK;
     Exit;
  end;
  {}
  {------------------------------------------------------------}
  { �������� ��� �������� ����� ���� www.smsc.ua}
  if not Active
  then
  begin
    Result := stNotActive;
    Exit;
  end;
  try
       DM.QrEx.Close;
       DM.QrEx.SQL.Clear;
       DM.QrEx.SQL.Add(' select substring(convert(varchar(20),Rand()),3,4) as skod');
       DM.QrEx.Open;
       if DM.QrEx.IsEmpty or
          (DM.QrEx.FieldbyName('skod').AsString  = '')
       then
         Exit;
       { ������� ��������� ��� }
       sKod := DM.QrEx.FieldbyName('skod').AsString;

       {���������� �� ����� ����� ����� �������� ���}
       if not CheckPhone(PhoneNum) then
       begin
          Result := stSendError;
          MainF.MessBox('�� ������ ������� �������� ���������� ��������� SMS.'#10#10+
                        '��� ��� ����������� ���������� �����: '+sKod,
                        48,GetFont('MS Sans Serif',12,clBlue,[fsBold]),0,Res);

         Exit;
       end;
       { �������� ����������� ��� ������� }
       if SendSMS(StringReplace(PhoneNum,'+38', '', [rfIgnoreCase]), sKod) > 0 then
       begin { ������������ ��� }
         CheckSMSKodF := TCheckSMSKodF.Create(Self);
         try
           CheckSMSKodF.Kod:=sKod;
           CheckSMSKodF.ShowModal;
           if CheckSMSKodF.Flag<>1 then
           begin
             Result := stNotConfirm;
             Exit;
           end;
         finally
           CheckSMSKodF.Free;
         end;
         Result := stOk;
       end else begin
          Result := stSendError;
       end;
  except

  end;
end;

function TSendSms.SendSMS(aPhone, aMessage: String) : Integer;
begin
  if  (@fSendSMS = nil) then
    raise EProceureNofFoundError.Create('��������� SendSMS �� ���������');
  { ��������� ��� }
  Result := fSendSMS( PAnsiChar(AnsiString(fLogin)), PAnsiChar(AnsiString(fPassword)),PAnsiChar(AnsiString(aPhone)),PAnsiChar(AnsiString(aMessage)));
end;

{ ������������ �������� ��������� � �����������   LibraryName = 'smscua.dll'; }
procedure TSendSms.UnLoadLibrary;
begin
    fSendSMS := nil;
    fGetBalance := nil;
    FreeLibrary(HndLib);
end;

end.
