object SecureFtpServer: TSecureFtpServer
  Left = 222
  Top = 140
  Width = 580
  Height = 549
  Caption = 'FTP Server'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 241
    Top = 91
    Width = 28
    Height = 13
    Caption = #1055#1086#1088#1090':'
  end
  object Button1: TButton
    Left = 8
    Top = 55
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 8
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Stop'
    Enabled = False
    TabOrder = 1
    OnClick = Button2Click
  end
  object ListBox1: TListBox
    Left = 8
    Top = 120
    Width = 393
    Height = 385
    ItemHeight = 13
    TabOrder = 2
  end
  object Edit1: TEdit
    Left = 88
    Top = 56
    Width = 281
    Height = 21
    TabOrder = 3
    Text = 'C:\SEMEN'
    OnChange = Edit1Change
  end
  object SpinEdit1: TSpinEdit
    Left = 280
    Top = 88
    Width = 121
    Height = 22
    MaxValue = 65535
    MinValue = 1
    TabOrder = 4
    Value = 21
    OnChange = SpinEdit1Change
  end
  object Button3: TButton
    Left = 373
    Top = 55
    Width = 26
    Height = 22
    Caption = '...'
    TabOrder = 5
    OnClick = Button3Click
  end
  object EditKey: TEdit
    Left = 88
    Top = 24
    Width = 281
    Height = 21
    TabOrder = 6
    Text = 'KEYSTR'
  end
  object IdFTPServer1: TIdFTPServer
    Bindings = <>
    CommandHandlers = <>
    DefaultPort = 21
    Greeting.NumericCode = 220
    Greeting.Text.Strings = (
      'Indy FTP Server ready.')
    Greeting.TextCode = '220'
    MaxConnectionReply.NumericCode = 0
    ReplyExceptionCode = 0
    ReplyTexts = <>
    ReplyUnknownCommand.NumericCode = 500
    ReplyUnknownCommand.Text.Strings = (
      'Syntax error, command unrecognized.')
    ReplyUnknownCommand.TextCode = '500'
    AnonymousAccounts.Strings = (
      'anonymous'
      'ftp'
      'guest')
    SystemType = 'WIN32'
    Left = 40
    Top = 16
  end
  object OpenDialog1: TOpenDialog
    Left = 8
    Top = 16
  end
end
