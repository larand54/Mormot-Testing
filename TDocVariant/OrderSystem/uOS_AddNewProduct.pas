unit uOS_AddNewProduct;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.NumberBox;

type
  TfrmAddProduct = class(TForm)
    btnAddProduct: TBitBtn;
    edProductName: TEdit;
    nmbrPrice: TNumberBox;
    Label1: TLabel;
    Label2: TLabel;
    procedure btnAddProductClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAddProduct: TfrmAddProduct;

implementation

uses
  uOS_Server, uOS_Data;

{$R *.dfm}

procedure TfrmAddProduct.btnAddProductClick(Sender: TObject);
var
  OS_Server: TOS_Client;
  newProduct: TOrmProduct;
begin
  OS_Server := initServer;
  newProduct := TOrmProduct.Create;
  newProduct.Name := edProductName.text;
  newProduct.Price := nmbrPrice.Value;
  newProduct.Currency := nmbrPrice.CurrencyString;
  addProduct(OS_Server, newProduct);

  newProduct.Free;
  OS_Server.Model.Free;
  OS_Server.Free;

end;

end.
