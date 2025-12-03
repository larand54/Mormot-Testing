unit uOS_AddNewProduct;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.NumberBox
  , mormot.net.client
  , mormot.rest.http.client
  , uClient_OrderService
;

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
    fOSService: TOrderSystemService;
  public
    { Public declarations }
   constructor Create(Sender: TComponent; const pmcServer: TOrderSystemService); reintroduce;
  end;

var
  frmAddProduct: TfrmAddProduct;

implementation

uses
  uOS_Data
  , IOrderSystemInterfaces
;
{$R *.dfm}

procedure TfrmAddProduct.btnAddProductClick(Sender: TObject);
var
  service: IOrderSystem;
  newProduct: TProduct;
begin
  newProduct := TProduct.create;
  if not fOSService.Client.Resolve(IOrderSystem, service) then Exit; //=>
  newProduct.Name := edProductName.text;
  newProduct.Price := nmbrPrice.Value;
  newProduct.Currcy := nmbrPrice.CurrencyString;
  service.AddProduct(newProduct);
  newProduct.Free;
end;

constructor TfrmAddProduct.Create(Sender: TComponent;
  const pmcServer: TOrderSystemService);
begin
  inherited create(sender);
  fOSService := pmcServer;
end;

end.
