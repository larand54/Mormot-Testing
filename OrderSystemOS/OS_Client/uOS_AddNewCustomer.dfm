object frmAddCustomer: TfrmAddCustomer
  Left = 0
  Top = 0
  Caption = 'frmAddCustomer'
  ClientHeight = 127
  ClientWidth = 347
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object edCustomerName: TEdit
    Left = 24
    Top = 40
    Width = 153
    Height = 23
    TabOrder = 0
    Text = 'edCustomerName'
  end
  object edCustomerID: TEdit
    Left = 24
    Top = 80
    Width = 153
    Height = 23
    TabOrder = 1
    Text = 'edCustomerID'
  end
  object BitBtn1: TBitBtn
    Left = 216
    Top = 39
    Width = 75
    Height = 25
    Caption = 'Add'
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 2
    OnClick = BitBtn1Click
  end
end
