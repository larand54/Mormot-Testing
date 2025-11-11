object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
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
  object Button1: TButton
    Left = 56
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 192
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 1
    OnClick = Button2Click
  end
  object ListBox1: TListBox
    Left = 64
    Top = 128
    Width = 121
    Height = 193
    ItemHeight = 15
    TabOrder = 2
  end
  object ListBox2: TListBox
    Left = 216
    Top = 128
    Width = 121
    Height = 193
    ItemHeight = 15
    TabOrder = 3
  end
  object ListBox3: TListBox
    Left = 360
    Top = 128
    Width = 121
    Height = 193
    ItemHeight = 15
    TabOrder = 4
  end
end
