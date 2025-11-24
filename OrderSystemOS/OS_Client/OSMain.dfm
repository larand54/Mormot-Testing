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
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object lbl1: TLabel
    Left = 240
    Top = 16
    Width = 94
    Height = 21
    Caption = 'List of orders:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object btnAddCustomer: TButton
    Left = 56
    Top = 13
    Width = 105
    Height = 25
    Caption = 'Add customer'
    TabOrder = 0
    OnClick = btnAddCustomerClick
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
  object lstOrders: TListBox
    Left = 240
    Top = 40
    Width = 369
    Height = 337
    ItemHeight = 15
    TabOrder = 4
  end
  object btnUpdateListOfOrders: TButton
    Left = 344
    Top = 400
    Width = 161
    Height = 25
    Caption = 'Update list of orders'
    TabOrder = 5
    OnClick = btnUpdateListOfOrdersClick
  end
end
