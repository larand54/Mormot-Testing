object frmAddNewOrderLineVS1: TfrmAddNewOrderLineVS1
  Left = 0
  Top = 0
  Caption = 'uOS_AddNewOrderLineVS1'
  ClientHeight = 338
  ClientWidth = 571
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
  object Label4: TLabel
    Left = 320
    Top = 49
    Width = 25
    Height = 15
    Caption = 'Dim:'
  end
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
  object cbQtyType: TComboBox
    Left = 320
    Top = 65
    Width = 81
    Height = 23
    TabOrder = 1
    Text = 'cbQtyType'
  end
  object edQty: TEdit
    Left = 240
    Top = 66
    Width = 57
    Height = 23
    TabOrder = 2
    Text = 'edQty'
  end
  object edProduct: TEdit
    Left = 24
    Top = 65
    Width = 193
    Height = 23
    TabOrder = 3
    Text = 'edProduct'
  end
  object cbOrder: TComboBox
    Left = 24
    Top = 23
    Width = 145
    Height = 23
    TabOrder = 4
    Text = 'cbOrder'
    OnChange = cbOrderChange
  end
  object Button1: TButton
    Left = 416
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 5
    OnClick = Button1Click
  end
  object ListBox3: TListBox
    Left = 360
    Top = 113
    Width = 121
    Height = 193
    ItemHeight = 15
    TabOrder = 6
  end
  object ListBox2: TListBox
    Left = 216
    Top = 113
    Width = 121
    Height = 193
    ItemHeight = 15
    TabOrder = 7
  end
  object ListBox1: TListBox
    Left = 64
    Top = 113
    Width = 121
    Height = 193
    ItemHeight = 15
    TabOrder = 8
  end
end
