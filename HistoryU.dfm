object HistoryF: THistoryF
  Left = 409
  Top = 261
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'HistoryF'
  ClientHeight = 364
  ClientWidth = 705
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    705
    364)
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 1
    Top = 1
    Width = 703
    Height = 32
    Anchors = [akLeft, akTop, akRight]
    BevelOuter = bvLowered
    TabOrder = 0
    DesignSize = (
      703
      32)
    object imHistory: TImage
      Left = 678
      Top = 9
      Width = 16
      Height = 16
      Anchors = [akRight, akBottom]
      AutoSize = True
      Picture.Data = {
        07544269746D617036030000424D360300000000000036000000280000001000
        000010000000010018000000000000030000130B0000130B0000000000000000
        0000C8D0D4C8D0D4C8D0D4C8D0D44273845A6B6BC8D0D4C8D0D4C8D0D4C8D0D4
        C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4089C
        D6218CB531738C6B6B6BC8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8
        D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D431ADF721A5E7218CAD5A6B6BC8D0D4
        C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
        D431A5D64AB5FF29A5EF2184AD636B6BC8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8
        D0D4C8D0D4C8D0D4C8D0D46B7B7B63737B319CBD5AC6FF4AB5FF21A5E729738C
        6B7373C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4399CBD31B5E742C6
        EF5ACEFF63CEFF5ACEFF4ABDF721A5E7218CB539738C5A6B6BC8D0D4C8D0D4C8
        D0D4C8D0D442A5CE63D6FF73DEFF73DEFF6BD6FF6BD6FF63CEFF63CEFF52BDFF
        39ADF7189CE7188CB5636B6BC8D0D4C8D0D48CADB56BD6EF7BE7FF6BDEFF42BD
        EF42BDF742BDEF42BDEF4ABDF752C6F752BDFF4AB5FF29A5F71894C64A6B73C8
        D0D442B5DEBDF7FF84EFFF73E7FF5AD6F752CEF74AC6EF42BDF739BDEF31B5EF
        52C6FF52BDFF4AB5FF29A5F71884B56B7B7B39B5DEC6F7FF84EFFF7BE7FF5ACE
        F752C6F752CEF752CEF752CEF752CEF752C6FF52C6FF52BDFF42B5FF21A5E74A
        737B39B5DECEFFFF94F7FF7BE7FF5AD6F74ACEEF42C6EF39BDEF39BDF729B5EF
        29B5E729ADE752C6FF52BDFF31ADEF52738439A5C6BDEFF7B5F7FF84EFFF6BDE
        F76BDEF763DEFF6BDEFF63D6FF5ACEF75AD6F75AC6FF63CEFF63CEFF39B5EF52
        737BC8D0D45AC6E7DEF7FF94EFFF42C6E742C6E739BDEF42BDEF39BDEF31BDEF
        31B5E739B5EF63CEFF63D6FF4AA5CE7B8C8CC8D0D4C8D0D46BCEE7D6F7FFCEF7
        FF9CF7FF8CEFFF84E7FF7BE7FF73DEFF6BDEFF63D6F76BD6FF52C6F74A849CC8
        D0D4C8D0D4C8D0D4C8D0D463A5BD73CEEFA5DEEFB5E7F7ADEFF7B5EFFFB5EFFF
        94E7F752CEF742B5E7739CADC8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
        D463A5BD63C6E763BDDE52BDDE52BDDE5ABDDE7BA5B5C8D0D4C8D0D4C8D0D4C8
        D0D4}
      Transparent = True
    end
    object ComboBox1: TComboBox
      Left = 5
      Top = 5
      Width = 186
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 0
      Text = #1055#1086#1089#1083#1077#1076#1085#1080#1077' 10 '#1089#1086#1086#1073#1097#1077#1085#1080#1081
      OnChange = ComboBox1Change
      Items.Strings = (
        #1055#1086#1089#1083#1077#1076#1085#1080#1077' 10 '#1089#1086#1086#1073#1097#1077#1085#1080#1081
        #1055#1086#1089#1083#1077#1076#1085#1080#1077' 30 '#1089#1086#1086#1073#1097#1077#1085#1080#1081
        #1055#1086#1089#1083#1077#1076#1085#1080#1077' 50 '#1089#1086#1086#1073#1097#1077#1085#1080#1081
        #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1089#1086#1086#1073#1097#1077#1085#1080#1103)
    end
    object CheckBox1: TCheckBox
      Left = 200
      Top = 7
      Width = 211
      Height = 17
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1087#1088#1086#1095#1080#1090#1072#1085#1085#1099#1077' '#1089#1086#1086#1073#1097#1077#1085#1080#1103
      TabOrder = 1
      OnClick = CheckBox1Click
    end
  end
  object Panel2: TPanel
    Left = 1
    Top = 35
    Width = 703
    Height = 295
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvLowered
    TabOrder = 1
    DesignSize = (
      703
      295)
    object DBGrid1: TDBGrid
      Left = -1
      Top = -1
      Width = 704
      Height = 296
      Anchors = [akLeft, akTop, akRight, akBottom]
      Color = 16311249
      DataSource = DM.srHistory
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Options = [dgTitles, dgIndicator, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
      ParentFont = False
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnDrawColumnCell = DBGrid1DrawColumnCell
      OnDblClick = DBGrid1DblClick
      Columns = <
        item
          Expanded = False
          FieldName = 'Users'
          Title.Alignment = taCenter
          Title.Caption = #1054#1090' '#1082#1086#1075#1086
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clNavy
          Title.Font.Height = -11
          Title.Font.Name = 'MS Sans Serif'
          Title.Font.Style = [fsBold]
          Width = 120
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DateM'
          Title.Alignment = taCenter
          Title.Caption = #1044#1072#1090#1072
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clNavy
          Title.Font.Height = -11
          Title.Font.Name = 'MS Sans Serif'
          Title.Font.Style = [fsBold]
          Width = 121
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Mess'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Title.Alignment = taCenter
          Title.Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1077
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clNavy
          Title.Font.Height = -11
          Title.Font.Name = 'MS Sans Serif'
          Title.Font.Style = [fsBold]
          Width = 426
          Visible = True
        end>
    end
  end
  object Panel3: TPanel
    Left = 1
    Top = 332
    Width = 703
    Height = 31
    Anchors = [akLeft, akRight, akBottom]
    BevelOuter = bvLowered
    TabOrder = 2
    DesignSize = (
      703
      31)
    object BitBtn2: TBitBtn
      Left = 577
      Top = 3
      Width = 116
      Height = 25
      Anchors = [akTop]
      Cancel = True
      Caption = #1047#1072#1082#1088#1099#1090#1100
      TabOrder = 0
      OnClick = BitBtn2Click
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        04000000000080000000D40E0000D40E00001000000010000000000059002424
        500026266900FF0000000101BD002929AF005D5DBB000707C8002828CA000000
        F5002626F4006161D300A4A4D500D1D1DA00D7D7F200E3E3E400333E20000001
        F33333E8744444441F333E874474444441F3E87844578578741F84DEC5C4EEBD
        844194EBC8D4FBCCB44077BBC8D4FBCCFC40947BC5D4FBCD6C40746F88D4FBCC
        BD4094DB88D4FBCCBD4094EBC7E4FBCCBD40A7CECCF6DDBEDC42EA8888888878
        B45F3EA74444444445E333EA777777745F33333EA9999995E333}
    end
    object bbView: TBitBtn
      Left = 4
      Top = 3
      Width = 177
      Height = 25
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1089#1086#1086#1073#1097#1077#1085#1080#1103'...'
      TabOrder = 1
      OnClick = bbViewClick
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000C40E0000C40E00000000000000000000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F673F247F4F30673F247F7F7FFFFFFFFF
        FFFFFFFFFFFFFFFF7F7F7F673F247F4F30673F247F7F7FFFFFFF7F7F7F9B6F30
        DFCFABF3EBDBF7E7CBD38F58574B3FFFFFFFFFFFFF7F7F7F9B6F30DFCFABF3EB
        DBF7E7CBD38F58574B3F4F3000CF9F63DFB79FE3D3AFEFE7D7F3E7AB875737BF
        BFBFC7C7C74F3000CF9F63DFB79FE3D3AFEFE7D7F3E7AB8757374F3000CF9F73
        D7AB83D7B79FDFC39FEFCF8B6F57277F7F7F8F8F8F4F3000CF9F73D7AB83D7B7
        9FDFC39FEFCF8B6F5727171717AB6F0CCF9F67CF9F57CFAB7F9B57302F2F2F7F
        7F7F8F8F8F202020AB6F0CCF9F67CF9F57CFAB7F9B57300B0B0BA3A3A3807468
        5B300C6730186730184747474F4F4F7F7F7F8F8F8FCBCBCB584C405B300C6730
        18673018171717282828D7D7D7C3C3C3BFBFBF8888887070705F5F5F4F4F4F7F
        7F7F8F8F8FDFDFDFB8B8B88888887070706B6B6B4F4F4F8B8B8BFFFFFFABABAB
        D7D7D7A0A0A07878786767675757570000000F0F0FDFDFDFB8B8B88888887070
        70636363282828FFFFFFFFFFFFD7D7D79B9B9B8F8F8F7373736767675757572C
        2C2C3B3B3B9F9F9F8B8B8B7373736767674F4F4F8B8B8BFFFFFFFFFFFFFFFFFF
        ABABABC7C7C7AFAFAF8484845353534848485B5B5BDFDFDFB4B4B49C9C9C7878
        78282828FFFFFFFFFFFFFFFFFFFFFFFFD7D7D7C3C3C3BFBFBF8888885858580F
        0F0F1F1F1FDFDFDFB8B8B88484845858588B8B8BFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFABABABD3D3D3A0A0A05C5C5C6F6F6F777777DFDFDFB8B8B87C7C7C2828
        28FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD7D7D7C3C3C3C7C7C79B9B9B6F
        6F6F777777AFAFAFC7C7C75B5B5B838383FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFAFAFAF505050333333FFFFFFFFFFFF7777774C4C4C535353FFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
    end
  end
end
