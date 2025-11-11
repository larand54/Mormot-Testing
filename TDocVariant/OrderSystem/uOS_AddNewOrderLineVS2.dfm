object frmAddNewOrderLineVS2: TfrmAddNewOrderLineVS2
  Left = 0
  Top = 0
  Caption = 'Add New OrderLine'
  ClientHeight = 97
  ClientWidth = 560
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
    Left = 240
    Top = 49
    Width = 31
    Height = 15
    Caption = 'Antal:'
  end
  object Label2: TLabel
    Left = 24
    Top = 49
    Width = 76
    Height = 15
    Caption = 'Produkt namn'
  end
  object Label3: TLabel
    Left = 24
    Top = 8
    Width = 49
    Height = 15
    Caption = 'V'#228'lj order'
  end
  object Label4: TLabel
    Left = 320
    Top = 49
    Width = 25
    Height = 15
    Caption = 'Dim:'
  end
  object btnAddNewOrderLine: TBitBtn
    Left = 421
    Top = 64
    Width = 123
    Height = 25
    Caption = 'Add orderLine'
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 0
    OnClick = btnAddNewOrderLineClick
  end
  object edProduct: TEdit
    Left = 24
    Top = 65
    Width = 193
    Height = 23
    TabOrder = 1
    Text = 'edProduct'
  end
  object cbOrder: TComboBox
    Left = 24
    Top = 23
    Width = 145
    Height = 23
    TabOrder = 2
    Text = 'cbOrder'
  end
  object edQty: TEdit
    Left = 240
    Top = 66
    Width = 57
    Height = 23
    TabOrder = 3
    Text = 'edQty'
  end
  object cbQtyType: TComboBox
    Left = 320
    Top = 65
    Width = 81
    Height = 23
    TabOrder = 4
    Text = 'cbQtyType'
  end
end
