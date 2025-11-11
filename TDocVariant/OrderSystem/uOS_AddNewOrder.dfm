object frmAddOrder: TfrmAddOrder
  Left = 0
  Top = 0
  Caption = 'Add order'
  ClientHeight = 119
  ClientWidth = 389
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object Label1: TLabel
    Left = 26
    Top = 11
    Width = 33
    Height = 15
    Caption = 'Klient:'
  end
  object Label2: TLabel
    Left = 25
    Top = 72
    Width = 79
    Height = 15
    Caption = 'Ordernummer:'
  end
  object btnAddOrder: TBitBtn
    Left = 248
    Top = 24
    Width = 133
    Height = 25
    Caption = 'Skapa ny order'
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 0
    OnClick = btnAddOrderClick
  end
  object cbClient: TComboBox
    Left = 24
    Top = 25
    Width = 145
    Height = 23
    TabOrder = 1
    Text = 'cbClient'
  end
  object edOrderNo: TEdit
    Left = 24
    Top = 88
    Width = 145
    Height = 23
    TabOrder = 2
    Text = 'edOrderNo'
  end
end
