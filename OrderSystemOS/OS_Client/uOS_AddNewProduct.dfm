object frmAddProduct: TfrmAddProduct
  Left = 0
  Top = 0
  Caption = 'Add Product'
  ClientHeight = 118
  ClientWidth = 386
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 42
    Height = 15
    Caption = 'Produkt'
  end
  object Label2: TLabel
    Left = 8
    Top = 74
    Width = 22
    Height = 15
    Caption = 'Pris:'
  end
  object btnAddProduct: TBitBtn
    Left = 303
    Top = 85
    Width = 75
    Height = 25
    Caption = 'Add Product'
    TabOrder = 0
    OnClick = btnAddProductClick
  end
  object edProductName: TEdit
    Left = 8
    Top = 29
    Width = 370
    Height = 23
    TabOrder = 1
    Text = 'edProductName'
  end
  object nmbrPrice: TNumberBox
    Left = 8
    Top = 87
    Width = 121
    Height = 23
    TabOrder = 2
  end
end
