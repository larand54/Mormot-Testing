object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  PixelsPerInch = 96
  TextHeight = 15
  object btnAddClient: TButton
    Left = 56
    Top = 13
    Width = 105
    Height = 25
    Caption = 'Add client'
    TabOrder = 0
    OnClick = btnAddClientClick
  end
  object btnAddOrderLine: TButton
    Left = 56
    Top = 106
    Width = 105
    Height = 25
    Caption = 'Add OrderLine'
    TabOrder = 1
    OnClick = btnAddOrderLineClick
  end
  object btnAddProduct: TButton
    Left = 56
    Top = 44
    Width = 105
    Height = 25
    Caption = 'Add product'
    TabOrder = 2
    OnClick = btnAddProductClick
  end
  object btnAddOrder: TButton
    Left = 56
    Top = 75
    Width = 105
    Height = 25
    Caption = 'Add Order'
    TabOrder = 3
    OnClick = btnAddOrderClick
  end
  object Button1: TButton
    Left = 56
    Top = 130
    Width = 105
    Height = 25
    Caption = 'Add OrderLine'
    TabOrder = 4
    OnClick = Button1Click
  end
  object btnAddOrderLine_Simple: TButton
    Left = 56
    Top = 161
    Width = 105
    Height = 25
    Caption = 'Add OrderLine'
    TabOrder = 5
  end
end
